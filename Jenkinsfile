pipeline {
    agent any
    
    tools {
        jdk 'jdk17'
        maven 'maven3'
    }
    
    environment {
        $SCANNER_HOME = tool 'sonar-scanner'
    }
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', credentialsId: 'git-creds', url: 'https://github.com/VibishnathanG/Project-03-Ecom-endToendCICD.git'
            }
        }
        stage('Maven Compile') {
            steps {
                sh 'mvn compile;'
            }
        }
        stage('Maven Test') {
            steps {
                sh 'mvn test;'
            }
        }
        stage('Sonar-Scanner') {
            steps {
                withSonarQubeEnv('sonar') {
                sh '''
                    $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=BoardGame \
                    -Dsonar.projectKey=BoardGame \
                    -Dsonar.java.binaries=.
                    '''
        }
            }
        }
        
        stage('Quality Gate') {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonar-cred'
                }
            }
        }
        
        stage('Trivy FileSystem Scan') {
            steps { 
                sh 'trivy fs --format table -o trivy-fs-report.html .'
            }
        }
        stage('Dependency Check') {
            steps {
                dependencyCheck additionalArguments: ' --scan ./', odcInstallation: 'DC'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        stage('Maven Build') {
            steps {
                sh 'mvn package'
            }
        }
        stage('Nexus upload') {
            steps {
                withMaven(globalMavenSettingsConfig: 'global-maven', jdk: 'jdk17', maven: '', mavenSettingsConfig: '', traceability: true) {
                sh 'mvn deploy'
            }
            }
        }
        stage('Docker Build and tag') {
            steps {
                script{
                withDockerRegistry(credentialsId: 'docker-creds', url: 'https://hub.docker.com/') {
                sh 'docker build -t vibishnathan/boardgame:latest .'
                }
            }
                
            }
        }
        stage('Docker Image Scan') {
            steps {
                sh 'trivy image --format table -o trivy-imagescan-output.html vibishnathan/boardgame:latest'
            }
        }
        stage('Docker Image Push') {
            steps {
                script{
                withDockerRegistry(credentialsId: 'docker-creds', url: 'https://hub.docker.com/') {
                sh 'docker push vibishnathan/boardgame:latest'
                    
                }
            }
                
            }
        }
        stage('Kubernetes deploy') {
            steps {
                withKubeCredentials(kubectlCredentials: [[caCertificate: '', clusterName: 'kubernetes', contextName: '', credentialsId: 'k8s-secret', namespace: 'webapps', serverUrl: 'https://20.0.1.20:6443']]) {
                 sh "kubectl apply -f deployment-service.yaml"
                }
            }
        }
        
        stage('Verify the Deployment') {
            steps {
                withKubeCredentials(kubectlCredentials: [[caCertificate: '', clusterName: 'kubernetes', contextName: '', credentialsId: 'k8s-secret', namespace: 'webapps', serverUrl: 'https://20.0.1.161:6443']]) {
                    sh "kubectl get pods -n webapps"
                    sh "kubectl get svc -n webapps"
                }
            }
        }
        
        
    }
    
     post {
        always {
            script {
                def jobName = env.JOB_NAME
                def buildNumber = env.BUILD_NUMBER
                def pipelineStatus = currentBuild.result ?: 'UNKNOWN'
                def bannerColor = pipelineStatus.toUpperCase() == 'SUCCESS' ? 'green' : 'red'
                def body = """
                <html>
                <body>
                <div style="border: 4px solid ${bannerColor}; padding: 10px;">
                <h2>${jobName} - Build ${buildNumber}</h2>
                <div style="background-color: ${bannerColor}; padding: 10px;">
                <h3 style="color: white;">Pipeline Status: ${pipelineStatus.toUpperCase()}</h3>
                </div>
                <p>Check the <a href="${BUILD_URL}">console output</a>.</p>
                </div>
                </body>
                </html>
                """
                emailext (
                    subject: "${jobName} - Build ${buildNumber} - ${pipelineStatus.toUpperCase()}",
                    body: body,
                    to: 'vibishdevops@gmail.com',
                    from: 'jenkins@example.com',
                    replyTo: 'jenkins@example.com',
                    mimeType: 'text/html',
                    attachmentsPattern: 'trivy-image-report.html'
                )
            }
        }
    }
    
}
