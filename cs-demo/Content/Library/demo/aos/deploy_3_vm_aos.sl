namespace: demo.aos
flow:
  name: deploy_3_vm_aos
  inputs:
    - username: root
    - password: admin@123
  workflow:
    - deploy_3_vms:
        do:
          demo.VMware.deploy_3_vms: []
        publish:
          - db_host
          - tomcat_host
          - account_service_host
        navigate:
          - FAILURE: on_failure
          - SUCCESS: install_postgres
    - install_java:
        do:
          demo.aos.initialize_artifact:
            - host: '${tomcat_host}'
            - username: '${username}'
            - password: '${password}'
            - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_java.sh'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: install_tomcat
    - install_tomcat:
        do:
          demo.aos.initialize_artifact:
            - host: '${tomcat_host}'
            - username: '${username}'
            - password: '${password}'
            - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_tomcat.sh'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: install_java_as
    - install_java_as:
        do:
          demo.aos.initialize_artifact:
            - host: '${account_service_host}'
            - username: '${username}'
            - password: '${password}'
            - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_java.sh'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: install_tomcat_as
    - install_tomcat_as:
        do:
          demo.aos.initialize_artifact:
            - host: '${account_service_host}'
            - username: '${username}'
            - password: '${password}'
            - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_tomcat.sh'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: deploy_wars
    - install_postgres:
        do:
          demo.aos.initialize_artifact:
            - host: '${db_host}'
            - username: '${username}'
            - password: '${password}'
            - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_postgres.sh'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: install_java
    - deploy_wars:
        do:
          demo.aos.deploy_wars:
            - tomcat_host: '${tomcat_host}'
            - account_service_host: '${account_service_host}'
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
      deploy_3_vms:
        x: 59
        y: 75
      install_java:
        x: 105
        y: 187
      install_tomcat:
        x: 360
        y: 159
      deploy_wars:
        x: 435
        y: 307
        navigate:
          8d48cf49-b8e3-8b3d-2054-a44f2582efc2:
            targetId: cea6732a-877d-dc69-d2f7-f7c6ee42ac23
            port: SUCCESS
      install_java_as:
        x: 91
        y: 320
      install_postgres:
        x: 364
        y: 28
      install_tomcat_as:
        x: 282
        y: 314
    results:
      SUCCESS:
        cea6732a-877d-dc69-d2f7-f7c6ee42ac23:
          x: 487
          y: 185
