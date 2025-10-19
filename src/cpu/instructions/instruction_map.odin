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

nextByte :: proc(c: ^cpu.Cpu) -> Operand {
  cpu.incrementPC(c)
  return bus.read(c.bus, c.registers.pc)
}

next2Bytes :: proc(c: ^cpu.Cpu) -> Operand {
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
       //  0                          1                        2                          3                      4                      5                      6                      7                      8                      9                      A                      B                      C                      D                      E                      F
  /* 0 */ NOOP,                     {LD, intoBC, next2Bytes}, {LD, intoRamBC, valueInA}, NOOP,                  NOOP,                  NOOP,                  {LD, intoB, nextByte}, NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  {LD, intoC, nextByte}, NOOP,
  /* 1 */ NOOP,                     {LD, intoDE, next2Bytes}, NOOP,                      NOOP,                  NOOP,                  NOOP,                  {LD, intoD, nextByte}, NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  {LD, intoE, nextByte}, NOOP, 
  /* 2 */ NOOP,                     {LD, intoHL, next2Bytes}, NOOP,                      NOOP,                  NOOP,                  NOOP,                  {LD, intoH, nextByte}, NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  {LD, intoL, nextByte}, NOOP, 
  /* 3 */ NOOP,                     {LD, intoSP, next2Bytes}, NOOP,                      NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  {LD, intoA, nextByte}, NOOP, 
  /* 4 */ {LD, intoB,  valueInB},   {LD, intoB,  valueInC},   {LD, intoB, valueInD},     {LD, intoB, valueInE}, {LD, intoB, valueInH}, {LD, intoB, valueInL}, NOOP,                  {LD, intoB, valueInA}, {LD, intoC, valueInB}, {LD, intoC, valueInC}, {LD, intoC, valueInD}, {LD, intoC, valueInE}, {LD, intoC, valueInH}, {LD, intoC, valueInL}, NOOP,                  {LD, intoC, valueInA}, 
  /* 5 */ {LD, intoD,  valueInB},   {LD, intoD,  valueInC},   {LD, intoD, valueInD},     {LD, intoD, valueInE}, {LD, intoD, valueInH}, {LD, intoD, valueInL}, NOOP,                  {LD, intoD, valueInA}, {LD, intoE, valueInB}, {LD, intoE, valueInC}, {LD, intoE, valueInD}, {LD, intoE, valueInE}, {LD, intoE, valueInH}, {LD, intoE, valueInL}, NOOP,                  {LD, intoE, valueInA}, 
  /* 6 */ {LD, intoH,  valueInB},   {LD, intoH,  valueInC},   {LD, intoH, valueInD},     {LD, intoH, valueInE}, {LD, intoH, valueInH}, {LD, intoH, valueInL}, NOOP,                  {LD, intoH, valueInA}, {LD, intoL, valueInB}, {LD, intoL, valueInC}, {LD, intoL, valueInD}, {LD, intoL, valueInE}, {LD, intoL, valueInH}, {LD, intoL, valueInL}, NOOP,                  {LD, intoL, valueInA}, 
  /* 7 */ NOOP,                     NOOP,                     NOOP,                      NOOP,                  NOOP,                  NOOP,                  {HALT, nil, nil},      NOOP,                  {LD, intoA, valueInB}, {LD, intoA, valueInC}, {LD, intoA, valueInD}, {LD, intoA, valueInE}, {LD, intoA, valueInH}, {LD, intoA, valueInL}, NOOP,                  {LD, intoA, valueInA}, 
  /* 8 */ NOOP,                     NOOP,                     NOOP,                      NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP, 
  /* 9 */ NOOP,                     NOOP,                     NOOP,                      NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP, 
  /* A */ NOOP,                     NOOP,                     NOOP,                      NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP, 
  /* B */ NOOP,                     NOOP,                     NOOP,                      NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP, 
  /* C */ NOOP,                     NOOP,                     NOOP,                      NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP, 
  /* D */ NOOP,                     NOOP,                     NOOP,                      NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP, 
  /* E */ NOOP,                     NOOP,                     NOOP,                      NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP, 
  /* F */ NOOP,                     NOOP,                     NOOP,                      NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP, 
}



// {
//   {NOP, nil, nil}, {LD, intoBC, next2Bytes}
// }

