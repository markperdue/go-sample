pipeline {
    agent {
        kubernetes {
            cloud 'cicd'
            serviceAccount 'jenkins'
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
      volumeMounts:
        - name: config-volume
          mountPath: /kaniko/.docker/
    - name: helm
      workingDir: /home/jenkins/agent
      image: alpine/helm:3.7.1
      imagePullPolicy: Always
      command:
        - cat
      tty: true
  volumes:
    - name: config-volume
      configMap:
        name: kaniko-dockerhub
"""
        }
    }
    environment {
        version = '0.1.1'
    }
    stages {
        stage('checkout') {
            steps {
                git changelog: false, poll: false, url: 'https://github.com/markperdue/go-sample.git'
            }
        }
        stage('build') {
            environment {
                PATH = "/busybox:/kaniko:$PATH"
            }
            steps {
                container(name: 'kaniko', shell: '/busybox/sh') {
                    sh "/kaniko/executor --dockerfile `pwd`/Dockerfile --destination=mperdue/go-sample:${version} --context `pwd` --build-arg 'version=${version}'"
                }
            }
        }
        stage('deploy') {
            steps {
                container(name: 'helm') {
                    sh "helm upgrade --install go-sample ./go-sample --set 'image.tag=${version}' -n cicd --wait"
                }
            }
        }
    }
}
