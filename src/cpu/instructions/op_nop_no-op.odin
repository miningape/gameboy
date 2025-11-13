package instructions

import "../"

NOP :: proc(c: ^cpu.Cpu, i: Instruction) {
  cpu.incrementPC(c)
}