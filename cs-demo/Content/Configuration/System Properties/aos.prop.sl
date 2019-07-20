namespace: ''
properties:
  - script_location: /tmp
  - vcenter_host: 10.0.46.10
  - vcenter_user: "CAPA1\\\\1010-capa1user"
  - vcenter_password:
      value: Automation123
      sensitive: false
  - vcenter_image: linux-template
  - vcenter_datacenter: CAPA1 Datacenter
  - vcenter_folder: AOS
  - vm_username: root
  - vm_password:
      value: Automation123
      sensitive: false
  - script_deploy_war: 'http://10.0.46.32:8000/scripts/deploy_war.sh'
  - script_install_java: 'http://10.0.46.32:8000/scripts/install_java.sh'
  - script_install_postgres: 'http://10.0.46.32:8000/scripts/install_postgres.sh'
  - script_install_tomcat: 'http://10.0.46.32:8000/scripts/install_tomcat.sh'
  - war_repo_root_url: 'http://10.0.46.32:8000/archive/'
  - script_retries: '5'
