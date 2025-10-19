package instructions

import "core:fmt"

import "../"
import "../../bus"

Operand :: union {
  u16,
  byte,
  proc(c: ^cpu.Cpu, o: Operand)
}

Instruction :: struct {
  operation: proc(c: ^cpu.Cpu, i: Instruction),
  left: proc(c: ^cpu.Cpu) -> Operand,
  right: proc(c: ^cpu.Cpu) -> Operand
}

intoBC_ :: proc(c: ^cpu.Cpu, o: Operand) {
  data := o.(u16)

  c.registers.b = u8(data >> 8)
  c.registers.c = u8(data)
}

intoBC :: proc(c: ^cpu.Cpu) -> Operand {
  return intoBC_
}

next2Bytes :: proc(c: ^cpu.Cpu) -> Operand {
  left := bus.read(c.bus, c.registers.pc + 1)
  right := bus.read(c.bus, c.registers.pc + 2)
  
  cpu.incrementPC(c)
  cpu.incrementPC(c)

  return  u16(right) | u16(left) << 8
}

HALT :: proc(c: ^cpu.Cpu, i: Instruction) {
  fmt.printfln("Halted")
  c.done = true
}

MAPPING := [0x100]Instruction{
  0x00 = {NOP, nil, nil}, 0x01 = {LD, intoBC, next2Bytes},
  0x76 = {HALT, nil, nil}
}



// {
//   {NOP, nil, nil}, {LD, intoBC, next2Bytes}
// }

