pipeline {
  agent any

  environment {
    DOCKERHUB_REPO = "vansh23100/devops-demo"
    IMAGE_TAG = "${env.BUILD_ID}"
  }

  stages {

    stage('Checkout Code') {
      steps {
        checkout scm
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build --no-cache -t ${DOCKERHUB_REPO}:${IMAGE_TAG} .'
      }
    }

    stage('Run Tests') {
      steps {
        sh 'echo "Running tests... (none configured)"'
      }
    }

    stage('Push to Docker Hub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'derhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
          sh 'docker push ${DOCKERHUB_REPO}:${IMAGE_TAG}'
        }
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        sh '''
          kubectl set image deployment/devops-demo devops-demo=${DOCKERHUB_REPO}:${IMAGE_TAG} --record || true
          kubectl rollout status deployment/devops-demo
        '''
      }
    }
  }

  post {
    success {
      echo "CI/CD Pipeline Successful!"
    }
    failure {
      echo "Pipeline Failed!"
    }
  }
}
