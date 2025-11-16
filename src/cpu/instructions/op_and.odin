package instructions 

import "../"
import "../operands"

AND :: proc(c: ^cpu.Cpu, instruction: Instruction) {
  cpu.incrementPC(c)

  // AND is always performed with the A register as its left operand - we don't need to include it, but we do for readability / consistency
  aRegister := instruction.left(c).(operands.Register).(^cpu.Register)
  operand := operands.operandIsU8(instruction.right(c))

  aRegister^ &= operand

  cpu.setFlagZ(c, aRegister^ == 0)
  cpu.setFlagN(c, false)
  cpu.setFlagH(c, true)
  cpu.setFlagC(c, false)
}
