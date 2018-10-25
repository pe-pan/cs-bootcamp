namespace: io.cloudslang.demo.aos.test
flow:
  name: deploy_1_vm_aos
  inputs:
    - username: "${get_sp('vm_username')}"
    - password: "${get_sp('vm_password')}"
  workflow:
    - deploy_vm:
        do:
          io.cloudslang.demo.vmware.deploy_vm: []
        publish:
          - tomcat_host: '${ip}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: install_aos
    - install_aos:
        do:
          io.cloudslang.demo.aos.install_aos:
            - username: '${username}'
            - password: '${password}'
            - tomcat_host: '${tomcat_host}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - tomcat_host: '${tomcat_host}'
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
