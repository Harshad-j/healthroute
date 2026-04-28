pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = "harshadj"
        DOCKER_HUB_REPO = "healthroute"
        AWS_REGION = "us-east-1"
        EC2_USER = "ubuntu"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Images') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_HUB_USER}/${DOCKER_HUB_REPO}-frontend:latest ."
                    sh "docker build -t ${DOCKER_HUB_USER}/${DOCKER_HUB_REPO}-backend:latest ./server"
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh "echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin"
                    sh "docker push ${DOCKER_HUB_USER}/${DOCKER_HUB_REPO}-frontend:latest"
                    sh "docker push ${DOCKER_HUB_USER}/${DOCKER_HUB_REPO}-backend:latest"
                }
            }
        }

        stage('Infrastructure Provisioning (Terraform)') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Deploy to AWS') {
            steps {
                script {
                    def publicIp = sh(script: "cd terraform && terraform output -raw public_ip", returnStdout: true).trim()
                    sshagent(['aws-ec2-key']) {
                        sh """
                        ssh -o StrictHostKeyChecking=no ${EC2_USER}@${publicIp} "
                            docker-compose down || true
                            docker-compose pull
                            docker-compose up -d
                        "
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            sh "docker logout"
        }
    }
}
