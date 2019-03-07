import { Box, Heading } from 'grommet';
import * as React from 'react';
import Router from './components/Router';
import Theme from './components/Theme';

const App = () => {
  return (
    <Theme>
      <Box>
        <Box align="center" pad={{top: "large", bottom: "medium"}}>
          <Heading>Nervos Testnet Faucet</Heading>
        </Box>
        <Router />
      </Box>
    </Theme>
  )
}

export default App;
