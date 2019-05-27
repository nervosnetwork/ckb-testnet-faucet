import fetchJsonp from 'fetch-jsonp';
import { Box, Button, Text, TextInput, Anchor } from 'grommet';
import * as React from 'react';
import { Routes } from '../utils/const';
import 'rsuite/dist/styles/rsuite.min.css';
import { Loader } from 'rsuite';

export default (props: any) => {
  const [enable, setEnable] = React.useState(false)
  const inputKey = React.useRef(null)
  const [errorMessage, setErrorMessage] = React.useState(null as string | null)
  const [loading, setLoading] = React.useState(false)

  const onClickGetTestToken = () => {
    const element = inputKey.current! as HTMLInputElement
    const address = element.value
    if (address.length > 0) {
      setErrorMessage(null)
      setLoading(true)
      
      fetchJsonp(`${process.env.REACT_APP_API_HOST}/ckb/faucet?address=${address}`, { timeout: 1000 * 60 }).then((response: any) => {
        return response.json()
      }).then((json: any) => {
        switch (json.status) {
          case 0:
            props.history.push({ pathname: Routes.Success, query: { txHash: json.txHash } })
            break
          case -1:
            setErrorMessage(json.error)
            break
          case -2:
            switch (json.authStatus) {
              case -1:
                props.history.push({ pathname: Routes.Auth })
                break
              case -2:
                props.history.push({ pathname: Routes.Failure })
                break
              default:
                break
            }
            break
          default:
            break
        }
      }).finally(() => {
        setLoading(false)
      })
    } else {
      setErrorMessage("Wrong address. Please check here for the address format of Nervos CKB")
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
    <Box width="100%" align="center" gap="small" pad={{ "left": "xlarge", "right": "xlarge" }}>
      <ul>
        <li><Text color="text" size="large">Please note that each GitHub account can only request tokens once every 24 hours.</Text></li>
        <li><Text color="text" size="large">For more information, please refer to the <Anchor href='https://docs.nervos.org' color='brand' target='_blank'>documentation website</Anchor></Text></li>
      </ul>
      <Box width="600px" align="start" pad="small" gap="small">
        <TextInput style={{ color: "black" }} width="100%" ref={inputKey} placeholder='Please fill in your address here "ckt......"' />
        {errorMessage ? <Text color="red" size="16px">Wrong address. Please check here for the address format of Nervos CKB</Text> : <div />}
      </Box>
      <Button disabled={!enable} primary label="Get Some Testnes Tokens" onClick={onClickGetTestToken} />
      <Text color="text" size="small">If there are any problems, you can find us on <Anchor href='https://t.me/NervosNetwork' color='brand' target='_blank'>Telegram</Anchor>.</Text>
      {loading ? <Loader backdrop content="loading..." vertical /> : <div />}
    </Box>
  )
}
