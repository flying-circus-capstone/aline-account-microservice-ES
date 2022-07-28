@Library('github.com/releaseworks/jenkinslib') _
pipeline {
    agent any
    stages {
        // stage ('AWS login'){
        //     steps {
        //         withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'aws-credentials', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']]) {
        //             sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ID_NUM}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        //         }
        //     }
        // }
        // stage ('MVN Test') {
        //     steps {
        //         sh 'mvn test -Dmaven.test.failure.ignore=true'
        //     }
        // }
        // stage('Sonarqube Test') {
        //     steps {
        //         withSonarQubeEnv(installationName: 'SQ1'){
        //             sh 'mvn sonar:sonar -Dmaven.test.failure.ignore=true'
        //         }
        //     }
        // }
        // stage('Quality Gate') {
        //     steps {
        //         waitForQualityGate abortPipeline: true
        //     }
        // }
        // stage('Build Jar') {
        //     steps {
        //         sh 'mvn clean package -DskipTests'
        //     }
        // }
        // stage('build image') {
        //     steps {
        //         sh 'docker context use default'
        //         sh 'docker build -t account-microservice .'
        //     }
        // }
        // stage('tag image') {
        //     steps {
        //         sh "docker tag account-microservice ${AWS_ID_NUM}.dkr.ecr.${AWS_REGION}.amazonaws.com/aline-account-microservice:${VERSION_TAG}"
        //     }
        // }
        // stage('push') {
        //     steps {
        //         sh "docker push ${AWS_ID_NUM}.dkr.ecr.${AWS_REGION}.amazonaws.com/aline-account-microservice:${VERSION_TAG}"
        //     }
        // }
        stage('ECS context creation') {
            steps {
                sh 'if [ -z "$(docker context ls | grep "jenkinsecs")" ]; then docker context create ecs jenkinsecs --from-env; fi'
                sh "docker context use jenkinsecs"
            }
        }
        stage('Docker Compose Up') {
            steps {
                withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'aws-credentials', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    sh 'if [ "$(aws ecs describe-clusters --cluster aline-ecs-es | grep ""reason": "MISSING"")" ]; then docker compose --file ./Docker-Compose-ES/Compose-ECS/compose.yaml --project-name aline-ecs-es up -d; fi'
                    sh 'if [ "$(aws ecs describe-clusters --cluster aline-ecs-es | grep ""status": "ACTIVE"",)" ]; then docker compose --file ./Docker-Compose-ES/Compose-ECS/compose.yaml --project-name aline-ecs-es up -d; fi'
                    sh 'if [ -z "$(aws ecs describe-clusters --cluster aline-ecs-es | grep ""status": "ACTIVE"")" ]; then sleep 5m; docker compose --file ./Docker-Compose-ES/Compose-ECS/compose.yaml --project-name aline-ecs-es up -d; fi'
                }
            }
        }
    }
}