import fetchJsonp from 'fetch-jsonp';
import { Box, Button, Text, TextInput, Anchor } from 'grommet';
import React, { useState, useEffect, useRef, ReactNode } from 'react';
import { Routes } from '../utils/const';
import 'rsuite/dist/styles/rsuite.min.css';
import { Loader } from 'rsuite';

export default (props: any) => {
  const [enable, setEnable] = useState(false)
  const inputKey = useRef(null)
  const [errorElement, setErrorElement] = useState(null as ReactNode | null)
  const [loading, setLoading] = useState(false)

  const onClickGetTestToken = () => {
    const element = inputKey.current! as HTMLInputElement
    const address = element.value.trim()
    if (address.length > 0) {
      setErrorElement(null)
      setLoading(true)

      fetchJsonp(`${process.env.REACT_APP_API_HOST}/ckb/faucet?address=${address}`, { timeout: 1000 * 60 }).then((response: any) => {
        return response.json()
      }).then((json: any) => {
        switch (json.status) {
          case 0:
            props.history.push({ pathname: Routes.Success, query: { txHash: json.data.txHash } })
            break
          case -1:
            props.history.push({ pathname: Routes.Auth })
            break
          case -2:
            props.history.push({ pathname: Routes.Failure })
            break
          default:
            setErrorElement(<Text color="red" size="16px">{json.message}</Text>)
            break
        }
      }).finally(() => {
        setLoading(false)
      })
    } else {
      setErrorElement(
        <Text color="red" size="16px">
          Wrong address format. Please refer to the <Anchor href='https://docs.nervos.org' color='red' target='_blank'>document</Anchor> for how to generate wallet.
        </Text>
      )
    }
  }

  // Determine whether need to enter the authentication or failure page
  useEffect(() => {
    setLoading(true)
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
      setLoading(false)
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
        {errorElement ? errorElement : <div />}
      </Box>
      <Button disabled={!enable} primary label="Get Some Testnet Tokens" onClick={onClickGetTestToken} />
      <Text color="text" size="small">If there are any problems, you can find us on <Anchor href='https://t.me/NervosNetwork' color='brand' target='_blank'>Telegram</Anchor>.</Text>
      {loading ? <Loader backdrop content="loading..." vertical /> : <div />}
    </Box>
  )
}
