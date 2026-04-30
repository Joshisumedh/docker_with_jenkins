pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                // Build the image and tag it as 'java-hello-world'
                sh 'docker build -t java-hello-world:latest .'
            }
        }

        stage('Run Docker Container') {
            steps {
                // Run the container and remove it immediately after execution (--rm)
                sh 'docker run --rm java-hello-world:latest'
            }
        }
    }
}
