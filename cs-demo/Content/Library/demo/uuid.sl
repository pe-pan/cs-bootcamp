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
        import string
        from random import *
        characters = string.ascii_letters + string.punctuation  + string.digits
        uuid =  "".join(choice(characters) for x in range(randint(8, 16)))

    outputs:
      - uuid: ${uuid}

    results:
      - SUCCESS