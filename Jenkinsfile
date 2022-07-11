@Library('github.com/releaseworks/jenkinslib') _
pipeline {
    agent any
    environment {
        AWS_REGION = "${env.AWS_REG}"
        AWS_ID_NUM = "${env.AWS_ID_NUM}"
        DB_NAME = "${env.DB_NAME}"
        DB_HOST = "${env.DB_HOST}"
        DB_PORT = "${env.DB_PORT}"
        DB_USER = "${env.DB_USER}"
        DB_PASSWORD = "${env.DB_PASSWORD}"
        AWS_ECR = "${env.AWS_ECR}"
        VPC_ID = "${env.VPC_ID}"
        MICRO_SG = "${env.MICRO_SG}"
        ENCRYPT_SECRET_KEY = "${env.ENCRYPT_SECRET_KEY}"
        JWT_SECRET_KEY = "${env.JWT_SECRET_KEY}"
        APP_SERVICE_HOST = "${env.APP_SERVICE_HOST}"
        LB_ARN = "${env.LB_ARN}"
        AWS_ACCESS_KEY_ID = "${AWS_ACCESS_KEY_ID}"
        AWS_SECRET_ACCESS_KEY = "${AWS_SECRET_ACCESS_KEY}"
    }
    stages {
        stage ('AWS login'){
            steps {
                withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'aws-credentials', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    sh "aws ecr get-login-password --region ${AWS_REG} | docker login --username AWS --password-stdin ${AWS_ID_NUM}.dkr.ecr.${AWS_REG}.amazonaws.com"
                }
            }
        }
        stage ('MVN Test') {
            steps {
                sh 'mvn test -Dmaven.test.failure.ignore=true'
            }
        }
        stage('Sonarqube Test') {
            steps {
                withSonarQubeEnv(installationName: 'SQ1'){
                    sh 'mvn clean verify sonar:sonar -Dmaven.test.failure.ignore=true'
                }
            }
        }
        stage('Quality Gate') {
            steps {
                waitForQualityGate abortPipeline: true
            }
        }
        stage('Build Jar') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
        stage('build image') {
            steps {
                sh 'docker context use default'
                sh 'docker build -t account-microservice .'
            }
        }
        stage('tag image') {
            steps {
                sh "docker tag account-microservice ${AWS_ID_NUM}.dkr.ecr.${AWS_REG}.amazonaws.com/aline-account-microservice:pipeline-latest"
            }
        }
        stage('push') {
            steps {
                sh "docker push ${AWS_ID_NUM}.dkr.ecr.${AWS_REG}.amazonaws.com/aline-account-microservice:pipeline-latest"
            }
        }
        stage('ECS context creation') {
            steps {
                sh 'if [ -z "$(docker context ls | grep "jenkinsecs")" ]; then docker context create ecs jenkinsecs --from-env; fi'
                sh "docker context use jenkinsecs"
            }
        }
        stage('Docker Compose Up') {
            steps {
                sh "docker compose --file ./Docker-Compose-ES/Compose-ECS/compose.yaml --project-name aline-ECS-ES up -d"
            }
        }
    }
}