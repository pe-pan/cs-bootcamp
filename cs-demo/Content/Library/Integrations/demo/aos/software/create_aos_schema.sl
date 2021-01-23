namespace: Integrations.demo.aos.software
flow:
  name: create_aos_schema
  inputs:
    - db_host
    - db_port: '5432'
    - db_username
    - db_password
    - sql_command:
        default: |-
          ${'''create database adv_account;
          create database adv_catalog;
          create database adv_order;
          '''}
        private: true
  workflow:
    - sql_command:
        do:
          io.cloudslang.base.database.sql_command:
            - db_server_name: '${db_host}'
            - db_type: PostgreSQL
            - username: '${db_username}'
            - password:
                value: '${db_password}'
                sensitive: true
            - db_port: '${db_port}'
            - database_name: postgres
            - command: '${sql_command}'
            - trust_all_roots: 'true'
        publish:
          - return_code
          - return_result
          - update_count
          - output_text
          - exception
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      sql_command:
        x: 86
        'y': 80
        navigate:
          81eb30eb-28a4-40d9-1801-d3b0e07532d8:
            targetId: e380e999-74dd-a38f-6c1f-755157c081d7
            port: SUCCESS
    results:
      SUCCESS:
        e380e999-74dd-a38f-6c1f-755157c081d7:
          x: 276
          'y': 79
