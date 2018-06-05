########################################################################################################################
#!!
#! @description: Generated Python operation description.
#!
#! @input input_1: Generated description
#! @input input_2: Generated description
#!
#! @output output_1: Generated description
#!
#! @result SUCCESS: Operation completed successfully.
#! @result FAILURE: Failure occurred during execution.
#!!#
########################################################################################################################

namespace: io.cloudslang.demo

operation:
  name: uuid

  python_action:
    script: |
      import uuid
      uuid = str(uuid.uuid1())

  outputs:
    - uuid: ${uuid}

  results:
    - SUCCESS
