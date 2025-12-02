package instructions

import "core:log"
import "../"
import "../operands"

PUSH :: proc(c: ^cpu.Cpu, instruction: Instruction) {
  cpu.incrementPC(c)

  // Only affects combo registers
  left := instruction.left(c).(operands.Register).([2]^cpu.Register)
  value := cpu.unify(left)

  cpu.push(c, value)
  
  // Flags not affected
}

POP :: proc(c: ^cpu.Cpu, instruction: Instruction) {
  cpu.incrementPC(c)

  // Only affects combo registers
  registers := instruction.left(c).(operands.Register).([2]^cpu.Register)

  value := cpu.pop(c)

  operands.intoRegister(registers, operands.Literal(value))

  // Flags indirectly affected when setting AF (F = flags register)
}
