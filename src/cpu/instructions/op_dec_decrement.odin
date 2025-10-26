package instructions

import "../"
import "../operands"
import "../../bus"

DEC_register :: proc(register: operands.Register) {
  switch reg in register {
    case ^cpu.Register:
      reg^ -= 1

    case ^cpu.Register16:
      reg^ -= 1

    case [2]^cpu.Register:
      r := toComboRegister(reg)

      r.shared -= 1

      reg[0]^, reg[1]^ = fromComboRegister(r)
  }
}

DEC_pointer :: proc(c: ^cpu.Cpu, pointer: Pointer) {
  location := operands.operandIsU16(pointer.to(c))
  bus.decrement(c.bus, location)
}

DEC :: proc(c: ^cpu.Cpu, instruction: Instruction) {
  switch op in instruction.left {
    case Pointer:
      DEC_pointer(c, op)

    case proc(c: ^cpu.Cpu) -> operands.Operand:
      register := op(c).(operands.Register)
      DEC_register(register)
    }
}
