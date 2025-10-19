package instructions

import "core:fmt"

import "../"
import op "../operands"
import "../../bus"

Instruction :: struct {
  operation: proc(c: ^cpu.Cpu, i: Instruction),
  left: proc(c: ^cpu.Cpu) -> op.Operand,
  right: proc(c: ^cpu.Cpu) -> op.Operand
}

nextByte :: proc(c: ^cpu.Cpu) -> op.Operand {
  cpu.incrementPC(c)
  return bus.read(c.bus, c.registers.pc)
}

next2Bytes :: proc(c: ^cpu.Cpu) -> op.Operand {
  lower := bus.read(c.bus, c.registers.pc + 1)
  upper := bus.read(c.bus, c.registers.pc + 2)
  
  cpu.incrementPC(c)
  cpu.incrementPC(c)

  return  u16(lower) | u16(upper) << 8
}

HALT :: proc(c: ^cpu.Cpu, i: Instruction) {
  fmt.printfln("Halted")
  c.done = true
}

NOOP: Instruction : {NOP, nil, nil}

MAPPING := [0x100]Instruction{
       //  0                             1                        2                          3                      4                      5                      6                      7                      8                      9                      A                      B                      C                      D                      E                      F
  /* 0 */ NOOP,                        {LD, op.intoBC, next2Bytes}, {LD, op.intoRamBC, valueInA}, NOOP,                  NOOP,                  NOOP,                  {LD, op.intoB, nextByte}, NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  {LD, op.intoC, nextByte}, NOOP,
  /* 1 */ NOOP,                        {LD, op.intoDE, next2Bytes}, NOOP,                      NOOP,                  NOOP,                  NOOP,                  {LD, op.intoD, nextByte}, NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  {LD, op.intoE, nextByte}, NOOP, 
  /* 2 */ NOOP,                        {LD, op.intoHL, next2Bytes}, NOOP,                      NOOP,                  NOOP,                  NOOP,                  {LD, op.intoH, nextByte}, NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  {LD, op.intoL, nextByte}, NOOP, 
  /* 3 */ NOOP,                        {LD, op.intoSP, next2Bytes}, NOOP,                      NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  {LD, op.intoA, nextByte}, NOOP, 
  /* 4 */ {LD, op.intoB,  valueInB},   {LD, op.intoB,  valueInC},   {LD, op.intoB, valueInD},     {LD, op.intoB, valueInE}, {LD, op.intoB, valueInH}, {LD, op.intoB, valueInL}, NOOP,                  {LD, op.intoB, valueInA}, {LD, op.intoC, valueInB}, {LD, op.intoC, valueInC}, {LD, op.intoC, valueInD}, {LD, op.intoC, valueInE}, {LD, op.intoC, valueInH}, {LD, op.intoC, valueInL}, NOOP,                  {LD, op.intoC, valueInA}, 
  /* 5 */ {LD, op.intoD,  valueInB},   {LD, op.intoD,  valueInC},   {LD, op.intoD, valueInD},     {LD, op.intoD, valueInE}, {LD, op.intoD, valueInH}, {LD, op.intoD, valueInL}, NOOP,                  {LD, op.intoD, valueInA}, {LD, op.intoE, valueInB}, {LD, op.intoE, valueInC}, {LD, op.intoE, valueInD}, {LD, op.intoE, valueInE}, {LD, op.intoE, valueInH}, {LD, op.intoE, valueInL}, NOOP,                  {LD, op.intoE, valueInA}, 
  /* 6 */ {LD, op.intoH,  valueInB},   {LD, op.intoH,  valueInC},   {LD, op.intoH, valueInD},     {LD, op.intoH, valueInE}, {LD, op.intoH, valueInH}, {LD, op.intoH, valueInL}, NOOP,                  {LD, op.intoH, valueInA}, {LD, op.intoL, valueInB}, {LD, op.intoL, valueInC}, {LD, op.intoL, valueInD}, {LD, op.intoL, valueInE}, {LD, op.intoL, valueInH}, {LD, op.intoL, valueInL}, NOOP,                  {LD, op.intoL, valueInA}, 
  /* 7 */ NOOP,                        NOOP,                     NOOP,                      NOOP,                  NOOP,                  NOOP,                  {HALT, nil, nil},      NOOP,                  {LD, op.intoA, valueInB}, {LD, op.intoA, valueInC}, {LD, op.intoA, valueInD}, {LD, op.intoA, valueInE}, {LD, op.intoA, valueInH}, {LD, op.intoA, valueInL}, NOOP,                  {LD, op.intoA, valueInA}, 
  /* 8 */ NOOP,                        NOOP,                     NOOP,                      NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP, 
  /* 9 */ NOOP,                        NOOP,                     NOOP,                      NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP, 
  /* A */ NOOP,                        NOOP,                     NOOP,                      NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP, 
  /* B */ NOOP,                        NOOP,                     NOOP,                      NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP, 
  /* C */ NOOP,                        NOOP,                     NOOP,                      NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP, 
  /* D */ NOOP,                        NOOP,                     NOOP,                      NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP, 
  /* E */ NOOP,                        NOOP,                     NOOP,                      NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP, 
  /* F */ NOOP,                        NOOP,                     NOOP,                      NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP, 
}



// {
//   {NOP, nil, nil}, {LD, intoBC, next2Bytes}
// }

