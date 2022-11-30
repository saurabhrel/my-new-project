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

       stage ('maven build'){
            steps {
                sh 'mvn clean install'
    }
  }      

} 
