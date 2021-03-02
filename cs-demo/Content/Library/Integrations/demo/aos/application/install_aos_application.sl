namespace: Integrations.demo.aos.application
flow:
  name: install_aos_application
  inputs:
    - username
    - password:
        required: false
        sensitive: true
    - tomcat_host
    - account_service_host:
        required: false
    - db_username:
        required: false
    - db_password:
        required: false
        sensitive: true
    - db_host:
        required: false
    - db_port: '5432'
    - deploy_admin: 'true'
  workflow:
    - create_aos_schema:
        do:
          Integrations.demo.aos.software.create_aos_schema:
            - db_host: '${db_host}'
            - db_port: '${db_port}'
            - db_username: '${db_username}'
            - db_password: '${db_password}'
        navigate:
          - FAILURE: deploy_aos_wars
          - SUCCESS: deploy_aos_wars
    - deploy_aos_wars:
        do:
          io.cloudslang.demo.aos.sub_flows.deploy_wars:
            - tomcat_host: '${tomcat_host}'
            - account_service_host: "${get('account_service_host', tomcat_host)}"
            - db_host: "${get('db_host', tomcat_host)}"
            - username: '${username}'
            - password: '${password}'
            - db_username: '${db_username}'
            - db_password: '${db_password}'
            - deploy_admin: '${deploy_admin}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      create_aos_schema:
        x: 71
        'y': 191.34375
      deploy_aos_wars:
        x: 233
        'y': 199
        navigate:
          8d48cf49-b8e3-8b3d-2054-a44f2582efc2:
            targetId: cea6732a-877d-dc69-d2f7-f7c6ee42ac23
            port: SUCCESS
    results:
      SUCCESS:
        cea6732a-877d-dc69-d2f7-f7c6ee42ac23:
          x: 393
          'y': 198
