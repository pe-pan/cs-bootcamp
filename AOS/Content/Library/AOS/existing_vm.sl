namespace: AOS
flow:
  name: existing_vm
  inputs:
    - host: 10.0.46.50
    - username: root
    - password: admin@123
  workflow:
    - install_postgres:
        do:
          AOS.run_remote_script:
            - host: '${host}'
            - url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_postgres.sh'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: install_java
    - install_java:
        do:
          AOS.run_remote_script:
            - host: '${host}'
            - url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_java.sh'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: install_tomcat
    - install_tomcat:
        do:
          AOS.run_remote_script:
            - host: '${host}'
            - url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_tomcat.sh'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      install_java:
        x: 149
        y: 186
      install_tomcat:
        x: 379
        y: 222
        navigate:
          1bb02e95-d8fb-d1d0-a6e7-3dba94348a1f:
            targetId: 768a3e24-15d0-1251-db01-f43d031a74f4
            port: SUCCESS
      install_postgres:
        x: 232
        y: 36
    results:
      SUCCESS:
        768a3e24-15d0-1251-db01-f43d031a74f4:
          x: 472
          y: 413
