package instructions

import "../"
import op "../operands"

LD :: proc(c: ^cpu.Cpu, i: Instruction) {
  data := i.right(c)

  switch left in i.left(c) {
    case op.Pointer:
      left^ = op.operandIsU8(data)

    case op.Register:
      op.intoRegister(left, data)

    case u8:
      panic("Cannot LD into u8")

    case u16:
      panic("Cannot LD into u16")
  }

  // LD never affects flags
}