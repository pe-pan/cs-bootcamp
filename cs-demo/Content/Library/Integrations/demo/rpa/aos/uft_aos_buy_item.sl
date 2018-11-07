namespace: io.cloudslang.demo.rpa.aos
flow:
  name: uft_aos_buy_item
  inputs:
    - aos_host: 10.0.46.53
    - aos_user: pepan
    - aos_password:
        default: Cloud_123
        sensitive: true
    - catalog: TABLETS
    - item: HP ElitePad 1000 G2 Tablet
    - test_path:
        default: "C:\\temp\\AOS_buy_item"
  workflow:
    - uft_test:
        do:
          io.cloudslang.demo.rpa.sub_flows.uft_test:
            - test_path
            - test_parameters: "${'host:'+aos_host+',user:'+aos_user+',password:'+aos_password+',catalog:'+catalog+',item:'+item}"
        publish:
          - return_code
          - script_exit_code
          - test_return_result
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - test_return_result: '${test_return_result}'
    - script_exit_code: '${script_exit_code}'
    - return_code: '${return_code}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      uft_test:
        x: 100
        y: 100
        navigate:
          8945afe2-a99d-ad18-db1b-f5041e6ef823:
            targetId: 9e1a9c39-fc2b-7d85-9379-ad9d3fcf432a
            port: SUCCESS
    results:
      SUCCESS:
        9e1a9c39-fc2b-7d85-9379-ad9d3fcf432a:
          x: 242
          y: 98
