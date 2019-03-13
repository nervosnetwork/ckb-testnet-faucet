import { Grommet } from 'grommet'
import * as React from 'react'

const customTheme = {
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
