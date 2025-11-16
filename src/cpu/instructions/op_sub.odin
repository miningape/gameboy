package instructions

import "../"
import "../operands"

@(private="file")
SUB_actual :: proc(c: ^cpu.Cpu, instruction: Instruction) -> (^u8, u8) {
  cpu.incrementPC(c)

  // SUB is always performed with the A register as its left operand - we don't need to include it, but we do for readability / consistency
  aRegister := instruction.left(c).(operands.Register).(^cpu.Register)

  left := aRegister^
  right := operands.operandIsU8(instruction.right(c))

  result := left - right

  cpu.setFlagZ(c, result == 0)
  cpu.setFlagN(c, true)
  cpu.setFlagH(c, (((left & 0x0F) - (right & 0x0F)) & 0x10) == 0x10)
  cpu.setFlagC(c, right > left)

  return aRegister, result
}

SUB :: proc(c: ^cpu.Cpu, instruction: Instruction) {
  register, result := SUB_actual(c, instruction)

  // In the SUB instruction we store the result in the A register
  register^ = result
}

// CoMpare
CP :: proc(c: ^cpu.Cpu, instruction: Instruction) {
  // In the CP instruction we only set the flags, but don't store the result
  SUB_actual(c, instruction)
}
