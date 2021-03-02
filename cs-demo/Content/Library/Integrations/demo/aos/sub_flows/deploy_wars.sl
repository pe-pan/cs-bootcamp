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
    - password:
        required: false
    - db_username
    - db_password
    - url: "${get_sp('war_repo_root_url')}"
    - deploy_admin
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
          - SUCCESS: is_true
          - FAILURE: on_failure
    - deploy_admin_war:
        do:
          io.cloudslang.demo.aos.sub_flows.initialize_artifact:
            - host: '${tomcat_host}'
            - username: '${username}'
            - password: '${password}'
            - artifact_url: "${url+'admin/target/admin.war'}"
            - script_url: "${get_sp('script_deploy_war')}"
            - parameters: "${'%s %s %s %s %s' % (db_host, db_username, db_password, tomcat_host, account_service_host)}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - is_true:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${deploy_admin}'
        navigate:
          - 'TRUE': deploy_admin_war
          - 'FALSE': SUCCESS
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
      deploy_admin_war:
        x: 436
        'y': 251
        navigate:
          765abeae-62f4-1ef5-6b54-bfcca612c1a7:
            targetId: ba3e8e8a-ed7d-90af-1b65-c7f0dd4421c0
            port: SUCCESS
      is_true:
        x: 436
        'y': 65
        navigate:
          d15532a2-97c1-c434-dee7-84889b318d0a:
            targetId: ba3e8e8a-ed7d-90af-1b65-c7f0dd4421c0
            port: 'FALSE'
    results:
      SUCCESS:
        ba3e8e8a-ed7d-90af-1b65-c7f0dd4421c0:
          x: 644
          'y': 72
