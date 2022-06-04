@Library('github.com/releaseworks/jenkinslib') _
pipeline {
    agent any
    environment {
        AWS_REG = "${env.AWS_REG}"
        AWS_ID_NUM = "${env.AWS_ID_NUM}"
    }
    stages {
        stage ('AWS login'){
            steps {
                withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'aws-credentials', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    sh "aws ecr get-login-password --region ${AWS_REG} | docker login --username AWS --password-stdin ${AWS_ID_NUM}.dkr.ecr.${AWS_REG}.amazonaws.com"
                }
            }
        }
        stage('build jar') {
            agent {
                docker {
                    image 'maven:3.8.5'
                    args '-v /root/.m2:/root/.m2'
                }
            }
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
        stage('build image') {
            steps {
                sh 'docker build -t account-microservice .'
            }
        }
        stage('tag image') {
            steps {
                sh "docker tag account-microservice ${AWS_ID_NUM}.dkr.ecr.${AWS_REG}.amazonaws.com/aline-account-microservice:latest"
            }
        }
        stage('push') {
            steps {
                sh "docker push ${AWS_ID_NUM}.dkr.ecr.${AWS_REG}.amazonaws.com/aline-account-microservice:latest"
            }
        }
    }
}