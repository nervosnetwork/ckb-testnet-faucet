import fetchJsonp from 'fetch-jsonp';
import { Box, Button, Text, TextInput } from 'grommet';
import * as React from 'react';
import { Routes } from '../utils/const';

export default (props: any) => {
  const [enable, setEnable] = React.useState(false)
  const inputKey = React.useRef(null)
  const [errorMessage, setErrorMessage] = React.useState(null as string | null)
  const onClickGetTestToken = () => {
    const element = inputKey.current! as HTMLInputElement
    const address = element.value
    if (address.length > 0) {
      setErrorMessage(null)
      
      fetchJsonp(`${process.env.REACT_APP_API_HOST}/ckb/faucet?address=${address}`).then((response: any) => {
        return response.json()
      }).then((json: any) => {
        switch (json.status) {
          case 0: 
            props.history.push({ pathname: Routes.Success, query: { txhash: json.txhash } })
            break
          case -1:
            props.history.push({ pathname: Routes.Auth })
            break
          case -2:
            props.history.push({ pathname: Routes.Failure })
            break
          default:
            setErrorMessage(json.error)
            break
        }
      })
    } else {
      setErrorMessage("Wrong lock hash. Please check here for the lock hash format of Nervos CKB")
    }
  }

  // Determine whether need to enter the authentication or failure page
  React.useEffect(() => {
    fetchJsonp(`${process.env.REACT_APP_API_HOST}/auth/verify`).then((response: any) => {
      return response.json()
    }).then((json: any) => {
      switch (json.status) {
        case -1:
          props.history.push({ pathname: Routes.Auth })
          break
        case -2:
          props.history.push({ pathname: Routes.Failure })
          break
      }
    }).catch((_ex: any) => {
      props.history.push({ pathname: Routes.ServiceError })
    }).finally(() => {
      setEnable(true)
    })
  }, [])

  return (
    <Box width="100%" align="center" gap="small">
      <Text color="text" size="16px">Please note that each GitHub account can only request test tokens once every 24 hours.</Text>
      <Text color="text" size="16px">Check here for information about lock hash.</Text>
      <Text color="text" size="16px">Check here for a tool of generating private key and lock hash.</Text>
      <Box width="600px" align="start" pad="small" gap="small">
        <Text color="text" size="16px">Enter the lock hash here to receive test tokens</Text>
        <TextInput style={{ color: "white" }} width="100%" ref={inputKey} placeholder="Please enter the lock hash here." />
        {errorMessage ? <Text color="red" size="16px">Wrong lock hash. Please check here for the lock hash format of Nervos CKB</Text> : <div />}
      </Box>
      <Button disabled={!enable} primary label="Get Test Token" onClick={onClickGetTestToken} />
    </Box>
  )
}
