import { Grommet } from 'grommet'
import React, { ReactNode } from 'react'

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

export default ({ children }: { children?: ReactNode }) => {
  return (
    <Grommet theme={customTheme}>{children}</Grommet>
  )
}
