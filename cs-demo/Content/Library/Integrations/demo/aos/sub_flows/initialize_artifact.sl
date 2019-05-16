namespace: io.cloudslang.demo.aos.sub_flows
flow:
  name: initialize_artifact
  inputs:
    - host
    - username
    - password
    - artifact_url:
        required: false
    - script_url
    - parameters:
        required: false
  workflow:
    - retry_initialize_artifact:
        loop:
          for: "retries in range(0,int(get_sp('script_retries')))"
          do:
            Integrations.demo.aos.sub_flows.retry_initialize_artifact:
              - host: '${host}'
              - username: '${username}'
              - password: '${password}'
              - artifact_url: '${artifact_url}'
              - script_url: '${script_url}'
              - parameters: '${parameters}'
          break:
            - SUCCESS
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      retry_initialize_artifact:
        x: 181
        y: 131
        navigate:
          91ef2ab1-259c-a2a7-c273-8b1892b00801:
            targetId: 4012d319-d667-dea9-65f4-2b24e29f9ae5
            port: SUCCESS
    results:
      SUCCESS:
        4012d319-d667-dea9-65f4-2b24e29f9ae5:
          x: 394
          y: 124
