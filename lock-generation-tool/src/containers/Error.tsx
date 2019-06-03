import { Box, Text } from 'grommet';
import React, { useEffect } from 'react';
import { Routes } from '../utils/const';
import { APIHost } from '../utils/const';

export default (props: any) => {
  useEffect(() => {
    fetch(`${APIHost}`).then((_response) => {
      props.history.push({ pathname: Routes.Home })
    })
  }, [])

  return (
    <Box align='center' gap='small'>
      <Text color="text" size="16px">Sorry, the server may have something wrong.</Text>
      <Text color="text" size="16px">Please try again later.</Text>
    </Box>
  )
}
