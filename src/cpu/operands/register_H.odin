package operands

import "../"

// @(private = "file")
// intoH_ :: proc(c: ^cpu.Cpu, operand: Operand) {
//   data := operandIsU8(operand)
//   c.registers.h = data
// }

// intoH :: proc(c: ^cpu.Cpu) -> Operand {
//   return intoH_
// }

H :: proc(c: ^cpu.Cpu) -> Operand {
  register: Register = &c.registers.h
  return register
}
