import { Box, Button, Text, TextInput } from 'grommet';
import * as React from 'react';

export default (props: any) => {
  let txhash: string | undefined
  if (props.location.query) {
    txhash = props.location.query.txhash
  }

  return (
    <Box gap="small" align="center">
      <Box width="600px">
        <Box direction="row" pad={{bottom: "small"}}>
          <Box width="200px">
            <Text>Transaction Hash</Text> 
          </Box>
          <Box width="100%" align="end">
            <Button primary label="Copy" />
          </Box>
        </Box>
        <TextInput width="100%" value={txhash} />
        <Box width="100%" align="end" pad={{top: "large"}} gap="small">
          <Text size="14px">It may take some time for the transaction to be mined and confirmed.</Text>
          <Text size="16px">Check here for what to do next for developing on Nervos CKB -></Text>
        </Box>
      </Box>
    </Box>
  )
}
