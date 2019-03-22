import { Box, Text, TextInput, Button } from 'grommet'
import * as React from 'react'
import copy from 'copy-to-clipboard'
import bitcoin_unlock_hash from '../utils/bitcoin_unlock_hash'
import ECPair from '@nervosnetwork/ckb-sdk-utils/lib/ecpair';
import { hexToBytes, jsonScriptToTypeHash } from '../utils/utils'

export default (props: any) => {
  const [copyMsg, setCopyMsg] = React.useState(String)
  let privateKey: String | undefined
  if (props.location.query) {
    privateKey = props.location.query.privateKey
  }
  const pair = new ECPair(new Buffer(hexToBytes(privateKey)))
  const script = {
    reference: "0x2165b10c4f6c55302158a17049b9dad4fef0acaf1065c63c02ddeccbce97ac47",
    binary: undefined,
    signedArgs: [hexToBytes(bitcoin_unlock_hash), pair.publicKey]
  }
  const address = jsonScriptToTypeHash(script)

  const onClickCopy = () => {
    if (copy(address as string)) {
      setCopyMsg("Copy success")
    } else {
      setCopyMsg("Copy failed")
    }
  }

  return(
    <Box width="100%" align="center" gap="small">
      <Text color="text" size="18px">Check here for more info about how to use this lock hash.</Text>
      <Box width="600px" pad="large" gap="large">
        <TextInput style={{color:"white"}} readOnly width="100%" value={address as string}/>
        <Text  alignSelf="center" color="brand">{copyMsg}</Text>
        <Button primary alignSelf="center" label="Copy" onClick={onClickCopy}/>
      </Box>
    </Box>
  ) 
}
