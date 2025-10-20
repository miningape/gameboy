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
// x02 = {LD, op.intoRamBC, valueInA}

       //  0                             1                        2                          3                      4                      5                      6                      7                      8                      9                      A                      B                      C                      D                      E                      F
  /* 0 */ NOOP,                {LD, op.BC, next2Bytes}, NOOP,                      {INC, op.BC, nil},     NOOP,                  NOOP,                  {LD, op.B, nextByte}, NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  {LD, op.C, nextByte}, NOOP,
  /* 1 */ NOOP,                {LD, op.DE, next2Bytes}, NOOP,                      {INC, op.DE, nil},     NOOP,                  NOOP,                  {LD, op.D, nextByte}, NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  {LD, op.E, nextByte}, NOOP, 
  /* 2 */ NOOP,                {LD, op.HL, next2Bytes}, NOOP,                      {INC, op.HL, nil},     NOOP,                  NOOP,                  {LD, op.H, nextByte}, NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  {LD, op.L, nextByte}, NOOP, 
  /* 3 */ NOOP,                {LD, op.SP, next2Bytes}, NOOP,                      NOOP,                  NOOP,                  NOOP,                  NOOP,                 NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  {LD, op.A, nextByte}, NOOP, 
  /* 4 */ {LD, op.B,  op.B},   {LD, op.B,  op.C},       {LD, op.B, op.D},          {LD, op.B, op.E},      {LD, op.B, op.H},      {LD, op.B, op.L},      NOOP,                 {LD, op.B, op.A},      {LD, op.C, op.B},      {LD, op.C, op.C},     {LD, op.C, op.D},       {LD, op.C, op.E},     {LD, op.C, op.H},       {LD, op.C, op.L},      NOOP,                 {LD, op.C, op.A}, 
  /* 5 */ {LD, op.D,  op.B},   {LD, op.D,  op.C},       {LD, op.D, op.D},          {LD, op.D, op.E},      {LD, op.D, op.H},      {LD, op.D, op.L},      NOOP,                 {LD, op.D, op.A},      {LD, op.E, op.B},      {LD, op.E, op.C},     {LD, op.E, op.D},       {LD, op.E, op.E},     {LD, op.E, op.H},       {LD, op.E, op.L},      NOOP,                 {LD, op.E, op.A}, 
  /* 6 */ {LD, op.H,  op.B},   {LD, op.H,  op.C},       {LD, op.H, op.D},          {LD, op.H, op.E},      {LD, op.H, op.H},      {LD, op.H, op.L},      NOOP,                 {LD, op.H, op.A},      {LD, op.L, op.B},      {LD, op.L, op.C},     {LD, op.L, op.D},       {LD, op.L, op.E},     {LD, op.L, op.H},       {LD, op.L, op.L},      NOOP,                 {LD, op.L, op.A}, 
  /* 7 */ NOOP,                NOOP,                    NOOP,                      NOOP,                  NOOP,                  NOOP,                  {HALT, nil, nil},     NOOP,                  {LD, op.A, op.B},      {LD, op.A, op.C},     {LD, op.A, op.D},       {LD, op.A, op.E},     {LD, op.A, op.H},       {LD, op.A, op.L},      NOOP,                 {LD, op.A, op.A}, 
  /* 8 */ NOOP,                NOOP,                    NOOP,                      NOOP,                  NOOP,                  NOOP,                  NOOP,                 NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                 NOOP, 
  /* 9 */ NOOP,                NOOP,                    NOOP,                      NOOP,                  NOOP,                  NOOP,                  NOOP,                 NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                 NOOP, 
  /* A */ NOOP,                NOOP,                    NOOP,                      NOOP,                  NOOP,                  NOOP,                  NOOP,                 NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                 NOOP, 
  /* B */ NOOP,                NOOP,                    NOOP,                      NOOP,                  NOOP,                  NOOP,                  NOOP,                 NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                 NOOP, 
  /* C */ NOOP,                NOOP,                    NOOP,                      NOOP,                  NOOP,                  NOOP,                  NOOP,                 NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                 NOOP, 
  /* D */ NOOP,                NOOP,                    NOOP,                      NOOP,                  NOOP,                  NOOP,                  NOOP,                 NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                 NOOP, 
  /* E */ NOOP,                NOOP,                    NOOP,                      NOOP,                  NOOP,                  NOOP,                  NOOP,                 NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                 NOOP, 
  /* F */ NOOP,                NOOP,                    NOOP,                      NOOP,                  NOOP,                  NOOP,                  NOOP,                 NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                  NOOP,                 NOOP, 
}



// {
//   {NOP, nil, nil}, {LD, intoBC, next2Bytes}
// }

