package operands

import "../"

@(private = "file")
intoD_ :: proc(c: ^cpu.Cpu, operand: Operand) {
  data := operandIsU8(operand)
  c.registers.d = data
}

intoD :: proc(c: ^cpu.Cpu) -> Operand {
  return intoD_
}
