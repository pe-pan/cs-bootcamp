namespace: Integrations.demo.sca
flow:
  name: prepare_source_code
  inputs:
    - host:
        default: "${get_sp('sca_host')}"
        required: false
    - username:
        default: "${get_sp('sca_username')}"
        required: false
    - password:
        default: "${get_sp('sca_password')}"
        required: false
        sensitive: true
    - folder:
        default: "${get_sp('sca_folder')}"
        required: false
  workflow:
    - copy_folder_to_scan:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: "${get('host', get_sp('sca_host'))}"
            - command: "${'docker cp 1f78e25b3b74:/var/lib/jenkins/workspace'+get('folder',get_sp('sca_folder'))+' '+get_sp('sca_scan_input')}"
            - username: "${get('username', get_sp('sca_username'))}"
            - password:
                value: "${get('password', get_sp('sca_password'))}"
                sensitive: true
            - scan_input: "${get_sp('sca_scan_input')}"
        publish:
          - scan_input: "${get_sp('sca_scan_input')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - scan_input: '${scan_input}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      copy_folder_to_scan:
        x: 76
        y: 73
        navigate:
          d4d9b022-1d97-6825-464b-a46f2f76af49:
            targetId: 7fac5ab9-0baa-5d5a-a09d-568cd529f387
            port: SUCCESS
    results:
      SUCCESS:
        7fac5ab9-0baa-5d5a-a09d-568cd529f387:
          x: 244
          y: 80
