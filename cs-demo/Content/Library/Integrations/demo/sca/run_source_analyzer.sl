namespace: Integrations.demo.sca
flow:
  name: run_source_analyzer
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
    - scan_input:
        default: "${get_sp('sca_scan_input')}"
        required: false
    - scan_result:
        default: "${get_sp('sca_scan_result')}"
        required: false
  workflow:
    - ssh_flow:
        do:
          io.cloudslang.base.ssh.ssh_flow:
            - host: "${get('host', get_sp('sca_host'))}"
            - command: "${'sourceanalyzer -scan '+get('scan_input', get_sp('sca_scan_input'))+' -f '+get('scan_result', get_sp('sca_scan_result'))}"
            - username: "${get('username', get_sp('sca_username'))}"
            - password:
                value: "${get('password', get_sp('sca_password'))}"
                sensitive: true
        publish: []
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - score: '${score}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      ssh_flow:
        x: 215
        y: 224
        navigate:
          6e935757-1dd6-299c-ca4f-0bf225efcb52:
            targetId: 040e6b9e-6901-69d4-885d-82f4da1d1529
            port: SUCCESS
    results:
      SUCCESS:
        040e6b9e-6901-69d4-885d-82f4da1d1529:
          x: 399
          y: 225
