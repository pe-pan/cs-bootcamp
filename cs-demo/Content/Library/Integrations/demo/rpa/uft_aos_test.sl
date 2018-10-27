namespace: io.cloudslang.demo.rpa
flow:
  name: uft_aos_test
  inputs:
    - aos_host: 10.0.46.58
    - aos_user: pepan
    - aos_password:
        default: Cloud_123
        sensitive: true
    - catalog: TABLETS
    - item: HP ElitePad 1000 G2 Tablet
    - uft_test_location:
        default: "C:\\Users\\Administrator\\Documents\\Unified Functional Testing\\AOS\\AOS"
        required: true
  workflow:
    - run_test:
        do:
          io.cloudslang.microfocus.uft.run_test:
            - host: "${get_sp('uft_host')}"
            - username: "${get_sp('uft_username')}"
            - password:
                value: "${get_sp('uft_password')}"
                sensitive: true
            - port: '5985'
            - protocol: http
            - is_test_visible: 'true'
            - test_path: '${uft_test_location}'
            - test_results_path: "${get_sp('uft_result_location')}"
            - uft_workspace_path: "${get_sp('uft_result_location')}"
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
