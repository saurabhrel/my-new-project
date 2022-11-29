pipeline {

    agent any

    stages {
        stage('Checkout Source') {
            steps {
                git branch: 'Parichay', credentialsId: 'git-project', url: 'https://github.com/saurabhrel/my-new-project.git'
            }
        }

        stage('Build code') {
            environment {
                PATH = '/usr/bin:$PATH'
                }
            steps {
                sh 'mvn clean install'
            }
        }

        stage('deploy') {
            steps {
                sshagent(['tomcat-deploy']) {
                    sh 'scp -o StrictHostKeyChecking=no /webapp/target ec2-user@15.206.172.31:/opt/tomcat/apache-tomcat-9.0.69/webapps'
                }
            }
        }
    }
}
