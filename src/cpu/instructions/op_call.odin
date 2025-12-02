package instructions

import "core:log"
import "../"
import "../../bus"
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

  cpu.setFlagN(c, false)
  cpu.setFlagH(c, false)
  cpu.setFlagC(c, true)
}
