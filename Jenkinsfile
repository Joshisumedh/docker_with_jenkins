pipeline {
    agent any

    environment {
        // Replace 'your-dockerhub-username' with your actual username
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
                // Build with the 'latest' tag and the build number for versioning
                sh "docker build -t ${DOCKER_USER}/${IMAGE_NAME}:latest ."
                sh "docker tag ${DOCKER_USER}/${IMAGE_NAME}:latest ${DOCKER_USER}/${IMAGE_NAME}:${BUILD_NUMBER}"
            }
        }

        stage('Docker Push') {
            steps {
                // This block securely logs you into DockerHub
                withCredentials([usernamePassword(credentialsId: REGISTRY_ID, passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER_ENV')]) {
                    sh "echo \$DOCKER_PASS | docker login -u \$DOCKER_USER_ENV --password-stdin"
                   
                    echo 'Pushing Image to DockerHub...'
                    sh "docker push ${DOCKER_USER}/${IMAGE_NAME}:latest"
                    sh "docker push ${DOCKER_USER}/${IMAGE_NAME}:${BUILD_NUMBER}"
                   
                    sh "docker logout"
                }
            }
        }
    }

    post {
        success {
            echo "Successfully pushed ${DOCKER_USER}/${IMAGE_NAME}:${BUILD_NUMBER} to DockerHub"
        }
    }
}
