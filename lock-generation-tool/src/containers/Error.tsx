import { Box, Text } from 'grommet';
import * as React from 'react';
import { Routes } from '../utils/const';
import { APIHost } from '../utils/const';

export default (props: any) => {
  React.useEffect(() => {
    fetch(`${APIHost}`).then((_response) => {
      props.history.push({ pathname: Routes.Home })
    }).catch(() => {
    })
  }, [])

  return (
    <Box align='center' gap='small'>
      <Text color="text" size="16px">Sorry, the server may have something wrong.</Text>
      <Text color="text" size="16px">Please try again later.</Text>
    </Box>
  )
}
