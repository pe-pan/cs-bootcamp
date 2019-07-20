namespace: Integrations.demo.aos.users
flow:
  name: create_users
  inputs:
    - file_host: itom1.hcm.demo.local
    - file_user: root
    - file_password:
        default: S0lutions2016
        sensitive: true
    - file_path: /tmp/users.txt
    - db_host:
        default: 10.0.46.38
        required: true
    - db_user: postgres
    - db_password:
        default: admin
        sensitive: true
    - mm_url: 'https://mattermost.hcm.demo.local'
    - mm_user: admin
    - mm_password:
        default: Cloud_123
        sensitive: true
    - mm_chanel_id: eeujbpz9ufbc8rxcyj9qhcgq3a
  workflow:
    - read_users:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${file_host}'
            - command: "${'cat '+file_path}"
            - username: '${file_user}'
            - password:
                value: '${file_password}'
                sensitive: true
        publish:
          - file_content: '${return_result}'
        navigate:
          - SUCCESS: create_user
          - FAILURE: on_failure
    - create_user:
        loop:
          for: credentials in file_content.split()
          do:
            Integrations.demo.aos.users.create_user:
              - credentials: '${credentials}'
              - file_host: '${file_host}'
              - file_user: '${file_user}'
              - file_password: '${file_password}'
              - db_host: '${db_host}'
              - db_user: '${db_user}'
              - db_password: '${db_password}'
              - mm_url: '${mm_url}'
              - mm_user: '${mm_user}'
              - mm_password: '${mm_password}'
              - mm_chanel_id: '${mm_chanel_id}'
          break: []
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      read_users:
        x: 144
        'y': 25
      create_user:
        x: 315
        'y': 27
        navigate:
          f4288d4b-8ebb-5a28-1f60-ec42cdd5a3d6:
            targetId: 3df8d638-80de-08c8-c8c2-a1db108af546
            port: SUCCESS
    results:
      SUCCESS:
        3df8d638-80de-08c8-c8c2-a1db108af546:
          x: 479
          'y': 38
