package instructions

import "../"
import "../operands"

valueInA :: proc(c: ^cpu.Cpu) -> operands.Operand {
  return c.registers.a
}

valueInB :: proc(c: ^cpu.Cpu) -> operands.Operand {
  return c.registers.b
}

valueInC :: proc(c: ^cpu.Cpu) -> operands.Operand {
  return c.registers.c
}

valueInD :: proc(c: ^cpu.Cpu) -> operands.Operand {
  return c.registers.d
}

valueInE :: proc(c: ^cpu.Cpu) -> operands.Operand {
  return c.registers.e
}

valueInH :: proc(c: ^cpu.Cpu) -> operands.Operand {
  return c.registers.h
}

valueInL :: proc(c: ^cpu.Cpu) -> operands.Operand {
  return c.registers.l
}
