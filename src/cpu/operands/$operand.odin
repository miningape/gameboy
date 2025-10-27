package operands

import "../"

Register :: union #no_nil {
  ^cpu.Register,
  ^cpu.Register16,
  [2]^cpu.Register,
}

Pointer :: distinct ^byte

Operand :: union #no_nil {
  u8,
  u16,
  Register,
  Pointer
}

registerIsU8 :: proc(r: Register) -> u8 {
  register, ok := r.(^cpu.Register)
  
  if !ok {
    panic("Tried to read a 16-bit register as 8-bit")
  }

  return register^
}

operandIsU8 :: proc(op: Operand) -> byte {
  switch operand in op {
    case u8:
      return operand
    case u16:
      panic("Tried to read a u16 as a u8")
    case Pointer: 
      return operand^
    case Register:
      return registerIsU8(operand)
  }

  panic("Unrecognized operand type")
}

registerIsU16 :: proc(r: Register) -> u16 {
  switch register in r {
    case ^cpu.Register:
      return u16(register^)

    case ^cpu.Register16:
      return register^

    case [2]^cpu.Register:
      return u16(register[0]^) << 8 | u16(register[1]^)
  }

  panic("Unrecognized register type")
}

operandIsU16 :: proc(op: Operand) -> u16 {
  switch operand in op {
    case u8:
      return u16(operand)

    case u16:
      return operand

    case Pointer:
      return u16(operand^)

    case Register:
      return registerIsU16(operand)
  }

  panic("Unrecognized operand type")
}

into8BitRegister :: proc(register: ^cpu.Register, op: Operand) {
  data := operandIsU8(op)
  register^ = data
}

@(private)
intoRegisterPair :: proc(upper: ^u8, lower: ^u8, data: u16) {
  upper^ = u8(data >> 8)
  lower^ = u8(data)
}

into16BitRegisterPair :: proc(upper: ^cpu.Register, lower: ^cpu.Register, op: Operand) {
  data := operandIsU16(op)
  intoRegisterPair(upper, lower, data)
}

into16BitRegister :: proc(register: ^cpu.Register16, op: Operand) {
  data := operandIsU16(op)
  register^ = data
}

intoRegister :: proc(register: Register, data: Operand) {
  switch r in register {
    case ^cpu.Register:
      into8BitRegister(r, data)
    case ^cpu.Register16:
      into16BitRegister(r, data)
    case [2]^cpu.Register:
      into16BitRegisterPair(r[0], r[1], data)
  }
}
