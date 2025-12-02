package instructions

import "core:log"

import "../"
import "../operands"

CALL :: proc(c: ^cpu.Cpu, instruction: Instruction) {
  cpu.incrementPC(c)

  left := instruction.left(c).(operands.Literal)
  switch literal in left {
    case u16:
      cpu.push(c, c.registers.pc)
      
      address := literal
      log.debugf("CALL u16 (%#04X) (Jumping)", address)
      c.registers.pc = address

    case bool:
      address := instruction.right(c).(operands.Literal).(u16)
      if literal {
        log.debugf("CALL u16 (%#04X) (Jumping)", address)
        cpu.push(c, c.registers.pc)
        c.registers.pc = address
      } else {
        log.debugf("CALL u16 (%#04X) (No Jump)", address)
      }

    case u8:
      panic("Cannot CALL u8")
  }

  // Flags not affected
}

@(private="file")
RET_impl :: proc(c: ^cpu.Cpu) {
  address := cpu.pop(c)
  log.debugf("RET (%#04X)", address)
  c.registers.pc = address
}

RET :: proc(c: ^cpu.Cpu, instruction: Instruction) {
  cpu.incrementPC(c)

  if instruction.left == nil {
    RET_impl(c)
    return
  }

  shouldReturn := instruction.left(c).(operands.Literal).(bool)
  if shouldReturn {
    RET_impl(c)
    return
  }
  
  log.debugf("RET (skipping)")

  // Flags not affected
}
