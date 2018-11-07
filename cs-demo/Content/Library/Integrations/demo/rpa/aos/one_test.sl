namespace: Integrations.demo.rpa.aos
flow:
  name: one_test
  inputs:
    - aos_host: 10.0.46.65
    - aos_password: Cloud_123
  workflow:
    - uuid_generator:
        do:
          io.cloudslang.base.utils.uuid_generator: []
        publish:
          - aos_user: '${new_uuid[:8]}'
        navigate:
          - SUCCESS: uft_aos_new_user
    - uft_aos_new_user:
        do:
          io.cloudslang.demo.rpa.aos.uft_aos_new_user:
            - aos_host: '${aos_host}'
            - aos_user: '${aos_user}'
            - aos_password:
                value: '${aos_password}'
                sensitive: true
        navigate:
          - FAILURE: on_failure
          - SUCCESS: uft_aos_buy_item
    - uft_aos_buy_item:
        do:
          io.cloudslang.demo.rpa.aos.uft_aos_buy_item:
            - aos_host: '${aos_host}'
            - aos_user: '${aos_user}'
            - aos_password:
                value: '${aos_password}'
                sensitive: true
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      uft_aos_new_user:
        x: 180
        y: 131
      uft_aos_buy_item:
        x: 309
        y: 135
        navigate:
          7c087ae6-7d46-f8c4-f797-adea2e48ee4a:
            targetId: f5e0902d-fcf0-f32d-f755-47b5dd02d8f0
            port: SUCCESS
      uuid_generator:
        x: 26
        y: 141
    results:
      SUCCESS:
        f5e0902d-fcf0-f32d-f755-47b5dd02d8f0:
          x: 432
          y: 131
