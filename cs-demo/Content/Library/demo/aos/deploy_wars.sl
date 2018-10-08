namespace: demo.aos
flow:
  name: deploy_wars
  inputs:
    - tomcat_host: 10.0.46.53
    - account_service_host:
        default: 10.0.46.52
        required: true
    - db_host:
        default: 10.0.46.51
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
          - FAILURE: on_failure
          - SUCCESS: deploy_tm_wars
    - deploy_tm_wars:
        loop:
          for: "war in 'catalog','MasterCredit','order','ROOT','ShipEx','SafePay'"
          do:
            demo.aos.initialize_artifact:
              - host: '${tomcat_host}'
              - username: '${username}'
              - password: '${password}'
              - artifact_url: "${url+war.lower()+'/target/'+war+'.war'}"
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
      deploy_tm_wars:
        x: 227
        y: 68
        navigate:
          0cea8b1f-bfeb-3dd9-94f4-c938b314ab15:
            targetId: ba3e8e8a-ed7d-90af-1b65-c7f0dd4421c0
            port: SUCCESS
    results:
      SUCCESS:
        ba3e8e8a-ed7d-90af-1b65-c7f0dd4421c0:
          x: 399
          y: 78
