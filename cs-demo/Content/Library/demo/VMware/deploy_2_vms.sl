namespace: demo.VMware
flow:
  name: deploy_2_vms
  inputs:
    - username: root
    - password: admin@123
  workflow:
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
          - SUCCESS: SUCCESS
  outputs:
    - db_host: '${db_host}'
    - tomcat_host: '${tomcat_host}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      deploy_tomcat_vm:
        x: 189
        y: 80
        navigate:
          bb3632d8-0f1c-8e68-1cd6-3f46d6b9bfea:
            targetId: cea6732a-877d-dc69-d2f7-f7c6ee42ac23
            port: SUCCESS
      deploy_db_vm:
        x: 47
        y: 77
    results:
      SUCCESS:
        cea6732a-877d-dc69-d2f7-f7c6ee42ac23:
          x: 469
          y: 94
