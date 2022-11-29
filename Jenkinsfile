pipeline {

    environment {
        dockerimagename = ""
        dockerImage = ""
    }

    agent any

    stages {
        stage('Checkout Source') {
            steps {
                git branch: 'Parichay', credentialsId: 'git-project', url: 'https://github.com/saurabhrel/my-new-project.git'
            }
        }

        stage('Build image') {
            steps {
                script {
                    dockerImage = "docker.build dockerimagename"
                }
            }
        }

        stage('Pushing Image') {
            environment {
                registryCredential = "dockerhublogin"
            }
            steps {
                script {
                    docker.withRegistry( "https://registry.hub.docker.com", registryCredential ) {
                        dockerImage.push("latest")
                    } 
                }
            }
        }
    }
}
