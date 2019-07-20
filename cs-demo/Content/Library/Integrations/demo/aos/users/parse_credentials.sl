namespace: Integrations.demo.aos.users
operation:
  name: parse_credentials
  inputs:
    - credentials
    - delimiter:
        required: false
        default: =
  python_action:
    script: |-
      array = credentials.split(delimiter);
      name = array[0];
      password = array[1];
  outputs:
    - name
    - password
  results:
    - SUCCESS
