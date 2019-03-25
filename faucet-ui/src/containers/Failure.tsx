import { Box, Text } from 'grommet';
import * as React from 'react';

export default () => {
  return (
    <Box align="center" gap="small">
      <Text color="text" size="16px">Sorry you have requested tokens in the past 24 hours.</Text>
      <Text color="text" size="16px">Please come back later to request more.</Text>
    </Box>
  )
}
