namespace: demo.aos
flow:
  name: initialize_artifact
  inputs:
    - host: 10.0.46.51
    - username: root
    - password: admin@123
    - artifact_url:
        required: false
    - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_tomcat.sh'
    - parameters:
        required: false
  workflow:
    - is_artifact_given:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${artifact_url}'
            - second_string: ''
        navigate:
          - SUCCESS: copy_script
          - FAILURE: copy_artifact
    - ssh_command:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && chmod 755 '+script_name+' && sh '+script_name+' '+get('artifact_name', '')+' '+get('parameters', '')+' > '+script_name+'.log'}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - timeout: '300000'
        publish:
          - command_return_code
        navigate:
          - SUCCESS: delete_script
          - FAILURE: delete_script
    - copy_artifact:
        do:
          demo.aos.remote_copy:
            - host: '${host}'
            - username: '${username}'
            - password: '${password}'
            - url: '${artifact_url}'
        publish:
          - artifact_name: '${filename}'
        navigate:
          - SUCCESS: copy_script
          - FAILURE: on_failure
    - copy_script:
        do:
          demo.aos.remote_copy:
            - host: '${host}'
            - username: '${username}'
            - password: '${password}'
            - url: '${script_url}'
        publish:
          - script_name: '${filename}'
        navigate:
          - SUCCESS: ssh_command
          - FAILURE: on_failure
    - delete_script:
        do:
          demo.aos.delete_file:
            - host: '${host}'
            - username: '${username}'
            - password: '${password}'
            - filename: '${script_name}'
        navigate:
          - SUCCESS: is_true
          - FAILURE: on_failure
    - is_true:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(command_return_code == '0')}"
        navigate:
          - 'TRUE': SUCCESS
          - 'FALSE': FAILURE
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      is_true:
        x: 466
        y: 462
        navigate:
          a7b67100-7a2a-61eb-082d-35c018efd945:
            targetId: 8f9aa1a2-b5b4-6a09-5bdb-9fb94e9ab2e0
            port: 'FALSE'
          32d64d81-cd17-48ab-7477-adfe61dd28aa:
            targetId: 4012d319-d667-dea9-65f4-2b24e29f9ae5
            port: 'TRUE'
      is_artifact_given:
        x: 257
        y: 6
      ssh_command:
        x: 77
        y: 340
      copy_script:
        x: 556
        y: 197
      copy_artifact:
        x: 56
        y: 183
      delete_script:
        x: 256
        y: 442
    results:
      FAILURE:
        8f9aa1a2-b5b4-6a09-5bdb-9fb94e9ab2e0:
          x: 551
          y: 555
      SUCCESS:
        4012d319-d667-dea9-65f4-2b24e29f9ae5:
          x: 551
          y: 368
