pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'devops/app'
        NEXUS_IMAGE = "${NEXUS_URL}/devops/app"
        SONAR_PROJECT_KEY = 'API_Comentario'
    }

    stages{
        stage('Build da Imagem Docker'){
            steps {
                script {
                    docker.build(DOCKER_IMAGE)
                } 
            }
        }

        stage('Executar SonarQube'){
            steps{
                script{
                    scannerHome = tool 'sonar-scanner';
                }
                withSonarQubeEnv('sonar-server'){
                    sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=${SONAR_PROJECT_KEY} -Dsonar.sources=. -Dsonar.host.url=$(env.SONAR_HOST_URL) -Dsonar.login=$(env.SONAR_AUTH_TOKEN)"
                }
            }
        }
        stage('Testar a aplicação'){
            steps{
                sh 'chmod +x teste-app.sh'
                sh './teste-app.sh'
            }
        }
        stage('Desligar o Containers de teste'){
            steps{
                sh 'docker-compose down'
            }
        }
        stage('Fazer Upload da Imagem docker para o Nexus'){
            steps{
                script{
                    withCredentials([usernamePassword(credentialsId: 'nexus-user', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD' )]){
                        sh 'docker login -u $USERNAME -p $PASSWORD ${NEXUS_URL}'
                        sh 'docker tag ${DOCKER_IMAGE}:latest ${NEXUS_IMAGE}:latest"'
                        sh 'docker push ${NEXUS_URL}/${NEXUS_IMAGE}:latest'
                    }
                }
            }
        }
        stage('Apply k8s files'){
            steps{
                sh '/usr/local/bin/kubectl aaply -f ./k3s/app.yaml'
            }
        }
}