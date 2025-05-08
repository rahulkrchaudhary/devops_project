pipeline {
    agent any

    environment {
        IMAGE_NAME = 'rahulkrchaudhary12/devops_project'
    }

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
                bat "docker build -t %IMAGE_NAME% ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
//                     bat """
//                         echo %PASSWORD% | docker login -u %USERNAME% --password-stdin
//                         docker push %IMAGE_NAME%
//                     """
                        bat """
                             echo DEBUG:--> Attempting Docker login with user %USERNAME% and %PASSWORD%
                             docker login -u %USERNAME% -p %PASSWORD%

                             echo DEBUG:--> Image to be pushed: ${IMAGE_NAME}
                             docker push ${IMAGE_NAME}
                        """
                }
            }
        }

//         stage('Deploy to Minikube') {
//             steps {
//                 bat """
//                     kubectl delete deployment devops-deployment --ignore-not-found=true
//                     kubectl delete service devops-service --ignore-not-found=true
//                     kubectl apply -f k8s/manifests/deployment.yaml
//                     kubectl apply -f k8s/manifests/service.yaml
//                 """
//             }
//         }
            stage('Deploy to Minikube') {
                steps {
                    withEnv(["KUBECONFIG=C:\\Users\\rahul\\.kube\\config"]) {
                        bat """
                            echo DEBUG: Using kubectl context:
                            kubectl config current-context

                            echo DEBUG: Deleting previous deployment and service...
                            kubectl delete deployment devops-deployment --ignore-not-found=true
                            kubectl delete service devops-service --ignore-not-found=true

                            echo DEBUG: Applying Kubernetes manifests...
                            kubectl apply -f k8s/manifests/deployment.yaml
                            kubectl apply -f k8s/manifests/service.yaml
                        """
                    }
                }
            }

    }
}
