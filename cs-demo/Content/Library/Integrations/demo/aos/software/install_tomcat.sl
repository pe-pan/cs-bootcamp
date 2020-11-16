namespace: Integrations.demo.aos.software
flow:
  name: install_tomcat
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
    - install_tomcat:
        do:
          io.cloudslang.demo.aos.sub_flows.initialize_artifact:
            - host: '${tomcat_host}'
            - username: '${username}'
            - password: '${password}'
            - script_url: "${get_sp('script_install_tomcat')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      install_tomcat:
        x: 170
        'y': 94
        navigate:
          10424b3d-ea88-e76a-3fa3-9f6e64b21d81:
            targetId: cea6732a-877d-dc69-d2f7-f7c6ee42ac23
            port: SUCCESS
    results:
      SUCCESS:
        cea6732a-877d-dc69-d2f7-f7c6ee42ac23:
          x: 391
          'y': 219
