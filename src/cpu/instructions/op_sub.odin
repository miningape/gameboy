package instructions

import "../"
import "../operands"

SUB :: proc(c: ^cpu.Cpu, instruction: Instruction) {
  cpu.incrementPC(c)

  // SUB is always performed with the A register as its left operand - we don't need to include it, but we do for readability / consistency
  aRegister := instruction.left(c).(operands.Register).(^cpu.Register)

  value := aRegister^
  operand := operands.operandIsU8(instruction.right(c))

  aRegister^ = value - operand

  cpu.setFlagZ(c, aRegister^ == 0)
  cpu.setFlagN(c, true)
  cpu.setFlagH(c, (((value & 0x0F) - (operand & 0x0F)) & 0x10) == 0x10)
  cpu.setFlagC(c, operand > value)
}
