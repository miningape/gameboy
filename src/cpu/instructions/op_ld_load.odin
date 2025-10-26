package instructions

import "../"
import op "../operands"
import "../../bus"

LD_ptr :: proc(c: ^cpu.Cpu, pointer: Pointer, source: proc(c: ^cpu.Cpu) -> op.Operand) {
  location := op.operandIsU16(pointer.to(c))
  data := op.operandIsU8(source(c))

  bus.write(c.bus, location, data)
}

LD_register :: proc(c: ^cpu.Cpu, 
                    destination: proc(c: ^cpu.Cpu) -> op.Operand, 
                    source: proc(c: ^cpu.Cpu) -> op.Operand) {
  register := destination(c).(op.Register)
  data := source(c)

  op.intoRegister(register, data)
}

LD :: proc(c: ^cpu.Cpu, i: Instruction) {
  switch left in i.left {
    case Pointer:
      LD_ptr(c, left, i.right)

    case proc(c: ^cpu.Cpu) -> op.Operand:
      LD_register(c, left, i.right)
  }

  // LD never affects flags
}