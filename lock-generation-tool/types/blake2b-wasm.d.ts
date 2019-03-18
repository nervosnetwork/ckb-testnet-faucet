export = index;
declare class index {
  static BYTES: number;
  static BYTES_MAX: number;
  static BYTES_MIN: number;
  static KEYBYTES: number;
  static KEYBYTES_MAX: number;
  static KEYBYTES_MIN: number;
  static PERSONALBYTES: number;
  static SALTBYTES: number;
  static SUPPORTED: boolean;
  static WASM: Buffer;
  static ready(cb: any): any;
  constructor(digestLength: any, key: any, salt: any, personal: any, noAssert: any);
  digestLength: any;
  finalized: any;
  pointer: any;
  digest(enc: any): any;
  final(enc: any): any;
  ready(cb: any): any;
  update(input: any): any;
}
