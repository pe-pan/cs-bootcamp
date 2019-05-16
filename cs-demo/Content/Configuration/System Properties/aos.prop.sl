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
  - script_deploy_war: 'http://uftserv.helion1.hpintelco.org:7070/job/AOS-repo/ws/deploy_war.sh'
  - script_install_java: 'http://uftserv.helion1.hpintelco.org:7070/job/AOS-repo/ws/install_java.sh'
  - script_install_postgres: 'http://uftserv.helion1.hpintelco.org:7070/job/AOS-repo/ws/install_postgres.sh'
  - script_install_tomcat: 'http://uftserv.helion1.hpintelco.org:7070/job/AOS-repo/ws/install_tomcat.sh'
  - war_repo_root_url: 'http://uftserv.helion1.hpintelco.org:7070/job/AOS/lastSuccessfulBuild/artifact/'
  - script_retries: '5'
