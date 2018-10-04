namespace: AOS
flow:
  name: run_remote_script_old
  inputs:
    - host: 10.0.46.20
    - username: root
    - password: admin@123
    - url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_tomcat.sh'
  workflow:
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
          - SUCCESS: ssh_command
          - FAILURE: delete_script_1
    - http_client_action:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: '${url}'
            - destination_file: '${filename}'
            - method: GET
        navigate:
          - SUCCESS: remote_secure_copy
          - FAILURE: delete_script_1
    - ssh_command:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && chmod 755 '+filename+' && sh '+filename+' > script-execution.log'}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - timeout: '300000'
        navigate:
          - SUCCESS: delete_script
          - FAILURE: delete_script_1
    - delete_script:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && rm -f '+filename}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - delete_script_1:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && rm -f '+filename}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: FAILURE
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      uuid_generator:
        x: 62
        y: 105
      remote_secure_copy:
        x: 79
        y: 274
      http_client_action:
        x: 284
        y: 83
      ssh_command:
        x: 206
        y: 413
      delete_script:
        x: 389
        y: 470
        navigate:
          0f51fb5f-1790-5d36-f61f-97821ecec34a:
            targetId: 4012d319-d667-dea9-65f4-2b24e29f9ae5
            port: SUCCESS
      delete_script_1:
        x: 396
        y: 278
        navigate:
          2d22d686-5587-2bb7-f513-1eb9c042a6e7:
            targetId: 8f9aa1a2-b5b4-6a09-5bdb-9fb94e9ab2e0
            port: SUCCESS
          a9cc86bb-4841-65de-a655-4b0fcb9ec0ed:
            targetId: 8f9aa1a2-b5b4-6a09-5bdb-9fb94e9ab2e0
            port: FAILURE
    results:
      FAILURE:
        8f9aa1a2-b5b4-6a09-5bdb-9fb94e9ab2e0:
          x: 558
          y: 203
      SUCCESS:
        4012d319-d667-dea9-65f4-2b24e29f9ae5:
          x: 551
          y: 394
