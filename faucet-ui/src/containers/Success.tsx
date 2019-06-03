import { Box, Anchor, Text, TextInput } from 'grommet';
import * as React from 'react';
import { Routes } from '../utils/const';

export default (props: any) => {
  let txHash: string | undefined
  if (props.location.query) {
    txHash = props.location.query.txHash
  }
  if (txHash == undefined) {
    props.history.push({ pathname: Routes.Home })
  }

  const transactionDetails = () => {
    window.open("https://explorer.nervos.org/transaction/" + txHash)
  }

  return (
    <Box gap="small" align="center">
      <Text textAlign='start' weight="bold" color="text" size='xlarge'> Congratulations! </Text>
      <Text textAlign='start' weight="bold" color="text" size='xlarge'> You just got {process.env.REACT_APP_SEND_CAPACITY_COUNT} CKB Testnet tokens! </Text>
      <Box width="750px">
        <Box direction="row" pad={{ top: "medium", bottom: "small" }}>
          <Box width="200px">
            <Text color="text">Transaction Hash</Text>
          </Box>
          <Box width="100%" align="end">
            <Anchor onClick={transactionDetails}>See the Transaction on Explorer</Anchor>
          </Box>
        </Box>
        <Box justify="center" align="center" pad="none">
          <TextInput style={{ color: "black", textAlign: "center" }} readOnly width="100%" value={txHash} />
        </Box>
      </Box>
    </Box>
  )
}
