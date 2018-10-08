namespace: io.cloudslang.demo.aos.sub_flows
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
    - copy_artifact:
        do:
          io.cloudslang.demo.aos.sub_flows.remote_copy:
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
          io.cloudslang.demo.aos.sub_flows.remote_copy:
            - host: '${host}'
            - username: '${username}'
            - password: '${password}'
            - url: '${script_url}'
        publish:
          - script_name: '${filename}'
        navigate:
          - SUCCESS: ssh_command
          - FAILURE: on_failure
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
    - delete_script:
        do:
          io.cloudslang.demo.aos.tools.delete_file:
            - host: '${host}'
            - username: '${username}'
            - password: '${password}'
            - filename: '${script_name}'
        navigate:
          - SUCCESS: has_failed
          - FAILURE: on_failure
    - has_failed:
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
      is_artifact_given:
        x: 257
        y: 6
      copy_artifact:
        x: 49
        y: 160
      copy_script:
        x: 418
        y: 161
      ssh_command:
        x: 55
        y: 310
      delete_script:
        x: 248
        y: 313
      has_failed:
        x: 450
        y: 302
        navigate:
          a7b67100-7a2a-61eb-082d-35c018efd945:
            targetId: 8f9aa1a2-b5b4-6a09-5bdb-9fb94e9ab2e0
            port: 'FALSE'
          32d64d81-cd17-48ab-7477-adfe61dd28aa:
            targetId: 4012d319-d667-dea9-65f4-2b24e29f9ae5
            port: 'TRUE'
    results:
      FAILURE:
        8f9aa1a2-b5b4-6a09-5bdb-9fb94e9ab2e0:
          x: 555
          y: 361
      SUCCESS:
        4012d319-d667-dea9-65f4-2b24e29f9ae5:
          x: 548
          y: 247
