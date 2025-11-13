package instructions

import "../"
import op "../operands"

LD :: proc(c: ^cpu.Cpu, i: Instruction) {
  cpu.incrementPC(c)

  data := i.right(c)

  switch left in i.left(c) {
    case op.Pointer:
      left^ = op.operandIsU8(data)

    case op.Register:
      op.intoRegister(left, data)

    case op.Literal:
      switch literal in left {
        case u8:
          panic("Cannot LD into u8")
    
        case u16:
          panic("Cannot LD into u16")

        case bool:
          panic("Cannot LD into boolean")
      }
  }

  // LD never affects flags
}

LDI :: proc(c: ^cpu.Cpu, instruction: Instruction) {
  cpu.incrementPC(c)

  switch left in instruction.left(c) {
    case op.Register:
      pointer := instruction.right(c).(op.Pointer)
      op.intoRegister(left, pointer)
      pointer^ += 1

    case op.Pointer:
      left^ = op.operandIsU8(instruction.right(c))
      left^ += 1
    
    case op.Literal:
      switch literal in left {
        case u8:
          panic("Cannot LDI into u8")
    
        case u16:
          panic("Cannot LDI into u16")

        case bool:
          panic("Cannot LDI into boolean")
      }
  }

  // LDI never affects flags
}

LDD :: proc(c: ^cpu.Cpu, instruction: Instruction) {
  cpu.incrementPC(c)

  switch left in instruction.left(c) {
    case op.Register:
      pointer := instruction.right(c).(op.Pointer)
      op.intoRegister(left, pointer)
      pointer^ -= 1

    case op.Pointer:
      left^ = op.operandIsU8(instruction.right(c))
      left^ -= 1
    
    case op.Literal:
      switch literal in left {
        case u8:
          panic("Cannot LDD into u8")
    
        case u16:
          panic("Cannot LDD into u16")

        case bool:
          panic("Cannot LDD into boolean")
      }
  }

  // LDD never affects flags
}
