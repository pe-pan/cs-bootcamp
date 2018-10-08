namespace: io.cloudslang.demo.aos.tools
flow:
  name: delete_file
  inputs:
    - host: 10.0.46.20
    - username: root
    - password: admin@123
    - filename: install_tomcat.sh
  workflow:
    - delete_file:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && rm -f '+filename}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      delete_file:
        x: 89
        y: 89
        navigate:
          3da31db5-f2f0-fc89-9797-3f3a7cf79852:
            targetId: 1a4b4e41-715c-4454-4553-8668c9592a94
            port: SUCCESS
    results:
      SUCCESS:
        1a4b4e41-715c-4454-4553-8668c9592a94:
          x: 276
          y: 100
