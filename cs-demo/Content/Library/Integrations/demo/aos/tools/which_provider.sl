########################################################################################################################
#!!
#! @description: Out of one of the given IP addresses it realizes which one is given.
#!
#! @output ip: The extracted filename;
#!
#! @result SUCCESS: Operation completed successfully.
#!!#
########################################################################################################################

namespace: Integrations.demo.aos.tools
operation:
  name: which_provider
  inputs:
    - aws_ip:
        required: false
    - azure_ip:
        required: false
    - gcp_ip:
        required: false
    - vmware_ip:
        required: false
  python_action:
    script: |-
      ip = ''
      provider = ''
      failure = ''
      if aws_ip is not None:
          ip = aws_ip
          provider = 'aws'
      elif azure_ip is not None:
          ip = azure_ip
          provider = 'azure'
      elif gcp_ip is not None:
          ip = gcp_ip
          provider = 'gcp'
      elif vmware_ip is not None:
          ip = vmware_ip
          provider = 'vmware'
      else:
          failure = 'No IP given'
  outputs:
    - ip
    - provider
    - failure
  results:
    - SUCCESS: '${len(failure)==0}'
    - FAILURE
