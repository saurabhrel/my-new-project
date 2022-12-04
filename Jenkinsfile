pipeline{
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('devops-project')
    }

    stages{
        stage("Git Checkout"){
            steps{
                git branch: 'parichay', credentialsId: 'git-project', url: 'https://github.com/saurabhrel/my-new-project.git'
            }
        }

        stage('Build code') {
            steps {
                sh 'mvn clean install'
            }
        }

        stage("Build Image"){
            steps{
                sshagent(['Ansible-Credential']) {
                    sh 'ssh -o StrictHostKeyChecking=no ec2-user@172.31.43.137'
                    sh 'scp /var/lib/jenkins/workspace/project_parichay/Dockerfile ec2-user@172.31.43.137:/home/ec2-user'
                    sh 'scp /var/lib/jenkins/workspace/project_parichay/ansible.yaml ec2-user@172.31.43.137:/home/ec2-user'
                    sh 'scp /var/lib/jenkins/workspace/project_parichay/webapp/target/webapp.war ec2-user@172.31.43.137:/home/ec2-user'
                    sh 'ssh -o StrictHostKeyChecking=no ec2-user@172.31.43.137 cd /home/ec2-user'
                    sh 'ssh -o StrictHostKeyChecking=no ec2-user@172.31.43.137 docker image build -t $JOB_NAME:v1.$BUILD_ID .'
                    sh 'ssh -o StrictHostKeyChecking=no ec2-user@172.31.43.137 docker image tag $JOB_NAME:v1.$BUILD_ID parichaybisht/$JOB_NAME:v1.$BUILD_ID'
                    sh 'ssh -o StrictHostKeyChecking=no ec2-user@172.31.43.137 docker image tag $JOB_NAME:v1.$BUILD_ID parichaybisht/$JOB_NAME:latest'
                }
            }
        }

        stage("Push Image"){
            steps{
                sshagent(['Ansible-Credential']){
                    withCredentials([string(credentialsId: 'dockerhub_password', variable: 'dockerhub_password')]) {
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@172.31.43.137 docker login -u parichaybisht -p ${dockerhub_password}"
                        sh 'ssh -o StrictHostKeyChecking=no ec2-user@172.31.43.137 docker image push parichaybisht/$JOB_NAME:v1.$BUILD_ID'
                        sh 'ssh -o StrictHostKeyChecking=no ec2-user@172.31.43.137 docker image push parichaybisht/$JOB_NAME:latest'
                        sh 'ssh -o StrictHostKeyChecking=no ec2-user@172.31.43.137 docker image rm parichaybisht/$JOB_NAME:v1.$BUILD_ID parichaybisht/$JOB_NAME:latest $JOB_NAME:v1.$BUILD_ID'
                    }
                }
            }
        }

        stage("copying Manifests to Kubernetes"){
            steps{
                sshagent(['Kubernetes-Credential']){
                    sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.9.17'
                    sh 'scp /var/lib/jenkins/workspace/project_parichay/deployment.yaml ubuntu@172.31.9.17:/home/ubuntu'
                    sh 'scp /var/lib/jenkins/workspace/project_parichay/service.yaml ubuntu@172.31.9.17:/home/ubuntu'
                }
            }
        }

        stage('Deploy to Kubernetes'){
            steps{
                sshagent(['Ansible-Credential']){
                    sh 'ssh -o StrictHostKeyChecking=no ec2-user@172.31.43.137 cd /home/ec2-user'
                    sh 'ssh -o StrictHostKeyChecking=no ec2-user@172.31.43.137 ansible-playbook ansible.yaml'
                }
            }
        }
    }
    post{
        always {
            sh 'docker logout'
        }
        success{
            echo "========pipeline executed successfully ========"
        }
        failure{
            echo "========pipeline execution failed========"
        }
    }
}
