import { Grommet } from 'grommet'
import * as React from 'react'

const customTheme = {
  button: {
    border: {
      radius: "4px"
    },
    color: "white",
  },
  global: {
    colors: {
      brand: "#4ec995",
      text: "white",
      border: "white"
    }
  }
}

export default ({children} : {children?: React.ReactNode}) => {
  return (
    <Grommet theme={customTheme}>{children}</Grommet>
  )
}
