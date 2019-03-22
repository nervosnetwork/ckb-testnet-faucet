import { Box, Text, Button, TextInput } from 'grommet';
import * as React from 'react'
import * as ECPair from '@nervosnetwork/ckb-sdk-utils/lib/ecpair'
import { hexToBytes, bytesToHex } from '@nervosnetwork/ckb-sdk-utils';
import { Routes } from '../utils/const';

export default (props: any) => {
  const inputKey = React.useRef(null)
  const [errorMsg, setErrorMsg] = React.useState(null as String | null)
  const onClickGenerateLockAndKey = () => {
    props.history.push({pathname: Routes.NewKeyLock})
  }

  const onClickGenerateLock = () => {
    const element = inputKey.current! as HTMLInputElement
    const value = element.value
    if (value.length > 0) {
      try {
        const bytesKey = hexToBytes(value)
        const ecpair = new ECPair.default(new Buffer(bytesKey))
        props.history.push({pathname: Routes.NewLock, query: { privateKey: bytesToHex(ecpair.privateKey)}})
        setErrorMsg(null)
      } catch  {
        setErrorMsg("Wrong private key. Please check here for the correct format of private key of CKB")
      }
    } else {
      setErrorMsg("Wrong private key. Please check here for the correct format of private key of CKB")
    }
  }

  return (
    <Box width="100%" align="center" gap="small">
      <Text color="text" size="18px">This is a tool for generate the Key and Lock for Nervos CKB.</Text>
      <Text color="text" size="18px">Please refer here for more information about devloping on CKB.</Text>
      <Text color="text" size="18px">For safety reasons, please cut off your internet connection before using this webpage.</Text>
      <Box pad={{top: "medium"}}>
        <Button  primary label="Generate New Key&Lock" onClick={onClickGenerateLockAndKey} />
      </Box>
      <Box width="600px" pad={{top: "large"}}>
        <TextInput style={{color:"white"}} width="100%" placeholder="Please enter your private key" ref={inputKey} />
        {errorMsg ? <Text color="red" size="16px">Please enter your private key</Text> : <div/>}
      </Box>
      <div />
      <Button primary label="Generate lock form your key" onClick={onClickGenerateLock}/>
    </Box>
  )
}
