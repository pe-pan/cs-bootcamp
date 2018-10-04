namespace: AOS
flow:
  name: full_deployment
  workflow:
    - deploy_vm:
        do:
          AOS.deploy_vm: []
        publish:
          - ip
        navigate:
          - FAILURE: on_failure
          - SUCCESS: existing_vm
    - existing_vm:
        do:
          AOS.existing_vm:
            - host: '${ip}'
        publish: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      deploy_vm:
        x: 144
        y: 60
      existing_vm:
        x: 285
        y: 66
        navigate:
          1f9fafcc-4c49-48d9-e3d3-002d318ca133:
            targetId: 66a11ea4-af37-4c95-31e5-f552b0d2aa99
            port: SUCCESS
    results:
      SUCCESS:
        66a11ea4-af37-4c95-31e5-f552b0d2aa99:
          x: 425
          y: 65
