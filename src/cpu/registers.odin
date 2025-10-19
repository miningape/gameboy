package cpu

Register :: u8
Register16 :: u16

Registers :: struct {
  a: Register, f: Register,
  b: Register, c: Register,
  d: Register, e: Register,
  h: Register, l: Register,
  pc: Register16,
  sp: Register16
}
