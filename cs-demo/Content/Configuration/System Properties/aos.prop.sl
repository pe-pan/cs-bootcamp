namespace: ''
properties:
  - script_location: /tmp
  - vcenter_host: 10.3.61.10
  - vcenter_user: hcm
  - vcenter_password:
      value: Police123
      sensitive: true
  - vcenter_image: RHEL7_linked
  - vcenter_datacenter: HIT_Provisioning
  - vcenter_folder: AOS
  - vm_username: root
  - vm_password:
      value: linux1
      sensitive: true
  - script_deploy_war: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/deploy_war.sh'
  - script_install_java: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_java.sh'
  - script_install_postgres: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_postgres.sh'
  - script_install_tomcat: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_tomcat.sh'
  - war_repo_root_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS/lastSuccessfulBuild/artifact/'
