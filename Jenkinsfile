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

        stage('SonarQube Analysis') {
            def mvn = tool 'Maven';
            withSonarQubeEnv() {
                sh "${mvn}/bin/mvn clean verify sonar:sonar -Dsonar.projectKey=my-new-project"
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
