namespace: Integrations.demo.aos.application
flow:
  name: install_aos_application
  inputs:
    - username: petr
    - password:
        default: Cloud_123Cloud_123
        sensitive: false
    - tomcat_host: 51.143.88.232
    - account_service_host:
        required: false
    - db_username:
        default: petr
        required: false
    - db_password:
        default: Cloud_123Cloud_123
        required: false
    - db_host:
        default: hybriddb2f4808d.c4nvcbxp4icc.ap-southeast-1.rds.amazonaws.com
        required: false
  workflow:
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
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      deploy_aos_wars:
        x: 192
        'y': 210
        navigate:
          8d48cf49-b8e3-8b3d-2054-a44f2582efc2:
            targetId: cea6732a-877d-dc69-d2f7-f7c6ee42ac23
            port: SUCCESS
    results:
      SUCCESS:
        cea6732a-877d-dc69-d2f7-f7c6ee42ac23:
          x: 391
          'y': 219
