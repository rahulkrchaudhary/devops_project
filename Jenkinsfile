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
                bat 'mvn clean package -DskipTests'
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
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    bat '''
                        echo %PASSWORD% | docker login -u %USERNAME% --password-stdin
                        docker push ${IMAGE_NAME}
                    '''

//                     bat """
//                         echo $PASSWORD | docker login -u $USERNAME --password-stdin
//                         docker push ${IMAGE_NAME}
//                     """
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                bat '''
                    kubectl delete deployment devops-deployment || true
                    kubectl delete service devops-service || true
                    kubectl apply -f k8s/manifests/deployment.yaml
                    kubectl apply -f k8s/manifests/service.yaml
                '''
            }
        }
    }
}
