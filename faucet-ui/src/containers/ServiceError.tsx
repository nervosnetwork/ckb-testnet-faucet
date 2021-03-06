import fetchJsonp from 'fetch-jsonp';
import { Box, Text } from 'grommet';
import React, { useEffect } from 'react';
import { Routes } from '../utils/const';

export default (props: any) => {
  useEffect(() => {
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
        case -2:
          props.history.push({ pathname: Routes.Failure })
          break
      }
    })
  }, [props.history])

  return (
    <Box align='center' gap='small' pad={{ "left": "xlarge", "right": "xlarge" }}>
      <Text textAlign='center' color="text" size='xlarge'> There's something wrong with your internet connection. </Text>
      <Text textAlign='center' color="text" size='xlarge'> Please try again later. </Text>
    </Box>
  )
}
