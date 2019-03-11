import { Box, Button, CheckBox, Text } from 'grommet';
import * as React from 'react';
import { ClientId } from '../utils/const'

export default () => {
  const [enable, setEnbale] = React.useState(false)

  const onChangeEnable = () => {
    setEnbale(!enable)
  }

  const onLoginWithGithub = () => {
    window.location.href=`https://github.com/login/oauth/authorize?client_id=${ClientId}&state=${window.location.origin}`;
  }

  return (
    <Box align="center" gap="small">
      <Text size="16px">This faucet is for developers who wanna try developing on Nervos CKB but don't really feel like running a node themselves.</Text>
      <Text size="16px">To get some test token, please click the button below to login with your GitHub ID.</Text>
      <Text size="16px">Each account can only request test token once ever 24 hours.</Text>
      <Box align="center" pad="small">
        <CheckBox checked={enable} onChange={onChangeEnable} label="I understand this is for getting test tokens instead of official CKB" />
      </Box>
      <Button disabled={!enable} primary onClick={onLoginWithGithub} label="Login with Github" />
    </Box>
  )
}
