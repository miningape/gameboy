package operands

import "../"

Operand :: union {
  u16,
  byte,
  proc(c: ^cpu.Cpu, o: Operand)
}

@(private)
operandIsU8 :: proc(operand: Operand) -> byte {
  data, ok := operand.(byte)

  if !ok {
    panic("Could not read operand for u8")
  }

  return data
}

@(private)
operandIsU16 :: proc(operand: Operand) -> u16 {
  data, ok := operand.(u16)

  if !ok {
    bt: byte
    bt, ok = operand.(byte)

    if !ok {
      panic("Could not read operand for u16")
    }

    data = u16(bt)
  }

  return data
}

@(private)
intoRegisterPair :: proc(upper: ^cpu.Register, lower: ^cpu.Register, data: u16) {
  upper^ = u8(data >> 8)
  lower^ = u8(data)
}
