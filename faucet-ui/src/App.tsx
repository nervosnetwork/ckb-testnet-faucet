import { Box, Heading, Stack } from 'grommet';
import React from 'react';
import Router from './components/Router';
import Theme from './components/Theme';

const App = () => {
  return (
    <Box height="100vh">
      <Stack fill>
        <Theme>
          <Box>
            <Box align="center" pad={{ top: "large", bottom: "medium" }}>
              <Heading color="black">Nervos Testnet Faucet</Heading>
            </Box>
            <Router />
          </Box>
        </Theme>
      </Stack>
    </Box>
  )
}

export default App;
