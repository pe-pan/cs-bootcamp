namespace: demo.rpa
flow:
  name: test
  workflow:
    - run_test:
        do:
          io.cloudslang.microfocus.uft.run_test:
            - host: 172.16.239.35
            - username: administrator
            - password:
                value: Solutions@2016
                sensitive: true
            - port: '5985'
            - protocol: http
            - is_test_visible: 'true'
            - test_path: "C:\\Users\\Administrator\\Documents\\Unified Functional Testing\\AOS"
            - test_results_path: "c:\\temp"
            - uft_workspace_path: "c:\\temp"
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
        x: 412
        y: 224
        navigate:
          4775ca2f-d696-61eb-1bd4-3db0942e668b:
            targetId: 9e1a9c39-fc2b-7d85-9379-ad9d3fcf432a
            port: SUCCESS
    results:
      SUCCESS:
        9e1a9c39-fc2b-7d85-9379-ad9d3fcf432a:
          x: 532
          y: 217
