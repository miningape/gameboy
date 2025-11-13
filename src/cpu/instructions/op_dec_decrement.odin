package instructions

import "../"
import op "../operands"

@(private)
DEC_register :: proc(register: op.Register) -> (bool, u8) {
  switch reg in register {
    case ^cpu.Register:
      reg^ -= 1
      return true, reg^

    case ^cpu.Register16:
      reg^ -= 1
      return false, 0

    case [2]^cpu.Register:
      r := toComboRegister(reg)
      r.shared -= 1
      reg[0]^, reg[1]^ = fromComboRegister(r)

      return false, 0
  }

  panic("DEC - Unknown register kind")
}

DEC :: proc(c: ^cpu.Cpu, instruction: Instruction) {
  cpu.incrementPC(c)
  
  result: u8
  isU8Operation: bool
  
  switch operand in instruction.left(c) {
    case op.Register:
      isU8Operation, result = DEC_register(operand)

    case op.Pointer:
      operand^ -= 1

      result = operand^
      isU8Operation = true

    case u8:
      panic("Cannot DEC a u8")
      
    case u16:
      panic("Cannot DEC a u16")
  }

  if (!isU8Operation) {
    return
  }

  if (instruction.flags.z) {
    cpu.setFlagZ(c, result == 0)
  }

  if (instruction.flags.n) {
    cpu.setFlagN(c, true)
  }

  if (instruction.flags.h) {
    cpu.setFlagH(c, (result + 1) & 0xF0 == 0xF0)
  }
}
