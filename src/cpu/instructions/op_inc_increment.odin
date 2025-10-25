package instructions

import "core:os"
import "../"
import "../operands"
import "../../bus"


// Might be easier to just do bitshifting since it automatically accounts for endianess
SharedMem :: struct #raw_union {
  shared: u16,
  split: [2]u8
}

INC_register :: proc(register: operands.Register) {
  switch reg in register {
    case ^cpu.Register:
      reg^ += 1

    case ^cpu.Register16:
      reg^ += 1

    case [2]^cpu.Register:
      mem: SharedMem = {
        split = ({ reg[1]^, reg[0]^ }) when os.ENDIAN == .Little else ({reg[0]^, reg[1]^})
      }

      mem.shared += 1

      when os.ENDIAN == .Little {
        reg[0]^ = mem.split[1]
        reg[1]^ = mem.split[0]
      } else {
        reg[0]^ = mem.split[0]
        reg[1]^ = mem.split[1]
      }
  }
}

INC_pointer :: proc(c: ^cpu.Cpu, pointer: Pointer) {
  location := operands.operandIsU16(pointer.to(c))
  bus.increment(c.bus, location)
}

INC :: proc(c: ^cpu.Cpu, instruction: Instruction) {
  switch op in instruction.left {
    case Pointer:
      INC_pointer(c, op)

    case proc(c: ^cpu.Cpu) -> operands.Operand:
      register := op(c).(operands.Register)
      INC_register(register)
    }
}
