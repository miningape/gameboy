package instructions

import "core:os"
import "../"
import "../operands"
import "../../bus"


// Might be easier to just do bitshifting since it automatically accounts for endianess
// Platform endian safe merging of registers
ComboRegister :: struct #raw_union {
  shared: u16,
  split: [2]u8
}

toComboRegister :: proc(registers: [2]^cpu.Register) -> ComboRegister {
  return {
    split = ({ registers[1]^, registers[0]^ }) when 
                os.ENDIAN == .Little else 
            ({reg[0]^, reg[1]^})
  }
}

fromComboRegister :: proc(register: ComboRegister) -> (u8, u8) {
  when os.ENDIAN == .Little {
    return register.split[1], register.split[0]
  } else {
    return register.split[0], register.split[1]
  }
}

@(private)
INC_register :: proc(register: operands.Register) -> u16 {
  switch reg in register {
    case ^cpu.Register:
      reg^ += 1
      return u16(reg^)

    case ^cpu.Register16:
      reg^ += 1
      return reg^

    case [2]^cpu.Register:
      r := toComboRegister(reg)

      r.shared += 1

      reg[0]^, reg[1]^ = fromComboRegister(r)

      return r.shared
  }

  panic("INC - Unknown register kind")
}

@(private)
INC_pointer :: proc(c: ^cpu.Cpu, pointer: Pointer) -> u16 {
  location := operands.operandIsU16(pointer.to(c))
  return u16(bus.increment(c.bus, location))
}

INC :: proc(c: ^cpu.Cpu, instruction: Instruction) {
  result: u16

  switch op in instruction.left {
    case Pointer:
      result = INC_pointer(c, op)

    case proc(c: ^cpu.Cpu) -> operands.Operand:
      register := op(c).(operands.Register)
      result = INC_register(register)
  }

  if (instruction.flags.z) {
    cpu.setFlagZ(c, result == 0)
  }

  if (instruction.flags.n) {
    cpu.setFlagN(c, false)
  }

  if (instruction.flags.h) {
    cpu.setFlagH(c, (result - 1) & 0x0F == 0x0F)
  }
}
