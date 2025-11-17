package instructions

import "core:log"

import "../"

PREFIX :: proc(c: ^cpu.Cpu, instruction: Instruction) {
  cpu.incrementPC(c)
  
  log.errorf("Executing prefixed instruction 0xCB %#02X - not implemented, skipping", c.registers.pc)

  cpu.incrementPC(c)
}
