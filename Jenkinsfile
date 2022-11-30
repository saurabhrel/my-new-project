pipeline {

    agent {
        label "Bisht"
    }
    environment {
        DOCKERHUB_CREDENTIALS = credentials('devops-project')
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

       stage('Build docker image') {
            steps {  
                sh 'docker build -t parichaybisht/projectapp:$BUILD_NUMBER .'
            }
        }
        stage('login to dockerhub') {
            steps{
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }
        stage('push image') {
            steps{
                sh 'docker push parichaybisht/projectapp:$BUILD_NUMBER'
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

post {
    always {
        sh 'docker logout'
    }
}
