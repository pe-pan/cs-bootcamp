namespace: AOS
flow:
  name: remote_copy
  inputs:
    - host: 10.0.46.20
    - username: root
    - password: admin@123
    - url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_tomcat.sh'
    - filename:
        default: ''
        required: false
  workflow:
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${filename}'
            - second_string: ''
        navigate:
          - SUCCESS: uuid_generator
          - FAILURE: http_client_action
    - uuid_generator:
        do:
          io.cloudslang.base.utils.uuid_generator: []
        publish:
          - filename: '${new_uuid}'
        navigate:
          - SUCCESS: http_client_action
    - remote_secure_copy:
        do:
          io.cloudslang.base.remote_file_transfer.remote_secure_copy:
            - source_path: '${filename}'
            - destination_host: '${host}'
            - destination_path: "${get_sp('script_location')}"
            - destination_username: '${username}'
            - destination_password:
                value: '${password}'
                sensitive: true
            - known_hosts_policy: null
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - http_client_action:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: '${url}'
            - destination_file: '${filename}'
            - method: GET
        publish:
          - destination_file
        navigate:
          - SUCCESS: remote_secure_copy
          - FAILURE: on_failure
  outputs:
    - destination_file: '${destination_file}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      uuid_generator:
        x: 338
        y: 37
      http_client_action:
        x: 147
        y: 253
      remote_secure_copy:
        x: 363
        y: 248
        navigate:
          94ad61f2-64c4-a3a5-1647-6eb06ac1b687:
            targetId: 1a4b4e41-715c-4454-4553-8668c9592a94
            port: SUCCESS
      string_equals:
        x: 189
        y: 29
    results:
      SUCCESS:
        1a4b4e41-715c-4454-4553-8668c9592a94:
          x: 483
          y: 146
