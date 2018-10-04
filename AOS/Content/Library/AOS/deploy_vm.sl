namespace: AOS
flow:
  name: deploy_vm
  workflow:
    - unique_vm_name_generator:
        do:
          io.cloudslang.vmware.vcenter.util.unique_vm_name_generator:
            - vm_name_prefix: petr-
        publish:
          - vm_name
        navigate:
          - SUCCESS: clone_vm
          - FAILURE: on_failure
    - clone_vm:
        do:
          io.cloudslang.vmware.vcenter.vm.clone_vm:
            - host: 10.0.46.10
            - user: "capa1\\1010-capa1user"
            - password:
                value: Automation123
                sensitive: true
            - vm_source_identifier: name
            - vm_source: Ubuntu
            - datacenter: CAPA1 Datacenter
            - vm_name: '${vm_name}'
            - vm_folder: AOS
            - mark_as_template: 'false'
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
        navigate:
          - SUCCESS: power_on_vm
          - FAILURE: on_failure
    - power_on_vm:
        do:
          io.cloudslang.vmware.vcenter.power_on_vm:
            - host: 10.0.46.10
            - user: "CAPA1\\1010-capa1user"
            - password:
                value: Automation123
                sensitive: true
            - vm_identifier: name
            - vm_name: '${vm_name}'
            - datacenter: CAPA1 Datacenter
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
        navigate:
          - SUCCESS: wait_for_vm_info
          - FAILURE: on_failure
    - wait_for_vm_info:
        do:
          io.cloudslang.vmware.vcenter.util.wait_for_vm_info:
            - host: 10.0.46.10
            - user: "CAPA1\\1010-capa1user"
            - password:
                value: Automation123
                sensitive: true
            - vm_identifier: name
            - vm_name: '${vm_name}'
            - datacenter: CAPA1 Datacenter
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
        publish:
          - ip
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - vm_name: '${vm_name}'
    - ip: '${ip}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      unique_vm_name_generator:
        x: 108
        y: 109
      clone_vm:
        x: 279
        y: 106
      power_on_vm:
        x: 112
        y: 285
      wait_for_vm_info:
        x: 277
        y: 284
        navigate:
          5afc682a-f819-1ec8-e96e-b6a00ef57aca:
            targetId: 768a3e24-15d0-1251-db01-f43d031a74f4
            port: SUCCESS
    results:
      SUCCESS:
        768a3e24-15d0-1251-db01-f43d031a74f4:
          x: 393
          y: 185
