pipeline {
    agent {
        label "gaurav"
    }
    
    stages {
        stage ('git checkout') {
            steps {
                git branch: 'gaurav', credentialsId: 'git-project', url: 'https://github.com/saurabhrel/my-new-project.git'
            }

        }

        stage ('mvn build') {
            steps {
              sh 'mvn clean install'
            }
        }

        stage ('build image') {
            steps {
                sshagent(['ansible-credential-gk']) {
                     sh 'ssh -o StrictHostKeyChecking=no ec2-user@172.31.43.193
                     
                }
            }
        }
    }
}
