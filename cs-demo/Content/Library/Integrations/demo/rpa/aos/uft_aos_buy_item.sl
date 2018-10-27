namespace: io.cloudslang.demo.rpa.aos
flow:
  name: uft_aos_buy_item
  inputs:
    - aos_host: 10.0.46.29
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
          - return_result
          - return_code
          - script_exit_code
          - script_name
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      run_test:
        x: 72
        y: 89
        navigate:
          4775ca2f-d696-61eb-1bd4-3db0942e668b:
            targetId: 9e1a9c39-fc2b-7d85-9379-ad9d3fcf432a
            port: SUCCESS
    results:
      SUCCESS:
        9e1a9c39-fc2b-7d85-9379-ad9d3fcf432a:
          x: 242
          y: 98
