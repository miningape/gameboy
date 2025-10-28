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

LDI :: proc(c: ^cpu.Cpu, instruction: Instruction) {
  switch left in instruction.left(c) {
    case op.Register:
      pointer := instruction.right(c).(op.Pointer)
      op.intoRegister(left, pointer)
      pointer^ += 1

    case op.Pointer:
      left^ = op.operandIsU8(instruction.right(c))
      left^ += 1
    
    case u8:
      panic("Cannot LDI into u8")

    case u16:
      panic("Cannot LDI into u16")
  }

  // LDI never affects flags
}

LDD :: proc(c: ^cpu.Cpu, instruction: Instruction) {
  switch left in instruction.left(c) {
    case op.Register:
      pointer := instruction.right(c).(op.Pointer)
      op.intoRegister(left, pointer)
      pointer^ -= 1

    case op.Pointer:
      left^ = op.operandIsU8(instruction.right(c))
      left^ -= 1
    
    case u8:
      panic("Cannot LDI into u8")

    case u16:
      panic("Cannot LDI into u16")
  }

  // LDD never affects flags
}
