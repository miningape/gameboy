package operands

import "../"

@(private = "file")
intoC_ :: proc(c: ^cpu.Cpu, operand: Operand) {
  data := operandIsU8(operand)
  c.registers.c = data
}

intoC :: proc(c: ^cpu.Cpu) -> Operand {
  return intoC_
}
