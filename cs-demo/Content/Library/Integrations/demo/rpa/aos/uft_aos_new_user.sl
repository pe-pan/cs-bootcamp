namespace: io.cloudslang.demo.rpa.aos
flow:
  name: uft_aos_new_user
  inputs:
    - aos_host: 10.0.46.53
    - aos_user: pepan
    - aos_password:
        default: Cloud_123
        sensitive: true
    - test_path:
        default: "C:\\temp\\AOS_new_user"
  workflow:
    - uft_test:
        do:
          io.cloudslang.demo.rpa.sub_flows.uft_test:
            - test_path
            - test_parameters: "${'host:'+aos_host+',user:'+aos_user+',password:'+aos_password}"
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
      uft_test:
        x: 100
        y: 100
        navigate:
          a04ab44a-5294-1dbf-ad77-a71ca4fa134c:
            targetId: 9e1a9c39-fc2b-7d85-9379-ad9d3fcf432a
            port: SUCCESS
    results:
      SUCCESS:
        9e1a9c39-fc2b-7d85-9379-ad9d3fcf432a:
          x: 242
          y: 98
