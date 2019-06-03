import { Box, Text, TextInput, Button } from 'grommet'
import React, { useEffect, useState } from 'react'
import copy from 'copy-to-clipboard'

export default (props: any) => {
  const [copyMsg, setCopyMsg] = useState(String)
  const [addressShow, setAddressShow] = useState(String)
  let address: string
  if (props.location.query) {
    address = props.location.query.privateKey
  }

  useEffect(() => {
    setAddressShow(address)
  })

  const onClickCopy = () => {
    if (copy(address)) {
      setCopyMsg("Copy success")
    } else {
      setCopyMsg("Copy failed")
    }
  }

  return (
    <Box width="100%" align="center" gap="small">
      <Text color="text" size="18px">Check here for more info about how to use this lock hash.</Text>
      <Box width="600px" pad="large" gap="large">
        <TextInput style={{ color: "white" }} readOnly width="100%" value={addressShow} />
        <Text alignSelf="center" color="brand">{copyMsg}</Text>
        <Button primary alignSelf="center" label="Copy" onClick={onClickCopy} />
      </Box>
    </Box>
  )
}
