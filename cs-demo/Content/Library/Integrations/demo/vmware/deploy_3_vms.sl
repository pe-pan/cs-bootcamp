namespace: io.cloudslang.demo.vmware
flow:
  name: deploy_3_vms
  workflow:
    - deploy_vm:
        parallel_loop:
          for: "prefix in 'petr-tm-','petr-as-','petr-db-'"
          do:
            io.cloudslang.demo.vmware.deploy_vm:
              - prefix: '${prefix}'
        publish:
          - ip_list: '${str([str(x["ip"]) for x in branches_context])}'
          - tomcat_host: '${str(branches_context[0]["ip"])}'
          - account_service_host: '${str(branches_context[1]["ip"])}'
          - db_host: '${str(branches_context[2]["ip"])}'
          - vm_name_list: '${str([str(x["vm_name"]) for x in branches_context])}'
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
        x: 82
        y: 96
        navigate:
          4896daf2-c3e5-9e26-b9e2-eca2821bb7bb:
            targetId: cea6732a-877d-dc69-d2f7-f7c6ee42ac23
            port: SUCCESS
    results:
      SUCCESS:
        cea6732a-877d-dc69-d2f7-f7c6ee42ac23:
          x: 284
          y: 100
