package operands

import "../"

// @(private = "file")
// intoB_ :: proc(c: ^cpu.Cpu, operand: Operand) {
//   data := operandIsU8(operand)
//   c.registers.b = data
// }

// intoB :: proc(c: ^cpu.Cpu) -> Operand {
//   return intoB_
// }

B :: proc(c: ^cpu.Cpu) -> Operand {
  register: Register = &c.registers.b
  return register
}
