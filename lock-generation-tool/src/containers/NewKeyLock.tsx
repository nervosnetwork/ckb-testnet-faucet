import React, { useEffect, useState } from 'react'
import { Box, Text, TextInput } from 'grommet'
import { APIHost, Routes } from '../utils/const';

export default (props: any) => {
  const [privateKey, setPrivateKey] = useState("")
  const [address, setAddress] = useState("")

  useEffect(() => {
    fetch(`${APIHost}/ckb/address/random`).then((response) => {
      return response.json()
    }).then((json) => {
      setPrivateKey(json.privateKey)
      setAddress(json.address)
    }).catch(() => {
      props.history.replace({ pathname: Routes.Error })
    })
  }, [])

  return (
    <Box width="100%" align="center" gap="small" pad="medium">
      <Text color="text" size="18px">Please remember the information below, you will not see them again.</Text>
      <Text color="text" size="18px">Check here for info about how to use them.</Text>
      <Box width="600px" align="center" pad="medium">
        <Text color="text" size="20px" alignSelf="start" weight="bold">Lock Hash</Text>
        <TextInput style={{ color: "white" }} readOnly width="100%" value={address} />
      </Box>
      <Box width="600px" align="center" pad="medium">
        <Text color="text" size="20px" alignSelf="start" weight="bold">Private Key</Text>
        <TextInput style={{ color: "white" }} readOnly width="100%" value={privateKey} />
      </Box>
    </Box>
  )
}

