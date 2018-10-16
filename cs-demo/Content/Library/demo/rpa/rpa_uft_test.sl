namespace: demo.rpa
flow:
  name: rpa_uft_test
  inputs:
    - aos_host: 10.0.46.50
    - aos_user: pepan
    - aos_password: Cloud_123
    - catalog: TABLETS
    - item: HP ElitePad 1000 G2 Tablet
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
            - test_path: "C:\\Users\\Administrator\\Documents\\Unified Functional Testing\\AOS"
            - test_results_path: "${get_sp('uft_result_location')}"
            - uft_workspace_path: "${get_sp('uft_result_location')}"
            - test_parameters: "${'host:'+aos_host+',user:'+aos_user+',password:'+aos_password+',catalog:'+catalog+',item:'+item}"
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
