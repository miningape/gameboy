package operands

import "../"
import "../../bus"

C :: proc(c: ^cpu.Cpu) -> Operand {
  register: Register = &c.registers.c
  return register
}

// Used in LDH (load into high RAM)
HRAM_OFFSET :: 0xFF00
C_hram_ptr :: proc(c: ^cpu.Cpu) -> Operand {
  address := c.registers.c

  return Pointer(bus.pointer(c.bus, HRAM_OFFSET + u16(address)))
}
