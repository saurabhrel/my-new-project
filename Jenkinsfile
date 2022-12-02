pipeline{
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('devops-project')
    }

    stages{
        stage("Git Checkout"){
            steps{
                git branch: 'Parichay', credentialsId: 'git-project', url: 'https://github.com/saurabhrel/my-new-project.git'
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
                    sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.12.18'
                    sh 'scp /var/lib/jenkins/workspace/DevOps_Project_Parichay/Dockerfile ubuntu@172.31.12.18:/home/ubuntu'
                    sh 'scp /var/lib/jenkins/workspace/DevOps_Project_Parichay/ansible.yaml ubuntu@172.31.12.18:/home/ubuntu'
                    sh 'scp /var/lib/jenkins/workspace/DevOps_Project_Parichay/webapp/target/webapp.war ubuntu@172.31.12.18:/home/ubuntu'
                    sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.12.18 cd /home/ubuntu'
                    sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.12.18 docker image build -t $JOB_NAME:v1.$BUILD_ID .'
                    sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.12.18 docker image tag $JOB_NAME:v1.$BUILD_ID parichaybisht/$JOB_NAME:v1.$BUILD_ID'
                    sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.12.18 docker image tag $JOB_NAME:v1.$BUILD_ID parichaybisht/$JOB_NAME:latest'
                }
            }
        }

        stage("Push Image"){
            steps{
                sshagent(['Ansible-Credential']){
                    withCredentials([string(credentialsId: 'dockerhub_password', variable: 'dockerhub_password')]) {
                        sh "ssh -o StrictHostKeyChecking=no ubuntu@172.31.12.18 docker login -u parichaybisht -p ${dockerhub_password}"
                        sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.12.18 docker image push parichaybisht/$JOB_NAME:v1.$BUILD_ID'
                        sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.12.18 docker image push parichaybisht/$JOB_NAME:latest'
                        sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.12.18 docker image rm parichaybisht/$JOB_NAME:v1.$BUILD_ID parichaybisht/$JOB_NAME:latest $JOB_NAME:v1.$BUILD_ID'
                    }
                }
            }
        }

        stage("copying Manifests to Kubernetes"){
            sshagent(['Kubernetes-Credential']){
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@K8S-ip'
                sh 'scp /var/lib/jenkins/workspace/DevOps_Project_Parichay/deloyment.yaml ubuntu@K8S-ip:/home/ubuntu'
                sh 'scp /var/lib/jenkins/workspace/DevOps_Project_Parichay/service.yaml ubuntu@K8S-ip:/home/ubuntu'
            }
        }

        stage('Deploy to Kubernetes'){
            sshagent(['Ansible-Credential']){
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.12.18 cd /home/ubuntu'
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.12.18 ansible-playbook ansible.yaml'
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
