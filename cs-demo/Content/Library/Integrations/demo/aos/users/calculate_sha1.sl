namespace: Integrations.demo.aos.users
flow:
  name: calculate_sha1
  inputs:
    - host
    - user
    - password:
        sensitive: true
    - text
  workflow:
    - ssh_command:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${\"echo -n '\"+text+\"' | sha1sum | awk '{print $1}'\"}"
            - username: '${user}'
            - password:
                value: '${password}'
                sensitive: true
        publish:
          - sha1: '${return_result.strip()}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - sha1: '${sha1}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      ssh_command:
        x: 74
        'y': 84
        navigate:
          193766f7-6ef8-a58e-dffd-bfa377206dd6:
            targetId: 1f59e034-87c4-d871-d47d-b167b8654125
            port: SUCCESS
    results:
      SUCCESS:
        1f59e034-87c4-d871-d47d-b167b8654125:
          x: 254
          'y': 90
