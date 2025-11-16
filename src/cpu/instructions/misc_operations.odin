package instructions

// This file is for instructions that don't "fit" with others, and don't justify their own files

import "../"

// Set Carry Flag
SCF :: proc(c: ^cpu.Cpu, instruction: Instruction) {
  cpu.incrementPC(c)

  // Doesn't affect Z flag
  cpu.setFlagN(c, false)
  cpu.setFlagH(c, false)
  cpu.setFlagC(c, true)
}
