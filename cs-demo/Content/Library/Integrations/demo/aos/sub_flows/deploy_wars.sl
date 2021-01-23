namespace: io.cloudslang.demo.aos.sub_flows
flow:
  name: deploy_wars
  inputs:
    - tomcat_host
    - account_service_host:
        required: true
    - db_host:
        required: true
    - username
    - password
    - db_username
    - db_password
    - url: "${get_sp('war_repo_root_url')}"
  workflow:
    - deploy_account_service:
        do:
          io.cloudslang.demo.aos.sub_flows.initialize_artifact:
            - host: '${account_service_host}'
            - username: '${username}'
            - password: '${password}'
            - artifact_url: "${url+'accountservice/target/accountservice.war'}"
            - script_url: "${get_sp('script_deploy_war')}"
            - parameters: "${'%s %s %s %s %s' % (db_host, db_username, db_password, tomcat_host, account_service_host)}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: deploy_tm_wars
    - deploy_tm_wars:
        loop:
          for: "war in 'catalog','MasterCredit','order','ROOT','ShipEx','SafePay'"
          do:
            io.cloudslang.demo.aos.sub_flows.initialize_artifact:
              - host: '${tomcat_host}'
              - username: '${username}'
              - password: '${password}'
              - artifact_url: "${url+war.lower()+'/target/'+war+'.war'}"
              - script_url: "${get_sp('script_deploy_war')}"
              - parameters: "${'%s %s %s %s %s' % (db_host, db_username, db_password, tomcat_host, account_service_host)}"
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
        'y': 68
      deploy_tm_wars:
        x: 227
        'y': 68
        navigate:
          0cea8b1f-bfeb-3dd9-94f4-c938b314ab15:
            targetId: ba3e8e8a-ed7d-90af-1b65-c7f0dd4421c0
            port: SUCCESS
    results:
      SUCCESS:
        ba3e8e8a-ed7d-90af-1b65-c7f0dd4421c0:
          x: 399
          'y': 78
