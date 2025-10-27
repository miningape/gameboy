package operands

import "../"
import "../../bus"

BC :: proc(c: ^cpu.Cpu) -> Operand {
  r: Register = [2]^cpu.Register {
    &c.registers.b,
    &c.registers.c
  }
      
  return r
}

BC_ptr :: proc(c: ^cpu.Cpu) -> Operand {
  location := cpu.unify(c.registers.b, c.registers.c)

  return Pointer(bus.pointer(c.bus, location))
}

