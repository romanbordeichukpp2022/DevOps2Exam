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
        stage('Fix State Sync') {
            steps {
                dir('terraform') {
                    sh '''
                    if [ -f errored.tfstate ]; then
                        terraform init -reconfigure
                        # Додаємо -force, щоб ігнорувати різницю в lineage
                        terraform state push -force errored.tfstate
                        echo "State pushed with FORCE successfully!"
                        # Видаляємо локальний файл, щоб він не заважав наступним запускам
                        rm errored.tfstate
                    else
                        echo "No errored.tfstate found, proceeding..."
                    fi
                    '''
                }
            }
        }
        stage('Terraform Plan & Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform plan -out=tfplan'
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }
}