namespace: Integrations.demo.aos.application
flow:
  name: authorize_ingress_install_aos
  inputs:
    - tomcat_ip_address
    - tomcat_username
    - tomcat_password:
        sensitive: true
    - db_instance_arn
    - db_username
    - db_password:
        sensitive: true
    - deploy_admin: 'true'
  workflow:
    - authorize_db_ingress:
        do:
          Integrations.aws.cli.authorize_db_ingress:
            - instance_arn: '${db_instance_arn}'
            - ip_address: '${tomcat_ip_address}'
        publish:
          - db_host
          - db_port
        navigate:
          - SUCCESS: is_java_11
          - FAILURE: on_failure
    - install_aos_application:
        do:
          Integrations.demo.aos.application.install_aos_application:
            - username: '${tomcat_username}'
            - password: '${tomcat_password}'
            - tomcat_host: '${tomcat_ip_address}'
            - db_username: '${db_username}'
            - db_password:
                value: '${db_password}'
                sensitive: true
            - db_host: '${db_host}'
            - db_port: '${db_port}'
            - deploy_admin: '${deploy_admin}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - downgrade_java:
        do:
          io.cloudslang.demo.aos.sub_flows.initialize_artifact:
            - host: '${tomcat_ip_address}'
            - username: '${tomcat_username}'
            - password: '${tomcat_password}'
            - script_url: "${get_sp('script_downgrade_java')}"
        navigate:
          - SUCCESS: install_aos_application
          - FAILURE: on_failure
    - is_java_11:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${deploy_admin}'
        navigate:
          - 'TRUE': install_aos_application
          - 'FALSE': downgrade_java
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      authorize_db_ingress:
        x: 58
        'y': 121
      install_aos_application:
        x: 329
        'y': 349
        navigate:
          98a1c69a-1f8b-b3e6-994d-13a4f1dcf323:
            targetId: a24c38c3-0f7e-3e44-c236-425f69b39075
            port: SUCCESS
      downgrade_java:
        x: 62
        'y': 349
      is_java_11:
        x: 327
        'y': 123
    results:
      SUCCESS:
        a24c38c3-0f7e-3e44-c236-425f69b39075:
          x: 537
          'y': 349
