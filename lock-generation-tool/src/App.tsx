import { Box, Heading, Stack } from 'grommet';
import * as React from 'react';
import styled from 'styled-components';
import Router from './components/Router';
import Theme from './components/Theme';

const Video = styled.video`
  object-fit: fill;
  height: 100%;
  width: 100%;
`

const App = () => {
  return (
    <Box height="100vh">
      <Stack fill>
        <img src="//cdn.cryptape.com/videos/nervos_poster.png" width="100%" height="100%"></img>
        <Video autoPlay loop>
          <source src="//cdn.cryptape.com/videos/nervos_org_bg.mp4" type="video/mp4" />
        </Video>
        <Theme>
          <Box>
            <Box align="center" pad={{ top: "large", bottom: "medium" }}>
              <Heading color="white">Nervos Key and Lock Generation Tool</Heading>
            </Box>
            <Router />
          </Box>
        </Theme>
      </Stack>
    </Box>
  )
}

export default App;
