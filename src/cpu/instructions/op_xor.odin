package instructions

import "core:log"
import _cpu "../"
import op "../operands"

@(private)
getU8Operand :: proc(operand: op.Operand) -> u8

XOR :: proc(cpu: ^_cpu.Cpu, instruction: Instruction) {
  _cpu.incrementPC(cpu)

  operand := instruction.left(cpu)
  mask := op.operandIsU8(operand)

  cpu.registers.a ~= mask

  _cpu.setFlagZ(cpu, cpu.registers.a == 0)
  _cpu.setFlagN(cpu, false)
  _cpu.setFlagH(cpu, false)
  _cpu.setFlagC(cpu, false)
}
