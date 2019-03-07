import { Grommet } from 'grommet';
import * as React from 'react';

const themeColor = "#4ec995"

const customTheme = {
  button: {
    border: {
      color: themeColor,
      radius: "4px"
    },
    color: "white",
    primary: {
      color: themeColor
    }
  },
  global: {
    focus: {
      border: {
        color: themeColor
      }
    }
  }
}

export default ({children} : {children?: React.ReactNode}) => {
  return (
    <Grommet theme={customTheme}>{children}</Grommet>
  )
}
