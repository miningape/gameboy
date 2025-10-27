package operands

import "../"
import "../../bus"

HL :: proc(c: ^cpu.Cpu) -> Operand {
  r: Register = [2]^cpu.Register {
    &c.registers.h,
    &c.registers.l
  }
      
  return r
}

HL_ptr :: proc(c: ^cpu.Cpu) -> Operand {
  location := cpu.unify(c.registers.h, c.registers.l)
  
  return Pointer(bus.pointer(c.bus, location))
}
