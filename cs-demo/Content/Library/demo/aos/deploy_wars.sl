namespace: demo.aos
flow:
  name: deploy_wars
  inputs:
    - tomcat_host: 10.0.46.54
    - account_service_host:
        default: 10.0.46.54
        required: true
    - db_host:
        required: true
    - username: root
    - password: admin@123
    - url: 'http://vmdocker.hcm.demo.local:36980/job/AOS/lastSuccessfulBuild/artifact/'
  workflow:
    - deploy_account_service:
        do:
          demo.aos.initialize_artifact:
            - host: '${account_service_host}'
            - username: '${username}'
            - password: '${password}'
            - artifact_url: "${url+'accountservice/target/accountservice.war'}"
            - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/deploy_war.sh'
            - parameters: "${db_host+' postgres admin '+tomcat_host+' '+account_service_host}"
        navigate:
          - FAILURE: deploy_catalog
          - SUCCESS: deploy_tm_wars
    - deploy_tm_wars:
        loop:
          for: "war in 'catalog','MasterCredit','order','ROOT','ShipEx','SafePay'"
          do:
            demo.aos.initialize_artifact:
              - host: '${tomcat_host}'
              - username: '${username}'
              - password: '${password}'
              - artifact_url: "${url+war+'/target/'+war'.war'}"
              - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/deploy_war.sh'
              - parameters: "${db_host+' postgres admin '+tomcat_host+' '+account_service_host}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - deploy_catalog:
        do:
          demo.aos.initialize_artifact:
            - host: '${tomcat_host}'
            - username: '${username}'
            - password: '${password}'
            - artifact_url: "${url+'catalog/target/catalog.war'}"
            - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/deploy_war.sh'
            - parameters: "${db_host+' postgres admin '+tomcat_host+' '+account_service_host}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: deploy_mastercredit
    - deploy_mastercredit:
        do:
          demo.aos.initialize_artifact:
            - host: '${tomcat_host}'
            - username: '${username}'
            - password: '${password}'
            - artifact_url: "${url+'mastercredit/target/MasterCredit.war'}"
            - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/deploy_war.sh'
            - parameters: "${db_host+' postgres admin '+tomcat_host+' '+account_service_host}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: deploy_order
    - deploy_order:
        do:
          demo.aos.initialize_artifact:
            - host: '${tomcat_host}'
            - username: '${username}'
            - password: '${password}'
            - artifact_url: "${url+'order/target/order.war'}"
            - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/deploy_war.sh'
            - parameters: "${db_host+' postgres admin '+tomcat_host+' '+account_service_host}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: deploy_root
    - deploy_root:
        do:
          demo.aos.initialize_artifact:
            - host: '${tomcat_host}'
            - username: '${username}'
            - password: '${password}'
            - artifact_url: "${url+'root/target/ROOT.war'}"
            - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/deploy_war.sh'
            - parameters: "${db_host+' postgres admin '+tomcat_host+' '+account_service_host}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: deploy_safepay
    - deploy_safepay:
        do:
          demo.aos.initialize_artifact:
            - host: '${tomcat_host}'
            - username: '${username}'
            - password: '${password}'
            - artifact_url: "${url+'safepay/target/SafePay.war'}"
            - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/deploy_war.sh'
            - parameters: "${db_host+' postgres admin '+tomcat_host+' '+account_service_host}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: deploy_shipex
    - deploy_shipex:
        do:
          demo.aos.initialize_artifact:
            - host: '${tomcat_host}'
            - username: '${username}'
            - password: '${password}'
            - artifact_url: "${url+'shipex/target/ShipEx.war'}"
            - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/deploy_war.sh'
            - parameters: "${db_host+' postgres admin '+tomcat_host+' '+account_service_host}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      deploy_account_service:
        x: 59
        y: 68
      deploy_catalog:
        x: 238
        y: 75
      deploy_mastercredit:
        x: 376
        y: 85
      deploy_order:
        x: 72
        y: 220
      deploy_root:
        x: 246
        y: 224
      deploy_safepay:
        x: 392
        y: 219
      deploy_shipex:
        x: 298
        y: 379
        navigate:
          69f5f8b7-fbe8-2828-02b7-6643aaff4c52:
            targetId: ba3e8e8a-ed7d-90af-1b65-c7f0dd4421c0
            port: SUCCESS
    results:
      SUCCESS:
        ba3e8e8a-ed7d-90af-1b65-c7f0dd4421c0:
          x: 478
          y: 360
