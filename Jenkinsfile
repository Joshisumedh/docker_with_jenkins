pipeline {
    agent any

    environment {
        DOCKER_USER = 'sumedhsj'
        IMAGE_NAME  = "java-hello-world"
        REGISTRY_ID = "my-docker-hub-credentials-id"
    }

    stages {
        stage('Checkout & Compile') {
            steps {
                checkout scm
                sh 'javac HelloWorld.java'
            }
        }

        stage('Docker Build & Tag') {
            steps {
                echo 'Building and Tagging Image...'
                sh "docker build -t ${DOCKER_USER}/${IMAGE_NAME}:latest ."
                sh "docker tag ${DOCKER_USER}/${IMAGE_NAME}:latest ${DOCKER_USER}/${IMAGE_NAME}:${BUILD_NUMBER}"
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: REGISTRY_ID, passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER_ENV')]) {
                    sh "echo \$DOCKER_PASS | docker login -u \$DOCKER_USER_ENV --password-stdin"
                    
                    echo 'Pushing Image to DockerHub...'
                    sh "docker push ${DOCKER_USER}/${IMAGE_NAME}:latest"
                    sh "docker push ${DOCKER_USER}/${IMAGE_NAME}:${BUILD_NUMBER}"
                    
                    sh "docker logout"
                }
            }
        }
stage('Deploy to Kubernetes') {
            steps {
                script {
                    echo "Updating deployment.yaml with image tag: ${BUILD_NUMBER}"
                    // This command replaces ':latest' with the current build number
                    sh "sed -i 's|${DOCKER_USER}/${IMAGE_NAME}:latest|${DOCKER_USER}/${IMAGE_NAME}:${BUILD_NUMBER}|g' deployment.yaml"
                    
                    echo "Applying Kubernetes Configuration..."
                    sh "kubectl apply -f deployment.yaml"
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    echo "Waiting for pods to be ready..."
                    // Corrected the deployment name to match your 'kubectl apply' output
                    sh "kubectl rollout status deployment/hello-jenkins-deployment"
                    
                    echo "Current Pods:"
                    // This shows pods matching the label defined in your YAML
                    sh "kubectl get pods -l app=hello-jenkins"
                }
            }
        }

    post {
        success {
            echo "Successfully pushed and deployed version ${BUILD_NUMBER}!"
        }
        failure {
            echo "Pipeline failed. Check console output for errors."
        }
    }
}
