pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'devops/app'
    }
    stages{
        stage('Build da Imagem Docker'){
            steps {
                sh 'docker build -t ${DOCKER_IMAGE} .'
            }
        }
        stage ('Tempo para subida do container'){
            steps{
                echo 'Esperando 20 segundos para subir o container...'
                sh 'sleep 20'
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
         stage ('Tempo para Sonar'){
            steps{
                echo 'Esperando 20 segundos para subir o container...'
                sh 'sleep 20'
            }
        }       
        stage('Fazer Upload da Imagem docker para o Nexus'){
            steps{
                script{
                    withCredentials([usernamePassword(credentialsId: 'nexus-user', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD' )]){
                        sh 'docker login -u $USERNAME -p $PASSWORD ${NEXUS_URL}'
                        sh 'docker tag devops/app:latest ${NEXUS_URL}/devops/app'
                        sh 'docker push ${NEXUS_URL}/devops/app'
                    }
                }
            }
        }
        stage ('Tempo para Upload da Imagem'){
            steps{
                echo 'Esperando 20 segundos para subir o container...'
                sh 'sleep 20'
            }
        }
        stage('Apply k8s files'){
            steps{
                sh '/usr/local/bin/kubectl apply -f ./k3s/app.yaml --validate=false'
            }
        }
    }
}