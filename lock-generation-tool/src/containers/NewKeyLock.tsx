import React from 'react'
import { Box, Text, TextInput } from 'grommet'
import * as ECPair from '@nervosnetwork/ckb-sdk-utils/lib/ecpair'
import { bytesToHex, hexToBytes, jsonScriptToTypeHash } from '@nervosnetwork/ckb-sdk-utils'
import bitcoin_unlock_hash from '../utils/bitcoin_unlock_hash'

export default () => {
  const pair = ECPair.makeRandom()
  const privateKey = bytesToHex(pair.privateKey)

  const script = {
    reference: "0x2165b10c4f6c55302158a17049b9dad4fef0acaf1065c63c02ddeccbce97ac47",
    binary: undefined,
    signedArgs: [hexToBytes(bitcoin_unlock_hash), pair.publicKey]
  }

  const address = jsonScriptToTypeHash(script) as String

  return(
    <Box width="100%" align="center" gap="small" pad="medium">
        <Text size="18px">Please remember the information below, you will not see them again.</Text>
        <Text size="18px">Check here for info about how to use them.</Text>
        <Box width="600px" align="center" pad="medium">
          <Text size="20px" alignSelf="start" weight="bold">Lock Hash</Text>
          <TextInput readOnly width="100%" value={address as string}/>
        </Box>
        <Box width="600px" align="center" pad="medium">
          <Text size="20px" alignSelf="start" weight="bold">Private Key</Text>
          <TextInput readOnly width="100%" value={privateKey}/>
        </Box>
    </Box>
  )
}

