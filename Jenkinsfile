pipeline {
  agent any
  stages {
    stage('') {
      steps {
        parallel(
          "BUILD": {
            build 'JP_FnB_Build'
            
          },
          "BUILD_JS": {
            build 'JP_FnB_Build_JS_BIS'
            
          }
        )
      }
    }
    stage('DEPLOY') {
      steps {
        parallel(
          "DEPLOY": {
            build 'JP_FnB_Deploy'
            
          },
          "DEPLOY_JS": {
            build 'JP_FnB_Deploy_JS_BIS'
            
          }
        )
      }
    }
  }
}