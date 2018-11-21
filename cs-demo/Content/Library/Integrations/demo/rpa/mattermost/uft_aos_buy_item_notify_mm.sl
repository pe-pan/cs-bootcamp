namespace: Integrations.demo.rpa.mattermost
flow:
  name: uft_aos_buy_item_notify_mm
  inputs:
    - aos_host: 10.0.46.53
    - aos_user: pepan
    - aos_password: Cloud_123
    - catalog: MICE
    - item: Kensington Orbit 72337 Trackball with Scroll Ring
    - test_path: "C:\\temp\\AOS_buy_item"
    - mm_url:
        required: false
    - mm_user:
        required: false
    - mm_password:
        required: false
    - mm_channel_id:
        required: false
  workflow:
    - uft_aos_buy_item:
        do:
          io.cloudslang.demo.rpa.aos.uft_aos_buy_item:
            - aos_host: '${aos_host}'
            - aos_user: '${aos_user}'
            - aos_password:
                value: '${aos_password}'
                sensitive: true
            - catalog: '${catalog}'
            - item: '${item}'
            - test_path: '${test_path}'
        publish:
          - test_return_result
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_session_token
    - get_session_token:
        do:
          authentication.get_session_token:
            - mattermost_url: "${get('mm_url', get_sp('mm_url'))}"
            - username: "${get('mm_user', get_sp('mm_user'))}"
            - password:
                value: "${get('mm_password', get_sp('mm_password'))}"
                sensitive: true
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: create_post
    - create_post:
        do:
          posts.create_post:
            - mattermost_url: "${get('mm_url', get_sp('mm_url'))}"
            - token:
                value: '${token}'
                sensitive: true
            - channel_id: "${get('mm_channel_id', get_sp('mm_channel_id'))}"
            - message: "${item+' from '+catalog+' catalog has been ordered for '+test_return_result}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_session_token:
        x: 58
        y: 273
      uft_aos_buy_item:
        x: 69
        y: 90
      create_post:
        x: 236
        y: 267
        navigate:
          29b66e90-d314-c83e-d8e7-058912b43b03:
            targetId: 0aa19aeb-c3cb-7a37-6b7e-4022dd128134
            port: SUCCESS
    results:
      SUCCESS:
        0aa19aeb-c3cb-7a37-6b7e-4022dd128134:
          x: 229
          y: 93
