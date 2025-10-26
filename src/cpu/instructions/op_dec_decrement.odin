package instructions

import "../"
import "../operands"
import "../../bus"

DEC_register :: proc(register: operands.Register) -> u16 {
  switch reg in register {
    case ^cpu.Register:
      reg^ -= 1
      return u16(reg^)

    case ^cpu.Register16:
      reg^ -= 1
      return reg^

    case [2]^cpu.Register:
      r := toComboRegister(reg)

      r.shared -= 1

      reg[0]^, reg[1]^ = fromComboRegister(r)

      return r.shared
  }

  panic("DEC - Unknown register kind")
}

DEC_pointer :: proc(c: ^cpu.Cpu, pointer: Pointer) -> u16 {
  location := operands.operandIsU16(pointer.to(c))
  return u16(bus.decrement(c.bus, location))
}

DEC :: proc(c: ^cpu.Cpu, instruction: Instruction) {
  result: u16

  switch op in instruction.left {
    case Pointer:
      result = DEC_pointer(c, op)

    case proc(c: ^cpu.Cpu) -> operands.Operand:
      register := op(c).(operands.Register)
      result = DEC_register(register)
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
