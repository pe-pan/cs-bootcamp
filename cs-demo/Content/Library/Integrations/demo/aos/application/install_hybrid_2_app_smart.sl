########################################################################################################################
#!!
#! @input instance_id: Service instance ID
#! @input properties_mapping: Mapping where to take IP addresses from; one of the component will have the IP filled-in
#!
#! @output db_instance_arn: Given only if db_provider is AWS
#!!#
########################################################################################################################
namespace: Integrations.demo.aos.application
flow:
  name: install_hybrid_2_app_smart
  inputs:
    - instance_id
    - properties_mapping: 'as#azure#Microsoft Azure Server Template 18.4.1#primary_ip_address|as#aws#Amazon Server Template 18.3.0#primary_ip_address|db#azure#Microsoft Azure Server Template 18.4.1 - Postgres#primary_ip_address|db#aws#Amazon RDS Template 1.4.0#cloud_resource_identifier'
    - as_username
    - as_password:
        sensitive: true
    - db_username
    - db_password:
        sensitive: true
    - java_version: '8'
    - local_db: 'true'
  workflow:
    - get_component_property_value:
        do:
          Integrations.microfocus.smax.get_component_property_value:
            - instance_id: '${instance_id}'
            - properties_mapping: '${properties_mapping}'
            - component_names_properties: '${component_names_properties}'
            - as_username: '${as_username}'
            - as_password: '${as_password}'
        publish:
          - db_ip
          - as_ip
          - db_provider
          - as_provider
          - as_username: "${'centos' if as_provider == 'aws' else as_username}"
          - as_password: "${None if as_provider == 'aws' else as_password}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: is_aws_db_provider
    - is_aws_db_provider:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(db_provider == 'aws')}"
        publish:
          - db_port: '5432'
          - db_instance_arn: ''
        navigate:
          - 'TRUE': get_db_endpoint
          - 'FALSE': is_java_8
    - is_java_8:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(java_version == '8')}"
        navigate:
          - 'TRUE': downgrade_java
          - 'FALSE': is_azure_db_provider
    - downgrade_java:
        do:
          io.cloudslang.demo.aos.sub_flows.initialize_artifact:
            - host: '${as_ip}'
            - username: '${as_username}'
            - password: '${as_password}'
            - script_url: "${get_sp('script_downgrade_java')}"
        navigate:
          - SUCCESS: is_azure_db_provider
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
            - parameters: "${'%s %s' % (db_username, db_password)}"
        publish:
          - db_host: localhost
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
            - db_host: '${db_host}'
            - db_port: '${db_port}'
            - deploy_admin: "${str(java_version == '11')}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - is_azure_db_provider:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(db_provider == 'azure')}"
        publish:
          - db_port: '5432'
        navigate:
          - 'TRUE': configure_azure_db
          - 'FALSE': is_local_db
    - configure_azure_db:
        do:
          io.cloudslang.demo.aos.sub_flows.initialize_artifact:
            - host: '${db_ip}'
            - username: '${db_username}'
            - password: '${db_password}'
            - script_url: "${get_sp('script_configure_azure_postgres')}"
            - parameters: "${'%s %s' % (db_username, db_password)}"
        publish:
          - db_host: '${host}'
          - db_port: '5432'
        navigate:
          - SUCCESS: is_local_db
          - FAILURE: on_failure
    - get_db_endpoint:
        do:
          Integrations.aws.get_db_endpoint:
            - instance_arn: '${db_ip}'
        publish:
          - db_host: '${endpoint_host}'
          - db_port: '${endpoint_port}'
          - db_instance_arn: '${instance_arn}'
          - db_ip: '${endpoint_host}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: authorize_db_ingress
    - authorize_db_ingress:
        do:
          Integrations.aws.authorize_db_ingress:
            - instance_arn: '${db_instance_arn}'
            - source_ip: '${as_ip}'
        publish:
          - db_port
        navigate:
          - FAILURE: on_failure
          - SUCCESS: is_java_8
  outputs:
    - as_ip: '${as_ip}'
    - db_ip: '${db_ip}'
    - as_provider: '${as_provider}'
    - db_provider: '${db_provider}'
    - db_instance_arn: '${db_instance_arn}'
    - app_url: "${'http://%s:8080/#/' % as_ip}"
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      is_local_db:
        x: 588
        'y': 284
      configure_azure_db:
        x: 401
        'y': 472
      authorize_db_ingress:
        x: 43
        'y': 630
      downgrade_java:
        x: 216
        'y': 467
      get_db_endpoint:
        x: 42
        'y': 451
      is_azure_db_provider:
        x: 402
        'y': 285
      is_java_8:
        x: 218
        'y': 283
      get_component_property_value:
        x: 42
        'y': 77
      install_aos_application:
        x: 780
        'y': 281
        navigate:
          25811a24-f53e-66ce-d2a0-b74349bc4dae:
            targetId: 469c3346-67f8-8140-306a-4a2881899277
            port: SUCCESS
      is_aws_db_provider:
        x: 37
        'y': 285
      install_postgres:
        x: 591
        'y': 471
    results:
      SUCCESS:
        469c3346-67f8-8140-306a-4a2881899277:
          x: 777
          'y': 112
