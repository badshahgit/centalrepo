pipeline {
  agent any
  stages {
    stage('continuous download') {
      steps {
        echo 'download success'
      }
    }

    stage('continuous build') {
      parallel {
        stage('continuous build') {
          steps {
            echo 'build success'
          }
        }

        stage('continuous monitor') {
          steps {
            echo 'monitor success'
          }
        }

      }
    }

    stage('continuous deploy') {
      steps {
        echo 'deploy success'
      }
    }

    stage('continuous deliver') {
      steps {
        sh '''pwd
cal
date
cd /var'''
      }
    }

  }
}