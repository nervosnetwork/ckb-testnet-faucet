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
  checkBox: {
    border: {
      color: {
        light: "#999999"
      }
    },
    color: {
      light: themeColor
    },
    check: {
      radius: "2px"
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
