package instructions

import "../"
import "../operands"

OR :: proc(c: ^cpu.Cpu, instruction: Instruction) {
  cpu.incrementPC(c)

  // OR is always performed with the A register as its left operand - we don't need to include it, but we do for readability / consistency
  aRegister := instruction.left(c).(operands.Register).(^cpu.Register)
  operand := operands.operandIsU8(instruction.right(c))

  aRegister^ |= operand

  cpu.setFlagZ(c, aRegister^ == 0)
  cpu.setFlagN(c, false)
  cpu.setFlagH(c, false)
  cpu.setFlagC(c, false)
}
