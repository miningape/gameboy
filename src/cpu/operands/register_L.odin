package operands

import "../"

@(private = "file")
intoL_ :: proc(c: ^cpu.Cpu, operand: Operand) {
  data := operandIsU8(operand)
  c.registers.l = data
}

intoL :: proc(c: ^cpu.Cpu) -> Operand {
  return intoL_
}
