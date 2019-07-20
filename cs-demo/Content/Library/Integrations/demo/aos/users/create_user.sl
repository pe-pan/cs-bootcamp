namespace: Integrations.demo.aos.users
flow:
  name: create_user
  inputs:
    - file_host
    - file_user
    - file_password:
        sensitive: true
    - credentials
    - db_host:
        required: false
    - db_user
    - db_password:
        sensitive: true
    - mm_url
    - mm_user
    - mm_password:
        sensitive: true
    - mm_chanel_id
  workflow:
    - parse_credentials:
        do:
          Integrations.demo.aos.users.parse_credentials:
            - credentials: '${credentials}'
        publish:
          - created_name: '${name}'
          - created_password: '${password}'
        navigate:
          - SUCCESS: calculate_sha1
    - calculate_sha1:
        do:
          Integrations.demo.aos.users.calculate_sha1:
            - host: '${file_host}'
            - user: '${file_user}'
            - password: '${file_password}'
            - text: '${created_password}'
        publish:
          - password_sha1: '${sha1}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: calculate_sha1_1
    - calculate_sha1_1:
        do:
          Integrations.demo.aos.users.calculate_sha1:
            - host: '${file_host}'
            - user: '${file_user}'
            - password: '${file_password}'
            - text: '${created_name[::-1]+password_sha1}'
        publish:
          - username_password_sha1: '${sha1}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: random_number_generator
    - random_number_generator:
        do:
          io.cloudslang.base.math.random_number_generator:
            - min: '100000000'
            - max: '1000000000'
        publish:
          - user_id: '${random_number}'
        navigate:
          - SUCCESS: sql_command
          - FAILURE: on_failure
    - sql_command:
        do:
          io.cloudslang.base.database.sql_command:
            - db_server_name: '${db_host}'
            - db_type: PostgreSQL
            - username: '${db_user}'
            - password:
                value: '${db_password}'
                sensitive: true
            - database_name: adv_account
            - command: "${\"INSERT INTO account (user_id, user_type, active, agree_to_receive_offers, defaultpaymentmethodid, email, internallastsuccesssullogin, internalunsuccessfulloginattempts, internaluserblockedfromloginuntil, login_name, password, country_id) VALUES (\"+user_id+\", 20, 'Y', true, 0, 'someone@microfocus.com', 0, 0, 0, '\"+created_name+\"', '\"+username_password_sha1+\"', 210);\"}"
            - trust_all_roots: 'true'
        navigate:
          - SUCCESS: Send_Message
          - FAILURE: on_failure
    - Send_Message:
        do_external:
          857765d8-88d5-4ee1-8970-ed6a8e0d0545:
            - url: '${mm_url}'
            - username: '${mm_user}'
            - password: '${mm_password}'
            - channel_id: '${mm_chanel_id}'
            - message: "${'User '+created_name+' added to AOS at '+db_host}"
        navigate:
          - success: SUCCESS
          - failure: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      parse_credentials:
        x: 63
        'y': 80
      calculate_sha1:
        x: 60
        'y': 276
      calculate_sha1_1:
        x: 225
        'y': 290
      random_number_generator:
        x: 213
        'y': 84
      sql_command:
        x: 394
        'y': 89
      Send_Message:
        x: 399
        'y': 287
        navigate:
          6f37944f-8d50-4e1b-b5c5-089a01031da6:
            targetId: 7146e8d1-b53c-2736-4230-665808e3e63f
            port: success
    results:
      SUCCESS:
        7146e8d1-b53c-2736-4230-665808e3e63f:
          x: 397
          'y': 454
