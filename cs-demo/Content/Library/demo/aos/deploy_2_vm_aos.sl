namespace: io.cloudslang.demo.aos
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
          - SUCCESS: install_postgres
    - install_java:
        do:
          io.cloudslang.demo.aos.initialize_artifact:
            - host: '${tomcat_host}'
            - username: '${username}'
            - password: '${password}'
            - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_java.sh'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: install_tomcat
    - install_tomcat:
        do:
          io.cloudslang.demo.aos.initialize_artifact:
            - host: '${tomcat_host}'
            - username: '${username}'
            - password: '${password}'
            - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_tomcat.sh'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: deploy_wars
    - install_postgres:
        do:
          io.cloudslang.demo.aos.initialize_artifact:
            - host: '${db_host}'
            - username: '${username}'
            - password: '${password}'
            - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_postgres.sh'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: install_java
    - deploy_wars:
        do:
          io.cloudslang.demo.aos.deploy_wars:
            - tomcat_host: '${tomcat_host}'
            - account_service_host: '${tomcat_host}'
            - db_host: '${db_host}'
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
      deploy_2_vms:
        x: 145
        y: 34
      install_java:
        x: 143
        y: 161
      install_tomcat:
        x: 360
        y: 159
      install_postgres:
        x: 364
        y: 28
      deploy_wars:
        x: 144
        y: 290
        navigate:
          8d48cf49-b8e3-8b3d-2054-a44f2582efc2:
            targetId: cea6732a-877d-dc69-d2f7-f7c6ee42ac23
            port: SUCCESS
    results:
      SUCCESS:
        cea6732a-877d-dc69-d2f7-f7c6ee42ac23:
          x: 371
          y: 295
