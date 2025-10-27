package operands

import "../"

A :: proc(c: ^cpu.Cpu) -> Operand {
  register: Register = &c.registers.a
  return register
}
