pipeline {

    environment {
        dockerimagename = "thetips4you/nodeapp"
        dockerImage = ""
    }

    agent any

    stages {
        stage('Checkout Source') {
            steps {
                git credentialsId: 'git-project', url: 'https://github.com/saurabhrel/my-new-project.git'
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
