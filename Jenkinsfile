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
                withCredentials([[credentialsId: 'aws-creadentials-EliasSaundersSS']]) {
                    AWS "ecr get-login-password --region ${AWS_REG} | docker login --username AWS --password-stdin ${AWS_ID_NUM}.dkr.ecr.${AWS_REG}.amazonaws.com"
                }
            }
        }
        stage('pull') {
            steps {
                git branch: 'develop', credentialsId: 'login-PAK', url: 'https://github.com/flying-circus-capstone/aline-account-microservice-ES.git'
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
            agent any
            steps {
                sh 'docker build -t account-microservice .'
            }
        }
    }
}