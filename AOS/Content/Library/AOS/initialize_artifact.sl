namespace: AOS
flow:
  name: initialize_artifact
  inputs:
    - host: 10.0.46.51
    - username: root
    - password: admin@123
    - artifact_url:
        default: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_tomcat.sh'
        required: false
    - script_url
    - parameters:
        required: false
  workflow:
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${artifact_url}'
            - second_string: ''
        navigate:
          - SUCCESS: copy_script
          - FAILURE: copy_artifact
    - copy_artifact:
        do:
          AOS.remote_copy:
            - host: '${host}'
            - username: '${username}'
            - password: '${password}'
            - url: '${artifact_url}'
        publish:
          - filename: '${destination_file}'
        navigate:
          - SUCCESS: copy_script
          - FAILURE: on_failure
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
    - copy_script:
        do:
          AOS.remote_copy: []
        navigate:
          - SUCCESS: ssh_command
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      copy_artifact:
        x: 172
        y: 132
      ssh_command:
        x: 216
        y: 300
      delete_script:
        x: 401
        y: 417
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
      copy_script:
        x: 396
        y: 134
      string_equals:
        x: 326
        y: 10
    results:
      FAILURE:
        8f9aa1a2-b5b4-6a09-5bdb-9fb94e9ab2e0:
          x: 558
          y: 203
      SUCCESS:
        4012d319-d667-dea9-65f4-2b24e29f9ae5:
          x: 593
          y: 330
