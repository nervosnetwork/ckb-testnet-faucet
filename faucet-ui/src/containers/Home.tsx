import { Box, Button, Text, TextInput } from 'grommet';
import * as React from 'react';
import { Routes } from '../utils/const';

export default (props: any) => {
  const inputKey = React.useRef(null)
  const [errorMessage, setErrorMessage] = React.useState(null as string | null)
  const onClickGetTestToken = () => {
    const element = inputKey.current! as HTMLInputElement
    if (element.value.length > 0) {
      setErrorMessage(null)
      // TODO: Send a transaction request to the server
      props.history.push({pathname: Routes.Success, query: {txhash: element.value}})
    } else {
      setErrorMessage("Wrong lock hash. Please check here for the lock hash format of Nervos CKB")
    }
  }

  // TODO: Determine whether need to enter the authentication or failure page
  // props.history.push({pathname: Routes.Auth})
  // props.history.push({pathname: Routes.Failure})
  
  return (
    <Box width="100%" align="center" gap="small">
      <Text size="16px">Please note that each GitHub account can only request test tokens once every 24 hours.</Text>
      <Text size="16px">Check here for information about lock hash.</Text>
      <Text size="16px">Check here for a tool of generating private key and lock hash.</Text>
      <Box width="600px" align="start" pad="small" gap="small">
        <Text size="16px">Enter the lock hash here to receive test tokens</Text>
        <TextInput width="100%" ref={inputKey} placeholder="Please enter the lock hash here." />
        {errorMessage ? <Text color="red" size="16px">Wrong lock hash. Please check here for the lock hash format of Nervos CKB</Text> : <div />}
      </Box>
      <Button primary={true} label="Get Test Token" onClick={onClickGetTestToken} />
    </Box>
  )
}
