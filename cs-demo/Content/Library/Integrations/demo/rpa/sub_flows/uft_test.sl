namespace: io.cloudslang.demo.rpa.sub_flows
flow:
  name: uft_test
  inputs:
    - test_path
    - test_parameters
  workflow:
    - run_test:
        do:
          io.cloudslang.microfocus.uft.run_test:
            - host: "${get_sp('uft_host')}"
            - username: "${get_sp('uft_username')}"
            - password:
                value: "${get_sp('uft_password')}"
                sensitive: true
            - port: "${get_sp('uft_port')}"
            - protocol: "${get_sp('uft_protocol')}"
            - is_test_visible: "${get_sp('uft_is_test_visible')}"
            - test_path
            - test_results_path: "${get_sp('uft_result_location')}"
            - uft_workspace_path: "${get_sp('uft_result_location')}"
            - test_parameters
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
