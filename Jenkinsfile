pipeline {
    agent {
        docker {
            image 'maven:3.8.5'
            args '-v /root/.m2:/root/.m2'
        }
    }
    stages {
        stage('pull') {
            steps {
                git branch: 'develop', credentialsId: 'login-PAK', url: 'https://github.com/flying-circus-capstone/aline-account-microservice-ES.git'
            }
        }
        stage('build jar') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
        stage('build image') {
            steps {
                sh 'docker build -t account-microservice .'
            }
        }
    }
}