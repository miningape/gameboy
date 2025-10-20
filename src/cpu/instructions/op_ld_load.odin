package instructions

import "../"
import "../operands"

LD :: proc(c: ^cpu.Cpu, i: Instruction) {
  register := i.left(c).(operands.Register)
  data := i.right(c)

  operands.intoRegister(register, data)
}