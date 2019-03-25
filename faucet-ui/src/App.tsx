import { Box, Heading, Stack } from 'grommet';
import * as React from 'react';
import Router from './components/Router';
import Theme from './components/Theme';

const App = () => {
  return (
    <Theme>
      <Stack>
        <img src="//cdn.cryptape.com/videos/nervos_poster.png" width="100%"></img>
        <video autoPlay loop>
          <source src="//cdn.cryptape.com/videos/nervos_org_bg.mp4" type="video/mp4" />
        </video>
        <Box>
          <Box align="center" pad={{ top: "large", bottom: "medium" }}>
            <Heading color="white">Nervos Testnet Faucet</Heading>
          </Box>
          <Router />
        </Box>
      </Stack>
    </Theme>
  )
}

export default App;
