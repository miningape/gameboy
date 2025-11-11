package operands

import "../"

SP :: proc(c: ^cpu.Cpu) -> Operand {
  return Register(&c.registers.sp)
}
