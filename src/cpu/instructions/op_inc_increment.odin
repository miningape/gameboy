package instructions

import "core:os"
import "../"
import "../operands"
import "../../bus"


// Might be easier to just do bitshifting since it automatically accounts for endianess - see cpu.split / .unify
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
INC_register :: proc(register: operands.Register) -> (bool, u8) {
  switch reg in register {
    case ^cpu.Register:
      reg^ += 1
      return true, reg^

    case ^cpu.Register16:
      reg^ += 1
      return false, 0

    case [2]^cpu.Register:
      r := toComboRegister(reg)
      r.shared += 1
      reg[0]^, reg[1]^ = fromComboRegister(r)

      return false, 0
  }

  panic("INC - unrecognized register")
}

INC :: proc(c: ^cpu.Cpu, instruction: Instruction) {
  cpu.incrementPC(c)

  value: u8
  isU8Operation: bool

  switch operand in instruction.left(c) {
    case operands.Register:
      isU8Operation, value = INC_register(operand)

    case operands.Pointer:
      operand^ += 1

      isU8Operation = true
      value = operand^

    case operands.Literal:
      switch literal in operand {
        case u8:
          panic("Tried to increment u8")
    
        case u16:
          panic("Tried to increment u16")

        case bool:
          panic("Tried to increment boolean")
      }
  }

  if (!isU8Operation) {
    return
  }

  if (instruction.flags.z) {
    cpu.setFlagZ(c, value == 0)
  }

  if (instruction.flags.n) {
    cpu.setFlagN(c, false)
  }

  if (instruction.flags.h) {
    cpu.setFlagH(c, (value - 1) & 0x0F == 0x0F)
  }
}
