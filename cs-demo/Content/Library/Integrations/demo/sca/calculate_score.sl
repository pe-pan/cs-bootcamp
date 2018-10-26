namespace: Integrations.demo.sca
flow:
  name: calculate_score
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
    - level: critical
  workflow:
    - calculate_score:
        do:
          io.cloudslang.base.ssh.ssh_flow:
            - host: "${get('host', get_sp('sca_host'))}"
            - command: "${'cat '+get_sp('sca_scan_result')+' | grep \"'+level+'\" | wc -l'}"
            - username: "${get('username', get_sp('sca_username'))}"
            - password:
                value: "${get('password', get_sp('sca_password'))}"
                sensitive: true
        publish:
          - score: '${standard_out}'
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
      calculate_score:
        x: 83
        y: 74
        navigate:
          6e935757-1dd6-299c-ca4f-0bf225efcb52:
            targetId: 040e6b9e-6901-69d4-885d-82f4da1d1529
            port: SUCCESS
    results:
      SUCCESS:
        040e6b9e-6901-69d4-885d-82f4da1d1529:
          x: 237
          y: 80
