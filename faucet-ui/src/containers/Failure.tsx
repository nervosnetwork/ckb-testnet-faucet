import { Box, Text } from 'grommet';
import * as React from 'react';

export default () => {
  return (
    <Box align="center" gap="small">
      <Text color="text" size="xlarge"> It seems that you have already requested Testnet tokens in the past 24 hours. </Text>
      <Text color="text" size="xlarge"> Please try again later. </Text>
    </Box>
  )
}
