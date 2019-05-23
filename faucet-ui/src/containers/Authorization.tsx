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
    <Box align="center" gap="small" pad={{ "left": "xlarge", "right": "xlarge" }}>
            <ul>
                <li><Text color="text" size="xlarge">Sign in with your GitHub account to get Testnet tokens for free.</Text></li>
                <li><Text color="text" size="xlarge">Please note that each account can only request tokens once every 24 hours.</Text></li>
                <li><Text color="text" size="xlarge">For more information, please refer to the <Anchor href='https://docs.nervos.org' color='brand' target='_blank' >documentation website</Anchor>.</Text></li>
            </ul>
            <Box align="start" pad="small">
                <CheckBox checked={enable} onChange={onChangeEnable} label="I understand that I am requesting for Testnet tokens instead of official Nervos tokens." />
            </Box>
            <Button disabled={!enable} primary onClick={onLoginWithGitHub} label="Log in with GitHub" />
        </Box>
  )
}
