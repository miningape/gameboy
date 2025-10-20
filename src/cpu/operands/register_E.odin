package operands

import "../"

// @(private = "file")
// intoE_ :: proc(c: ^cpu.Cpu, operand: Operand) {
//   data := operandIsU8(operand)
//   c.registers.e = data
// }

// intoE :: proc(c: ^cpu.Cpu) -> Operand {
//   return intoE_
// }

E :: proc(c: ^cpu.Cpu) -> Operand {
  register: Register = &c.registers.e
  return register
}
