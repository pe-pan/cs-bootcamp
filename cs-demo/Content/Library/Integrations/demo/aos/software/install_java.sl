namespace: Integrations.demo.aos.software
flow:
  name: install_java
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
    - install_java:
        do:
          io.cloudslang.demo.aos.sub_flows.initialize_artifact:
            - host: '${tomcat_host}'
            - username: '${username}'
            - password: '${password}'
            - script_url: "${get_sp('script_install_java')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      install_java:
        x: 69
        'y': 108
        navigate:
          c13f4bb8-a991-6186-f115-770df55334cf:
            targetId: cea6732a-877d-dc69-d2f7-f7c6ee42ac23
            port: SUCCESS
    results:
      SUCCESS:
        cea6732a-877d-dc69-d2f7-f7c6ee42ac23:
          x: 250
          'y': 134
