namespace: Integrations.demo.aos.software
flow:
  name: install_postgres
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
    - install_postgres:
        do:
          io.cloudslang.demo.aos.sub_flows.initialize_artifact:
            - host: "${get('db_host', tomcat_host)}"
            - username: '${username}'
            - password: '${password}'
            - script_url: "${get_sp('script_install_postgres')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      install_postgres:
        x: 63
        'y': 70
        navigate:
          d8995d95-7b88-dd58-5c83-197b03df2677:
            targetId: cea6732a-877d-dc69-d2f7-f7c6ee42ac23
            port: SUCCESS
    results:
      SUCCESS:
        cea6732a-877d-dc69-d2f7-f7c6ee42ac23:
          x: 58
          'y': 286
