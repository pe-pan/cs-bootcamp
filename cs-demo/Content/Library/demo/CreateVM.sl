namespace: demo
flow:
  name: CreateVM
  workflow:
    - uuid:
        do:
          io.cloudslang.demo.uuid: []
        publish:
          - uuid: '${"petr-"+uuid}'
        navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      uuid:
        x: 172
        y: 101
        navigate:
          358314a9-4398-84ad-76b3-b1a63992ea8c:
            targetId: 18c81420-0c63-41f7-5759-480739e08d92
            port: SUCCESS
    results:
      SUCCESS:
        18c81420-0c63-41f7-5759-480739e08d92:
          x: 539
          y: 156
