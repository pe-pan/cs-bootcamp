namespace: Integrations.demo.aos.application
flow:
  name: install_aos_application
  inputs:
    - username:
        prompt:
          type: text
        default: root
    - password:
        prompt:
          type: text
        default: Cloud_1234
        sensitive: true
    - tomcat_host:
        prompt:
          type: text
    - account_service_host:
        required: false
    - db_host:
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
