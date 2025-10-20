package operands

import "../"

// @(private = "file")
// intoHL_ :: proc(c: ^cpu.Cpu, operand: Operand) {
//   data := operandIsU16(operand)
//   intoRegisterPair(&c.registers.h, &c.registers.l, data)
// }

// intoHL :: proc(c: ^cpu.Cpu) -> Operand {
//   return intoHL_
// }

HL :: proc(c: ^cpu.Cpu) -> Operand {
  r: Register = [2]^cpu.Register {
    &c.registers.h,
    &c.registers.l
  }
      
  return r
}
