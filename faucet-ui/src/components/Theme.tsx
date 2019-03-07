import { Grommet } from 'grommet';
import * as React from 'react';

const customTheme = {
  button: {
    border: {
      radius: "4px"
    }
  }
}

export default ({children} : {children?: React.ReactNode}) => {
  return (
    <Grommet theme={customTheme}>{children}</Grommet>
  )
}