import { Box, Button, Text } from 'grommet';
import * as React from 'react';

export default (props: any) => {
  let txhash: string | undefined
  if (props.location.query) {
    txhash = props.location.query.txhash
  }

  return (
    <Box gap="small" align="center">
      <Box width="600px">
        <Box direction="row" pad={{ bottom: "small" }}>
          <Box width="200px">
            <Text color="text">Transaction Hash</Text>
          </Box>
          <Box width="100%" align="end">
            <Button primary label="Copy" />
          </Box>
        </Box>
        <Box justify="center" align="center" pad="small" round="large" border={{ "color" : "white" }}>
            <Text color='white'>{txhash}</Text>
        </Box>
        <Box width="100%" align="end" pad={{ top: "medium" }} gap="small">
          <Text color="text" size="14px">It may take some time for the transaction to be mined and confirmed</Text>
        </Box>
      </Box>
    </Box>
  )
}
