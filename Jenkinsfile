pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'devops/app'
        NEXUS_IMAGE = "${NEXUS_URL}/devops/app"
    }
    stages{
        stage('Build da Imagem Docker'){
            steps {
                sh 'docker build -t ${DOCKER_IMAGE} .'
            }
        }
        stage ('sTempo para subida do conatiner'){
            steps{
                echo 'Esperando 10 segundos para subir o container...'
                sh 'sleep 10'
            }
        }
        stage('Executar SonarQube'){
            steps{
                script{
                    scannerHome = tool 'sonar-scanner';
                }
                withSonarQubeEnv('sonar-server'){
                    sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=API_Comentario -Dsonar.sources=. -Dsonar.host.url=${env.SONAR_HOST_URL} -Dsonar.login=${env.SONAR_AUTH_TOKEN}"
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
                        sh 'docker push ${NEXUS_IMAGE}:latest'
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
}