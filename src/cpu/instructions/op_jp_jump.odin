package instructions

import "../"
import "../operands"

JP :: proc(c: ^cpu.Cpu, instruction: Instruction) {
  cpu.incrementPC(c)

  address := instruction.left(c).(u16)

  c.registers.pc = address
}