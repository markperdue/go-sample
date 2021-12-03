node('jenkins-jenkins-agent') {
    stage('build') {
        println 'switching to kaniko'
        container('kaniko') {
            sh 'kaniko --help'
        }
    }
    stage('deploy') {}
}
