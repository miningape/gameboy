package instructions

import "core:log"
import "../"
import op "../operands"

JP :: proc(c: ^cpu.Cpu, instruction: Instruction) {
  cpu.incrementPC(c) 
  
  switch left in instruction.left(c) {
    case op.Register: // JP HL - HL register only
      address := op.registerIsU16(left)
      c.registers.pc = address

    case op.Literal:
      switch literal in left {
        case u8: 
          panic("Cannot JP to a u8")

        case u16: // JP u16
        address := literal
        log.debugf("jp u16 (%#04X)", address)
          c.registers.pc = address

        case bool: // JP NZ|Z|NC|C u16
          if literal {
            address := instruction.right(c).(op.Literal).(u16)
            c.registers.pc = address
          } else {
            // Go to the next instruction
            // already consumed Instruction (JP)
            cpu.incrementPC(c) // Lower Byte (address)
            cpu.incrementPC(c) // Upper Byte (address)
          }
      }
    
    case op.Pointer:
      panic("Cannot JP to a pointer in memory")
  }
}