package instructions

import "../"
import "../operands"

LD :: proc(c: ^cpu.Cpu, i: Instruction) {
  set := i.left(c).(proc(c: ^cpu.Cpu, o: operands.Operand))
  data := i.right(c)

  set(c, data)
}