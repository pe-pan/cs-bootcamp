namespace: Integrations.demo.aos.application
flow:
  name: install_hybrid_2_app
  inputs:
    - as_aws_ip:
        required: false
    - as_azure_ip:
        required: false
    - as_gcp_ip:
        required: false
    - as_vmware_ip:
        required: false
    - db_aws_ip:
        required: false
    - db_azure_ip:
        required: false
    - db_gcp_ip:
        required: false
    - db_vmware_ip:
        required: false
    - as_username
    - as_password:
        sensitive: true
    - db_username
    - db_password:
        sensitive: true
    - db_instance_arn:
        required: false
    - java_version: '8'
    - local_db: 'true'
  workflow:
    - which_as_provider:
        do:
          Integrations.demo.aos.tools.which_provider:
            - aws_ip: '${as_aws_ip}'
            - azure_ip: '${as_azure_ip}'
            - gcp_ip: '${as_gcp_ip}'
            - vmware_ip: '${as_vmware_ip}'
        publish:
          - as_ip: '${ip}'
          - as_provider: '${provider}'
        navigate:
          - SUCCESS: which_db_provider
          - FAILURE: on_failure
    - which_db_provider:
        do:
          Integrations.demo.aos.tools.which_provider:
            - aws_ip: '${db_aws_ip}'
            - azure_ip: '${db_azure_ip}'
            - gcp_ip: '${db_gcp_ip}'
            - vmware_ip: '${db_vmware_ip}'
        publish:
          - db_ip: '${ip}'
          - db_provider: '${provider}'
        navigate:
          - SUCCESS: is_aws_db_provider
          - FAILURE: on_failure
    - is_aws_db_provider:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(db_provider == 'aws')}"
        publish:
          - db_port: '5432'
        navigate:
          - 'TRUE': authorize_db_ingress
          - 'FALSE': is_java_8
    - authorize_db_ingress:
        do:
          Integrations.aws.cli.authorize_db_ingress:
            - instance_arn: '${db_instance_arn}'
            - ip_address: '${as_ip}'
        publish:
          - db_port
        navigate:
          - SUCCESS: is_java_8
          - FAILURE: on_failure
    - is_java_8:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(java_version == '8')}"
        navigate:
          - 'TRUE': downgrade_java
          - 'FALSE': is_local_db
    - downgrade_java:
        do:
          io.cloudslang.demo.aos.sub_flows.initialize_artifact:
            - host: '${as_ip}'
            - username: '${as_username}'
            - password: '${as_password}'
            - script_url: "${get_sp('script_downgrade_java')}"
        navigate:
          - SUCCESS: is_local_db
          - FAILURE: on_failure
    - is_local_db:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${local_db}'
        navigate:
          - 'TRUE': install_postgres
          - 'FALSE': install_aos_application
    - install_postgres:
        do:
          io.cloudslang.demo.aos.sub_flows.initialize_artifact:
            - host: '${as_ip}'
            - username: '${as_username}'
            - password: '${as_password}'
            - script_url: "${get_sp('script_install_postgres')}"
        publish:
          - db_username: postgres
          - db_password: admin
          - db_host: '${host}'
          - db_port: '5432'
        navigate:
          - SUCCESS: install_aos_application
          - FAILURE: on_failure
    - install_aos_application:
        do:
          Integrations.demo.aos.application.install_aos_application:
            - username: '${as_username}'
            - password:
                value: '${as_password}'
                sensitive: true
            - tomcat_host: '${as_ip}'
            - db_username: '${db_username}'
            - db_password:
                value: '${db_password}'
                sensitive: true
            - db_host: '${db_ip}'
            - db_port: '${db_port}'
            - deploy_admin: "${str(java_version == '11')}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - as_ip: '${as_ip}'
    - db_ip: '${db_ip}'
    - as_provider: '${as_provider}'
    - db_provider: '${db_provider}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      is_local_db:
        x: 440
        'y': 283
      authorize_db_ingress:
        x: 35
        'y': 466
      downgrade_java:
        x: 237
        'y': 467
      which_db_provider:
        x: 208
        'y': 81
      is_java_8:
        x: 239
        'y': 283
      install_aos_application:
        x: 654
        'y': 284
        navigate:
          25811a24-f53e-66ce-d2a0-b74349bc4dae:
            targetId: 469c3346-67f8-8140-306a-4a2881899277
            port: SUCCESS
      is_aws_db_provider:
        x: 39
        'y': 285
      which_as_provider:
        x: 41
        'y': 85
      install_postgres:
        x: 442
        'y': 464
    results:
      SUCCESS:
        469c3346-67f8-8140-306a-4a2881899277:
          x: 654
          'y': 467
