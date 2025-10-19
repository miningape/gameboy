package operands

import "../"

@(private = "file")
intoSP_ :: proc(c: ^cpu.Cpu, operand: Operand) {
  data := operandIsU16(operand)
  c.registers.sp = data
}

intoSP :: proc(c: ^cpu.Cpu) -> Operand {
  return intoSP_
}
