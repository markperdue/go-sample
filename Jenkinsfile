pipeline {
    agent {
        kubernetes {
            label 'example-kaniko-volumes'
            yaml """
kind: Pod
metadata:
  name: kaniko
spec:
  containers:
  - name: jnlp
    workingDir: /home/jenkins/agent
  - name: kaniko
    workingDir: /home/jenkins/agent
    image: gcr.io/kaniko-project/executor:debug
    imagePullPolicy: Always
    command:
    - /busybox/cat
    tty: true
"""
        }
    }
    stages {
        stage('checkout') {
            steps {
                sh 'ls -la'
                checkout scm
                sh 'ls -la'
            }
        }
        stage('build') {
            environment {
                PATH = "/busybox:/kaniko:$PATH"
            }
            steps {
                container(name: 'kaniko', shell: '/busybox/sh') {
                    println 'weee'
                }
            }
        }
    }
}
