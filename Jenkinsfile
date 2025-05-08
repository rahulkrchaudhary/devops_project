pipeline {
    agent any

    environment {
        IMAGE_NAME = 'rahulkrchaudhary12/devops_project'
    }

//     tools {
//         maven 'Maven 3' // Use the name you configured in Jenkins under Global Tools
//     }

    stages {
        stage('Clone Repository') {
            steps {
                checkout scm
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${IMAGE_NAME}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'cf74c998-3c04-4261-9e7a-bb2afae0be97', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh """
                        echo $PASSWORD | docker login -u $USERNAME --password-stdin
                        docker push ${IMAGE_NAME}
                    """
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                sh """
                    kubectl delete deployment devops-deployment || true
                    kubectl delete service devops-service || true
                    kubectl apply -f k8s/manifests/deployment.yaml
                    kubectl apply -f k8s/manifests/service.yaml
                """
            }
        }
    }
}
