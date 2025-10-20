package operands

import "../"

// @(private = "file")
// intoDE_ :: proc(c: ^cpu.Cpu, operand: Operand) {
//   data := operandIsU16(operand)
//   intoRegisterPair(&c.registers.d, &c.registers.e, data)
// }

// intoDE :: proc(c: ^cpu.Cpu) -> Operand {
//   return intoDE_
// }

DE :: proc(c: ^cpu.Cpu) -> Operand {
  r: Register = [2]^cpu.Register {
    &c.registers.d,
    &c.registers.e
  }
      
  return r
}
