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

unifyArgs :: proc(upper: Register, lower: Register) -> u16 {
  return u16(upper) << 8 | u16(lower)
}

unifyArray :: proc(register: [2]^Register) -> u16 {
  return u16(register[0]^) << 8 | u16(register[1]^)
}

unify :: proc{unifyArgs, unifyArray}

split :: proc(register: u16) -> (Register, Register) {
  return u8(register >> 8), u8(register)
}
