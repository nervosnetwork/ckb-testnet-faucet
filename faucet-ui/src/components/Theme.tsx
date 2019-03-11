import { Grommet } from 'grommet';
import * as React from 'react';

const customTheme = {
  button: {
    border: {
      radius: "4px"
    },
    color: "white",
  },
  checkBox: {
    border: {
      color: {
        light: "#999999"
      }
    },
    color: {
      light: "brand"
    },
    check: {
      radius: "2px"
    }
  },
  global: {
    colors: {
      brand: "#4ec995"
    }
  }
}

export default ({children} : {children?: React.ReactNode}) => {
  return (
    <Grommet theme={customTheme}>{children}</Grommet>
  )
}
