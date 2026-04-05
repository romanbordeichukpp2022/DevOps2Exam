pipeline {
    agent any

    environment {
        TF_VAR_do_token          = credentials('DO_TOKEN')
        TF_VAR_spaces_access_id  = credentials('SPACES_ACCESS_KEY')
        TF_VAR_spaces_secret_key = credentials('SPACES_SECRET_KEY')
        
        AWS_ACCESS_KEY_ID        = credentials('SPACES_ACCESS_KEY')
        AWS_SECRET_ACCESS_KEY    = credentials('SPACES_SECRET_KEY')
    }

    stages {
        stage('Preparation') {
            steps {
                echo "Перевірка наявності папки terraform..."
                script {
                    if (!fileExists('terraform')) {
                        error "Папка 'terraform' не знайдена в робочій директорії!"
                    }
                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init -reconfigure'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('terraform') {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }

    post {
        always {
            dir('terraform') {
                sh 'rm -f tfplan'
            }
        }
        success {
            echo "-------------------------------------------------------"
            echo "Успіх! Інфраструктуру розгорнуто в DigitalOcean."
            echo "-------------------------------------------------------"
        }
        failure {
            echo "-------------------------------------------------------"
            echo "Помилка! Перевірте консольний вивід для деталей."
            echo "-------------------------------------------------------"
        }
    }
}