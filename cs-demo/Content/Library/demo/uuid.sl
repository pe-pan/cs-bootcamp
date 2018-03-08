########################################################################################################################
#!!
#! @description: Generates random id
#!
#! @output uuid: generated id
#! @result SUCCESS: Operation always completes successfully
#!!#
########################################################################################################################

namespace: io.cloudslang.demo

operation:
    name: uuid

    python_action:
      script: |
        import uuid
        new_uuid = str(uuid.uuid1())

    outputs:
      - uuid: ${uuid}

    results:
      - SUCCESS