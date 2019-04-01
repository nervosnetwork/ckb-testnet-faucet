import { Box, Text } from 'grommet';
import * as React from 'react';

export default () => {
  return (
    <Box align='center' gap='small'>
      <Text color="text" size="16px">Sorry, the server may have something wrong.</Text>
      <Text color="text" size="16px">Please try again later.</Text>
    </Box>
  )
}
