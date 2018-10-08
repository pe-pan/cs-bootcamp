namespace: demo.VMware
flow:
  name: deploy_3_vms
  workflow:
    - deploy_vm:
        parallel_loop:
          for: "prefix in 'petr-tm-','petr-as-','petr-db-'"
          do:
            demo.VMware.deploy_vm:
              - prefix: '${prefix}'
        publish:
          - ip_list: '${str([str(x["ip"]) for x in branches_context])}'
          - tomcat_host: '${str(branches_context[0]["ip"])}'
          - account_service_host: '${str(branches_context[1]["ip"])}'
          - db_host: '${str(branches_context[2]["ip"])}'
          - vm_name_list: '${str([str(x["vm_name"]) for x in branches_context])}'
        navigate:
          - FAILURE: deploy_db_vm
          - SUCCESS: SUCCESS
    - deploy_db_vm:
        do:
          demo.VMware.deploy_vm:
            - prefix: petr-db-
        publish:
          - db_host: '${ip}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: deploy_tomcat_vm
    - deploy_tomcat_vm:
        do:
          demo.VMware.deploy_vm:
            - prefix: petr-tm-
        publish:
          - tomcat_host: '${ip}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: deploy_as_vm
    - deploy_as_vm:
        do:
          demo.VMware.deploy_vm:
            - prefix: petr-as-
        publish:
          - account_service_host: '${ip}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - db_host: '${db_host}'
    - tomcat_host: '${tomcat_host}'
    - account_service_host: '${account_service_host}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      deploy_vm:
        x: 93
        y: 232
        navigate:
          4896daf2-c3e5-9e26-b9e2-eca2821bb7bb:
            targetId: cea6732a-877d-dc69-d2f7-f7c6ee42ac23
            port: SUCCESS
      deploy_db_vm:
        x: 47
        y: 77
      deploy_tomcat_vm:
        x: 189
        y: 80
      deploy_as_vm:
        x: 329
        y: 81
        navigate:
          59730ba0-dc15-c45d-c546-0b7cd3dcc0f7:
            targetId: cea6732a-877d-dc69-d2f7-f7c6ee42ac23
            port: SUCCESS
    results:
      SUCCESS:
        cea6732a-877d-dc69-d2f7-f7c6ee42ac23:
          x: 469
          y: 94
