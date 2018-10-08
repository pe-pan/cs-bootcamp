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
      install_java:
        x: 132
        y: 153
      install_tomcat:
        x: 367
        y: 150
      install_java_as:
        x: 96
        y: 282
      install_tomcat_as:
        x: 246
        y: 278
      install_postgres:
        x: 363
        y: 26
      deploy_wars:
        x: 387
        y: 282
        navigate:
          8d48cf49-b8e3-8b3d-2054-a44f2582efc2:
            targetId: cea6732a-877d-dc69-d2f7-f7c6ee42ac23
            port: SUCCESS
    results:
      SUCCESS:
        cea6732a-877d-dc69-d2f7-f7c6ee42ac23:
          x: 489
          y: 161
