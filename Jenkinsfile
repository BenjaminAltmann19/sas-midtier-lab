pipeline {
    agent {
	label 'linux'
    }

    stages {
        stage('Validate Files') {
            steps {
                sh '''
                    echo "Checking project files..."
                    test -f health-check.sh
                    test -f config/000-default.conf
                    test -f config/default-ssl.conf
                '''
            }
        }

        stage('Validate Apache Config') {
            steps {
                sh '''
                    echo "Validating Apache configuration..."
                    apache2ctl configtest
                '''
            }
        }

        stage('Health Check') {
            steps {
                sh '''
                    echo "Running midtier health check..."
                    ./health-check.sh
                '''
            }
        }
    }

    post {
        success {
            echo 'Midtier environment is healthy.'
        }

        failure {
            echo 'Midtier environment health check failed.'
        }
    }
}
