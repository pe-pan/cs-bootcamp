namespace: demo.aos
flow:
  name: deploy_vm_aos
  inputs:
    - username: root
    - password: admin@123
  workflow:
    - deploy_vm:
        do:
          demo.VMware.deploy_vm: []
        publish:
          - ip
        navigate:
          - FAILURE: on_failure
          - SUCCESS: install_aos
    - install_aos:
        do:
          demo.aos.install_aos:
            - host: '${ip}'
        navigate:
          - SUCCESS: deploy_wars
          - FAILURE: on_failure
    - deploy_wars:
        do:
          demo.aos.deploy_wars:
            - tomcat_host: '${ip}'
            - account_service_host: '${ip}'
            - db_host: '${ip}'
            - username: '${username}'
            - password: '${password}'
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
        x: 86
        y: 88
      install_aos:
        x: 247
        y: 104
      deploy_wars:
        x: 381
        y: 104
        navigate:
          85994bc5-c076-1c46-c287-3342a88e6bff:
            targetId: cea6732a-877d-dc69-d2f7-f7c6ee42ac23
            port: SUCCESS
    results:
      SUCCESS:
        cea6732a-877d-dc69-d2f7-f7c6ee42ac23:
          x: 153
          y: 224
