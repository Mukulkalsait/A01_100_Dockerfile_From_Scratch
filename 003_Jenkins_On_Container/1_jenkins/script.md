pipeline {
    agent any

    environment {
        IMAGE_NAME = "docker.io/mukuldk/vat_website"
        IMAGE_TAG = "latest"

        SERVER1 = "mukuldk@localhost"   // builder machine
        VAT = "user@vat_ip"             // production server
        APP_DIR = "/path/to/project"    // on server1
        COMPOSE_DIR = "/path/to/compose" // on VAT
    }

    stages {

        // 1️⃣ Only check repo access (fail fast if Git breaks)
        stage('Check Git Access') {
            steps {
                sh '''
                ssh $SERVER1 << 'EOF'
                  cd $APP_DIR || exit 1
                  git fetch origin main
                EOF
                '''
            }
        }

        // 2️⃣ Pull latest code
        stage('Pull Latest Code') {
            steps {
                sh '''
                ssh $SERVER1 << 'EOF'
                  cd $APP_DIR || exit 1
                  git pull origin main
                EOF
                '''
            }
        }

        // 3️⃣ Build image
        stage('Build Image') {
            steps {
                sh '''
                ssh $SERVER1 << 'EOF'
                  cd $APP_DIR || exit 1
                  podman build -t $IMAGE_NAME:$IMAGE_TAG .
                EOF
                '''
            }
        }

        // 4️⃣ Tag (optional but good practice)
        stage('Tag Image') {
            steps {
                sh '''
                ssh $SERVER1 << 'EOF'
                  podman tag $IMAGE_NAME:$IMAGE_TAG $IMAGE_NAME:latest
                EOF
                '''
            }
        }

        // 5️⃣ Push image
        stage('Push Image') {
            steps {
                sh '''
                ssh $SERVER1 << 'EOF'
                  podman push $IMAGE_NAME:$IMAGE_TAG
                  podman push $IMAGE_NAME:latest
                EOF
                '''
            }
        }

        // 6️⃣ Pull on VAT (separate step for debugging)
        stage('Pull on VAT') {
            steps {
                sh '''
                ssh $VAT << 'EOF'
                  podman pull $IMAGE_NAME:latest
                EOF
                '''
            }
        }

        // 7️⃣ Stop old containers
        stage('Stop Old Containers') {
            steps {
                sh '''
                ssh $VAT << 'EOF'
                  cd $COMPOSE_DIR || exit 1
                  podman-compose down
                EOF
                '''
            }
        }

        // 8️⃣ Start new containers
        stage('Start New Containers') {
            steps {
                sh '''
                ssh $VAT << 'EOF'
                  cd $COMPOSE_DIR || exit 1
                  podman-compose up -d
                EOF
                '''
            }
        }
    }
}
