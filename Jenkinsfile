pipeline{
    agent  {
        node {
            label 'slave1'
    }
}
    stages{
        stage ('git checkout') {
            steps{
                git branch: 'Jeetu', credentialsId: 'git-project', url: 'https://github.com/saurabhrel/my-new-project.git'
            }
        }

    }
}
                                                                                                                                                     
        stage ('maven build'){
            steps {
                sh 'mvn clean install'
    }
}       
        stage ('Build docker image'){
            steps{
               sh 'docker image build -t $JOB_NAME:v1.$BUILD_ID .'
               sh 'docker image tag $JOB_NAME:V1.$BUILD_ID parichaybisht/$JOB_NAME:V1.$BUILD_ID'
               sh 'docker image tag $JOB_NAME:V1.$BUILD_ID parichaybisht/$JOB_NAME:latest'
           }   
}
        stage ('Docker push') {
            steps{
                withCredentials([string(credentialsId: 'dockerhubpassword', variable: 'dockerhubpassword')]) {
    // some block
    sh 'docker login -u parichaybisht -p $(dockerhubpassword)'
    sh 'docker image push parichaybisht/$JOB_NAME:V1.$BUILD_ID'
    sh 'docker image push parichaybisht/$JOB_NAME:latest'
    sh 'docker image rmi $JOB_NAME:v1.BUILD_ID parichaybisht/$JOB_NAME:V1.$BUILD_ID parichaybisht/$JOB_NAME:latest'
}

                
            }

        }
   
    }
}
