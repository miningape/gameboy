package operands

import "../"

SP :: proc(c: ^cpu.Cpu) -> Operand {
  return c.registers.sp
}
