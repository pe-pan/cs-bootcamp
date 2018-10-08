namespace: io.cloudslang.demo.aos.test
flow:
  name: deploy_3_vm_aos
  inputs:
    - username: root
    - password: admin@123
  workflow:
    - deploy_3_vms:
        do:
          io.cloudslang.demo.vmware.deploy_3_vms: []
        publish:
          - db_host
          - tomcat_host
          - account_service_host
        navigate:
          - FAILURE: on_failure
          - SUCCESS: install_aos
    - install_aos:
        do:
          demo.aos.install_aos:
            - username: '${username}'
            - password: '${password}'
            - tomcat_host: '${tomcat_host}'
            - account_service_host: '${account_service_host}'
            - db_host: '${db_host}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - tomcat_host: '${tomcat_host}'
    - account_service_host: '${account_service_host}'
    - db_host: '${db_host}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      deploy_3_vms:
        x: 131
        y: 30
      install_aos:
        x: 263
        y: 35
        navigate:
          96253e70-39e7-986f-0c32-b02684404543:
            targetId: cea6732a-877d-dc69-d2f7-f7c6ee42ac23
            port: SUCCESS
    results:
      SUCCESS:
        cea6732a-877d-dc69-d2f7-f7c6ee42ac23:
          x: 427
          y: 44
