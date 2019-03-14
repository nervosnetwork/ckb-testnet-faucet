import { Box, Text, TextInput, Button } from 'grommet'
import * as React from 'react'
import copy from 'copy-to-clipboard'

export default (props: any) => {
  const [copyMsg, setCopyMsg] = React.useState(String)
  let lockHash: String | undefined
  if (props.location.query) {
    lockHash = props.location.query.lockHash
  }

  const onClickCopy = () => {
    if (copy(lockHash as string)) {
      setCopyMsg("Copy success")
    } else {
      setCopyMsg("Copy failed")
    }
  }

  return(
    <Box width="100%" align="center" gap="small">
      <Text size="18px">Check here for more info about how to use this lock hash.</Text>
      <Box width="600px" pad="large" gap="large">
        <TextInput readOnly width="100%" value={lockHash as string}/>
        <Text alignSelf="center" color="brand">{copyMsg}</Text>
        <Button primary alignSelf="center" label="Copy" onClick={onClickCopy}/>
      </Box>
    </Box>
  ) 
}
