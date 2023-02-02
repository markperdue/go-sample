pipeline {
  parameters {
    string(name: 'image', description: 'name of the container image to build (including the container registry prefix)', defaultValue: 'docker.io/mperdue/go-sample')
    booleanParam(name: 'build', description: 'enable to build the sample app as a container image', defaultValue: false)
    booleanParam(name: 'publish', description: 'enable to publish the sample container image to a container registry\n(requires build stage to be enabled)', defaultValue: false)
    booleanParam(name: 'deploy', description: 'enable to deploy the sample container image using the sample helm chart\n(requires both build and publish stages to be enabled)', defaultValue: false)
    credentials(name: 'credential', description: 'if publish stage is enabled, select a credential to be used for authorizing to the container registry', defaultValue: '', credentialType: "Username with password", required: false )
  }
  agent {
    kubernetes {
      cloud 'cicd'
      serviceAccount 'jenkins'
      yaml '''
        kind: Pod
        spec:
          securityContext:
            runAsUser: 1000
          containers:
            - name: buildah
              image: quay.io/buildah/stable
              imagePullPolicy: IfNotPresent
              command: ["cat"]
              tty: true
              securityContext:
                privileged: true
            - name: helm
              image: docker.io/alpine/helm:3.10.2
              imagePullPolicy: IfNotPresent
              command: ["cat"]
              tty: true
        '''
    }
  }
  environment {
    version = '0.1.1'
  }
  stages {
    stage('checkout') {
      steps {
        git url: 'https://github.com/markperdue/go-sample.git'
      }
    }
    stage('build') {
      when { expression { return params.build.toBoolean() } }
      steps {
        container(name: 'buildah') {
          sh "buildah bud -f Dockerfile -t ${params.image}:${version} --build-arg 'version=${version}' ."
        }
      }
    }
    stage('publish') {
      when { expression { return params.publish.toBoolean() } }
      steps {
        container(name: 'buildah') {
          withCredentials([usernameColonPassword(credentialsId: credential, variable: 'creds')]) {
            sh 'buildah push --creds ' + creds + "${params.image}:${version} docker://${params.image}:${version}"
          }
        }
      }
    }
    stage('deploy') {
      when { expression { return params.deploy.toBoolean() } }
      steps {
        container(name: 'helm') {
          sh "helm upgrade --install go-sample ./helm --set 'image.repository=${params.image}' --set 'image.tag=${version}' -n cicd --wait"
        }
      }
    }
  }
}
