namespace: io.cloudslang.demo.aos.test
flow:
  name: deploy_2_vm_aos
  inputs:
    - username: root
    - password: admin@123
  workflow:
    - deploy_2_vms:
        do:
          io.cloudslang.demo.vmware.deploy_2_vms: []
        publish:
          - db_host
          - tomcat_host
        navigate:
          - FAILURE: on_failure
          - SUCCESS: install_aos
    - install_aos:
        do:
          demo.aos.install_aos:
            - username: '${username}'
            - password: '${password}'
            - tomcat_host: '${tomcat_host}'
            - db_host: '${db_host}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      deploy_2_vms:
        x: 145
        y: 34
      install_aos:
        x: 296
        y: 34
        navigate:
          45e415d2-58ac-063c-52c7-68209f2db20f:
            targetId: cea6732a-877d-dc69-d2f7-f7c6ee42ac23
            port: SUCCESS
    results:
      SUCCESS:
        cea6732a-877d-dc69-d2f7-f7c6ee42ac23:
          x: 456
          y: 47
