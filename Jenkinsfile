pipeline {

    agent any
    environment {
        PATH = '/usr/bin:$PATH'
    }

    stages {
        stage('Checkout Source') {
            steps {
                git branch: 'Parichay', credentialsId: 'git-project', url: 'https://github.com/saurabhrel/my-new-project.git'
            }
        }

        stage('Build code') {
            steps {
                sh 'mvn clean install'
            }
        }

        stage('SonarQube analysis') {
            steps {
                withSonarQubeEnv('sonarqube-9.7.1') {
                    sh 'mvn sonar:sonar'
                }
            }
        }

        stage('deploy') {
            steps {
                sshagent(['tomcat-deploy']) {
                    sh 'scp -o StrictHostKeyChecking=no webapp/target/weapp.war ec2-user@13.235.128.226:/opt/tomcat/apache-tomcat-9.0.69/webapps'
                }
            }
        }
    }
}
