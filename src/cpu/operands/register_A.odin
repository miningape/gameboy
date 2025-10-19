package operands

import "../"

@(private = "file")
intoA_ :: proc(c: ^cpu.Cpu, operand: Operand) {
  data := operandIsU8(operand)
  c.registers.a = data
}

intoA :: proc(c: ^cpu.Cpu) -> Operand {
  return intoA_
}