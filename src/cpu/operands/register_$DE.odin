package operands

import "../"
import "../../bus"

DE :: proc(c: ^cpu.Cpu) -> Operand {
  r: Register = [2]^cpu.Register {
    &c.registers.d,
    &c.registers.e
  }
      
  return r
}

DE_ptr :: proc(c: ^cpu.Cpu) -> Operand {
  location := cpu.unify(c.registers.d, c.registers.e)
  
  return Pointer(bus.pointer(c.bus, location))
}
