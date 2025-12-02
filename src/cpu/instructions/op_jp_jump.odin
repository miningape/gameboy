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

@(private = "file")
jumpRelative :: proc(c: ^cpu.Cpu, relativeIndex: u8) {  
  // relativeIndex is actually an i8 (signed integer) using twos complement
  isPositive := (0b1000_0000 & relativeIndex) == 0
  
  // It's simpler / faster for us to manually subtract / add it, as the other route would require upcasting to a i32 (so we don't lose precision) then downcasting back to u16 - which is what we do for ADD SP i16
  if isPositive {
    value := u16(relativeIndex)
    c.registers.pc += value
  } else {
    // Convert it to positively signed equivalent (twos complement), then subtract that
    value := u16(~relativeIndex + 1) 
    c.registers.pc -= value
  }
}

JR :: proc(c: ^cpu.Cpu, instruction: Instruction) {
  // Jump relative is from the next instruction - since previous instructions are "consumed"
  // https://www.reddit.com/r/EmuDev/comments/jmo5x1/gameboy_0x20_instruction/
  
  cpu.incrementPC(c)

  switch left in instruction.left(c) {
    case op.Literal:
      switch literal in left {
        case u8: // JR s8
          log.debug("Jump relative by", literal)
          jumpRelative(c, literal)

        case bool: // JR C|NC|Z|NC i8
          if literal {
            relativeIndex := instruction.right(c).(op.Literal).(u8)
            log.debug("Jump relative by", relativeIndex)
            jumpRelative(c, relativeIndex)
          } else {
            // Go to the next instruction
            // Already consumed instruction (JP)
            // Already consumed condition (C|NC|Z|NZ)
            cpu.incrementPC(c) // Consume signed byte
          }

        case u16:
          panic("Cannot JR to a 16-bit address")
      }

    case op.Register:
      panic("Cannot JR to an address in a register")
    
    case op.Pointer:
      panic("Cannot JR to an address stored in memory")
  }
}