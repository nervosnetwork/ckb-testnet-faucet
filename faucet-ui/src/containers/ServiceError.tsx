import fetchJsonp from 'fetch-jsonp';
import { Box, Text } from 'grommet';
import * as React from 'react';
import { Routes } from '../utils/const';

export default (props: any) => {
  React.useEffect(() => {
    fetchJsonp(`${process.env.REACT_APP_API_HOST}/auth/verify`).then((response: any) => {
      return response.json()
    }).then((json: any) => {
      switch (json.status) {
        case 0:
          props.history.push({ pathname: Routes.Home })
          break
        case -1:
          props.history.push({ pathname: Routes.Auth })
          break
      }
    })
  }, [])

  return (
    <Box align='center' gap='small'>
      <Text textAlign='center' color="text" size='xxlarge'>There's something wrong with your internet connection. Please try again later.</Text>
    </Box>
  )
}
