import { Box, Text, Button, TextInput } from 'grommet';
import * as React from 'react';
import { Routes } from '../utils/const';
import { APIHost } from '../utils/const';

export default (props: any) => {
  const inputKey = React.useRef(null)
  const [errorMsg, setErrorMsg] = React.useState(null as String | null)
  const onClickGenerateLockAndKey = () => {
    props.history.push({ pathname: Routes.NewKeyLock })
  }  

  const onClickGenerateLock = () => {
    const element = inputKey.current! as HTMLInputElement
    const value = element.value
    if (value.length > 0) {
      fetch(`${APIHost}/ckb/address?privateKey=${value}`).then((response) => {
        return response.json()
      }).then((json) => {
        props.history.push({ pathname: Routes.NewLock, query: { privateKey: json.address } })
      }).catch(() => {
        props.history.push({ pathname: Routes.Error })
      })
    } else {
      setErrorMsg("Please enter your private key")
    }
  }

  return (
    <Box width="100%" align="center" gap="small">
      <Text color="text" size="18px">This is a tool for generate the Key and Lock for Nervos CKB.</Text>
      <Text color="text" size="18px">Please refer here for more information about devloping on CKB.</Text>
      <Text color="text" size="18px">For safety reasons, please cut off your internet connection before using this webpage.</Text>
      <Box pad={{ top: "medium" }}>
        <Button primary label="Generate New Key&Lock" onClick={onClickGenerateLockAndKey} />
      </Box>
      <Box width="600px" pad={{ top: "large" }}>
        <TextInput style={{ color: "white" }} width="100%" placeholder="Please enter your private key" ref={inputKey} />
        {errorMsg ? <Text color="red" size="16px">{errorMsg}</Text> : <div />}
      </Box>
      <Button primary label="Generate lock form your key" onClick={onClickGenerateLock} />
    </Box>
  )
}
