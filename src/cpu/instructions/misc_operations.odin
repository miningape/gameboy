package instructions

import "core:log"
// This file is for instructions that don't "fit" with others, and don't justify their own files

import "../"
import "../operands"

// Set Carry Flag
SCF :: proc(c: ^cpu.Cpu, instruction: Instruction) {
  cpu.incrementPC(c)

  // Doesn't affect Z flag
  cpu.setFlagN(c, false)
  cpu.setFlagH(c, false)
  cpu.setFlagC(c, true)
}

// Complement (toggle) Carry Flag
CCF :: proc(c: ^cpu.Cpu, instruction: Instruction) {
  cpu.incrementPC(c)

  // Doesn't affect Z flag
  cpu.setFlagN(c, false)
  cpu.setFlagH(c, false)

  cpu.toggleFlagC(c)
}

// ComPLement register (only A register in practise)
CPL :: proc(c: ^cpu.Cpu, instruction: Instruction) {
  cpu.incrementPC(c)

  register := instruction.left(c).(operands.Register).(^cpu.Register)

  log.debugf("%#02X", register^)
  register^ ~= 0xFF
  log.debugf("%#02X", register^)

  // Z flag not set
  cpu.setFlagN(c, true)
  cpu.setFlagH(c, true)
  // C flag not set
}
