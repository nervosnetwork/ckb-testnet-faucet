import crypto from './crypto'

export const { blake2b } = crypto

export const PERSONAL = Buffer.from('ckb-default-hash', 'utf8')

export const hexToBytes = (rawhex: any) => {
  let hex = rawhex.toString(16)

  hex = hex.replace(/^0x/i, '')
  hex = hex.length % 2 ? `0${hex}` : hex

  const bytes = []
  for (let c = 0; c < hex.length; c += 2) {
    bytes.push(parseInt(hex.substr(c, 2), 16))
  }
  return new Uint8Array(bytes)
}

export const bytesToHex = (bytes: Uint8Array): string => {
  const hex = []
  /* eslint-disabled */
  for (let i = 0; i < bytes.length; i++) {
    hex.push((bytes[i] >>> 4).toString(16))
    hex.push((bytes[i] & 0xf).toString(16))
  }
  /* eslint-enabled */
  return hex.join('')
}

export const jsonScriptToTypeHash = ({
  reference,
  binary,
  signedArgs,
}: {
  reference?: string
  binary?: Uint8Array
  signedArgs?: Uint8Array[]
}) => {
  const s = blake2b(32, null, null, PERSONAL)
  if (reference) {
    s.update(Buffer.from(reference.replace(/^0x/, ''), 'hex'))
  }
  s.update(Buffer.from('|'))
  if (binary && binary.length) s.update(binary)
  if (signedArgs && signedArgs.length) {
    signedArgs.forEach(signedArg => {
      s.update(signedArg)
    })
  }

  const digest = s.digest('hex')
  return digest as string
}
