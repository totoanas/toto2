pipeline {
  agent any
  stages {
    stage('') {
      steps {
        parallel(
          "BUILD": {
            build 'test1'
            
          },
          "BUILD_JS": {
            build 'test2'
            
          }
        )
      }
    }
    stage('DEPLOY') {
      steps {
        parallel(
          "DEPLOY": {
            build 'test3'
            
          },
          "DEPLOY_JS": {
            build 'test4'
            
          }
        )
      }
    }
  }
}
