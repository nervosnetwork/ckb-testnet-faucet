import { Box, Button, CheckBox, Text, Anchor } from 'grommet';
import * as React from 'react';

export default () => {
  const [enable, setEnable] = React.useState(false)

  const onChangeEnable = () => {
    setEnable(!enable)
  }

  const onLoginWithGitHub = () => {
    window.location.href = `https://github.com/login/oauth/authorize?client_id=${process.env.REACT_APP_GITHUB_OAUTH_CLIENT_ID}&state=${window.location.origin}&scope=user:email`;
  }

  return (
    <Box align="center" gap="small">
      <Text color="text" size="xlarge">This faucet is for developers who wanna try developing on Nervos CKB but don't want to run a node themselves.</Text>
      <Text color="text" size="xlarge">To get some test token, please click the button below to login with your GitHub ID.</Text>
      <Text color="text" size="xlarge">Each account can only request test token once ever 24 hours.</Text>
      <Text color="text" size="xlarge">Please refer to <Anchor href='https://docs.nervos.org' color='text' target='_blank'>documents</Anchor> for more information.</Text>
      <Box align="center" pad="small">
        <CheckBox checked={enable} onChange={onChangeEnable} label="I understand this is for getting test tokens instead of official CKB tokens" />
      </Box>
      <Button disabled={!enable} primary onClick={onLoginWithGitHub} label="Login with GitHub" />
    </Box>
  )
}
