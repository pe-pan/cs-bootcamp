namespace: demo.aos
flow:
  name: install_aos
  inputs:
    - host: 10.0.46.54
    - username: root
    - password: admin@123
  workflow:
    - install_java:
        do:
          demo.aos.initialize_artifact:
            - host: '${host}'
            - username: '${username}'
            - password: '${password}'
            - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_java.sh'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: install_tomcat
    - install_tomcat:
        do:
          demo.aos.initialize_artifact:
            - host: '${host}'
            - username: '${username}'
            - password: '${password}'
            - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_tomcat.sh'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: install_postgres
    - install_postgres:
        do:
          demo.aos.initialize_artifact:
            - host: '${host}'
            - username: '${username}'
            - password: '${password}'
            - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_postgres.sh'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      install_java:
        x: 150
        y: 82
      install_tomcat:
        x: 299
        y: 109
      install_postgres:
        x: 469
        y: 146
        navigate:
          6c873fc9-f3c1-5439-f8dd-d931a59f7e1d:
            targetId: 768a3e24-15d0-1251-db01-f43d031a74f4
            port: SUCCESS
    results:
      SUCCESS:
        768a3e24-15d0-1251-db01-f43d031a74f4:
          x: 472
          y: 413
