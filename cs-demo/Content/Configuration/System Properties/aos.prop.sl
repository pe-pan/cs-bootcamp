namespace: ''
properties:
  - script_location: /tmp
  - vcenter_host: 172.16.239.19
  - vcenter_user: "vsphere.local\\\\administrator"
  - vcenter_password:
      value: Cloudywind@1234
      sensitive: false
  - vcenter_image: linux-template
  - vcenter_datacenter: CAPA1 Datacenter
  - vcenter_folder: AOS
  - vm_username: ''
  - vm_password:
      value: ''
      sensitive: false
  - script_deploy_war: 'http://httpserver.dca.swdemos.net:6500/aos/scripts/deploy_war.sh'
  - script_install_java: 'http://jenkins.hcmx.local:8080/job/AOS-repo/ws/install_java.sh'
  - script_install_postgres: 'http://jenkins.hcmx.local:8080/job/AOS-repo/ws/install_postgres.sh'
  - script_install_tomcat: 'http://jenkins.hcmx.local:8080/job/AOS-repo/ws/install_tomcat.sh'
  - war_repo_root_url: 'http://httpserver.dca.swdemos.net:6500/aos/artifact/'
  - script_retries: '5'
  - script_downgrade_java: 'http://httpserver.dca.swdemos.net:6500/aos/scripts/downgrade_java_to_8.sh'
