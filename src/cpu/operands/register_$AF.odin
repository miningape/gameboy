package operands

import "../../cpu"

AF :: proc(c: ^cpu.Cpu) -> Operand {
  r: Register = [2]^cpu.Register {
    &c.registers.a,
    &c.registers.f
  }
      
  return r
}
