namespace: io.cloudslang.demo.aos
flow:
  name: deploy_vm_aos
  inputs:
    - username: root
    - password: admin@123
  workflow:
    - deploy_vm:
        do:
          io.cloudslang.demo.vmware.deploy_vm: []
        publish:
          - host: '${ip}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: install_aos
    - install_aos:
        do:
          demo.aos.install_aos:
            - username: '${username}'
            - password: '${password}'
            - tomcat_host: '${host}'
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
        x: 60
        y: 58
      install_aos:
        x: 224
        y: 53
        navigate:
          de99d59a-bc93-9e55-7f52-7015665f5762:
            targetId: cea6732a-877d-dc69-d2f7-f7c6ee42ac23
            port: SUCCESS
    results:
      SUCCESS:
        cea6732a-877d-dc69-d2f7-f7c6ee42ac23:
          x: 369
          y: 66
