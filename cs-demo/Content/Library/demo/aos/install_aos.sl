namespace: io.cloudslang.demo.aos
flow:
  name: install_aos
  inputs:
    - username: root
    - password: admin@123
    - tomcat_host: 10.0.46.29
    - account_service_host:
        required: false
    - db_host:
        required: false
  workflow:
    - install_postgres:
        do:
          io.cloudslang.demo.aos.sub_flows.initialize_artifact:
            - host: "${get('db_host', tomcat_host)}"
            - username: '${username}'
            - password: '${password}'
            - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_postgres.sh'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: install_java
    - install_java:
        do:
          io.cloudslang.demo.aos.sub_flows.initialize_artifact:
            - host: '${tomcat_host}'
            - username: '${username}'
            - password: '${password}'
            - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_java.sh'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: install_tomcat
    - install_tomcat:
        do:
          io.cloudslang.demo.aos.sub_flows.initialize_artifact:
            - host: '${tomcat_host}'
            - username: '${username}'
            - password: '${password}'
            - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_tomcat.sh'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: as_host_given
    - as_host_given:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(get('account_service_host', tomcat_host) != tomcat_host)}"
        navigate:
          - 'TRUE': install_java_as
          - 'FALSE': deploy_wars
    - install_java_as:
        do:
          io.cloudslang.demo.aos.sub_flows.initialize_artifact:
            - host: '${account_service_host}'
            - username: '${username}'
            - password: '${password}'
            - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_java.sh'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: install_tomcat_as
    - install_tomcat_as:
        do:
          io.cloudslang.demo.aos.sub_flows.initialize_artifact:
            - host: '${account_service_host}'
            - username: '${username}'
            - password: '${password}'
            - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_tomcat.sh'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: deploy_wars
    - deploy_wars:
        do:
          io.cloudslang.demo.aos.sub_flows.deploy_wars:
            - tomcat_host: '${tomcat_host}'
            - account_service_host: "${get('acccount_service_host',tomcat_host)}"
            - db_host: "${get('db_host', tomcat_host)}"
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
      install_postgres:
        x: 35
        y: 75
      install_java:
        x: 191
        y: 77
      install_tomcat:
        x: 374
        y: 78
      as_host_given:
        x: 237
        y: 212
      install_java_as:
        x: 42
        y: 342
      install_tomcat_as:
        x: 189
        y: 351
      deploy_wars:
        x: 393
        y: 354
        navigate:
          8d48cf49-b8e3-8b3d-2054-a44f2582efc2:
            targetId: cea6732a-877d-dc69-d2f7-f7c6ee42ac23
            port: SUCCESS
    results:
      SUCCESS:
        cea6732a-877d-dc69-d2f7-f7c6ee42ac23:
          x: 391
          y: 219
