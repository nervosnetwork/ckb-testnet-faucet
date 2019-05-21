import { Box, Button, Text, TextInput } from 'grommet';
import * as React from 'react';
import copy from 'copy-to-clipboard';

export default (props: any) => {
  let txHash: string | undefined
  if (props.location.query) {
    txHash = props.location.query.txHash
  }
  const [copyResult, setCopyResult] = React.useState(false)

  const copyTxHash = () => {
    if (txHash != undefined) {
      if (copy(txHash)) {
        setCopyResult(true)
      } else {
        setCopyResult(false)
      }
    }
  }

  return (
    <Box gap="small" align="center">
      <Box width="600px">
        <Box direction="row" pad={{ bottom: "small" }}>
          <Box width="200px">
            <Text color="text">Transaction Hash</Text>
          </Box>
          <Box width="100%" align="end">
            <Button primary onClick={copyTxHash} label={copyResult ? "Copied" : "Copy"} />
          </Box>
        </Box>
        <Box justify="center" align="center" pad="none">
          <TextInput style={{ color: "black" }} readOnly width="100%" value={txHash} />
        </Box>
        <Box width="100%" align="end" pad={{ top: "medium" }} gap="small">
          <Text color="text" size="14px">It may take some time for the transaction to be mined and confirmed</Text>
        </Box>
      </Box>
    </Box>
  )
}
