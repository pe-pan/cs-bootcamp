namespace: AOS
flow:
  name: test
  workflow:
    - extract_filename:
        do:
          io.cloudslang.demo.extract_filename:
            - url: 'http://172.16.239.52:36980/job/AOS/lastSuccessfulBuild/artifact/accountservice/target/accountservice.war'
        publish:
          - filename
        navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      extract_filename:
        x: 213
        y: 193
        navigate:
          bdd9a1dd-f4f9-7a08-43cb-e832c4331502:
            targetId: e0a8df8c-3ff2-133b-cf0c-250d597a2398
            port: SUCCESS
    results:
      SUCCESS:
        e0a8df8c-3ff2-133b-cf0c-250d597a2398:
          x: 346
          y: 204
