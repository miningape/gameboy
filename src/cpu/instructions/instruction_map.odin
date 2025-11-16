package instructions

import "core:log"

import "../"
import op "../operands"
import "../../bus"

Flags :: struct {
  z: bool,
  n: bool,
  h: bool,
  c: bool
}

Instruction :: struct {
  operation: proc(c: ^cpu.Cpu, i: Instruction),
  left: proc(c: ^cpu.Cpu) -> op.Operand,
  right: proc(c: ^cpu.Cpu) -> op.Operand,
  flags: Flags
}

nextByte :: proc(c: ^cpu.Cpu) -> op.Operand {
  value := bus.read(c.bus, c.registers.pc)
  cpu.incrementPC(c)

  return op.Literal(value)
}

next2Bytes :: proc(c: ^cpu.Cpu) -> op.Operand {
  lower := bus.read(c.bus, c.registers.pc)
  cpu.incrementPC(c)
  upper := bus.read(c.bus, c.registers.pc)
  cpu.incrementPC(c)

  return  op.Literal(u16(lower) | u16(upper) << 8)
}

Z :: proc(c: ^cpu.Cpu) -> op.Operand {
  return cpu.getFlagZ(c) == true
}

NZ :: proc(c: ^cpu.Cpu) -> op.Operand {
  return cpu.getFlagZ(c) == false
}

C :: proc(c: ^cpu.Cpu) -> op.Operand {
  return cpu.getFlagC(c) == true
}

NC :: proc(c: ^cpu.Cpu) -> op.Operand {
  return cpu.getFlagC(c) == false
}

HALT :: proc(c: ^cpu.Cpu, i: Instruction) {
  log.debug("Halted")
  c.done = true
}

F_NO : Flags : {false, false, false, false}
F_ZNH : Flags : {true, true, true, false}
F_ALL : Flags : {true, true, true, true}

NOOP: Instruction = {NOP, nil, nil, F_NO}
MAPPING :: proc() -> [0x100]Instruction {
  return {
        //  0                                   1                             2                                3                           4                                 5                                    6                                  7                       8                              9                      A                                 B                        C                          D                        E                          F
    /* 0 */ NOOP,                        {LD, op.BC, next2Bytes, F_NO}, {LD, op.BC_ptr, op.A, F_NO},  {INC, op.BC, nil, F_NO},      {INC, op.B, nil, F_ZNH},            {DEC, op.B, nil, F_ZNH},            {LD, op.B, nextByte, F_NO},      NOOP,                        NOOP,                          NOOP,                    {LD, op.A, op.BC_ptr, F_NO},  {DEC, op.BC, nil, F_NO}, {INC, op.C, nil, F_ZNH}, {DEC, op.C, nil, F_ZNH}, {LD, op.C, nextByte, F_NO},   NOOP,
    /* 1 */ NOOP,                        {LD, op.DE, next2Bytes, F_NO}, {LD, op.DE_ptr, op.A, F_NO},  {INC, op.DE, nil, F_NO},      {INC, op.D, nil, F_ZNH},            {DEC, op.D, nil, F_ZNH},            {LD, op.D, nextByte, F_NO},      NOOP,                        {JR, nextByte, nil, F_NO},     NOOP,                    {LD, op.A, op.DE_ptr, F_NO},  {DEC, op.DE, nil, F_NO}, {INC, op.E, nil, F_ZNH}, {DEC, op.E, nil, F_ZNH}, {LD, op.E, nextByte, F_NO},   NOOP, 
    /* 2 */ {JR, NZ, nextByte, F_NO},    {LD, op.HL, next2Bytes, F_NO}, {LDI, op.HL, op.A, F_NO},     {INC, op.HL, nil, F_NO},      {INC, op.H, nil, F_ZNH},            {DEC, op.H, nil, F_ZNH},            {LD, op.H, nextByte, F_NO},      NOOP,                        {JR, Z, nextByte, F_NO},       NOOP,                    {LDI, op.A, op.HL, F_NO},     {DEC, op.HL, nil, F_NO}, {INC, op.L, nil, F_ZNH}, {DEC, op.L, nil, F_ZNH}, {LD, op.L, nextByte, F_NO},   NOOP, 
    /* 3 */ {JR, NC, nextByte, F_NO},    {LD, op.SP, next2Bytes, F_NO}, {LDD, op.HL, op.A, F_NO},     {INC, op.SP, nil, F_NO},      {INC, op.HL_ptr, nil, F_ZNH},       {DEC, op.HL_ptr, nil, F_ZNH},       {LD, op.HL_ptr, nextByte, F_NO}, NOOP,                        {JR, C, nextByte, F_NO},       NOOP,                    {LDD, op.A, op.HL, F_NO},     {DEC, op.SP, nil, F_NO}, {INC, op.A, nil, F_ZNH}, {DEC, op.A, nil, F_ZNH}, {LD, op.A, nextByte, F_NO},   NOOP, 
    /* 5 */ {LD, op.D,  op.B, F_NO},     {LD, op.D,  op.C, F_NO},       {LD, op.D, op.D, F_NO},       {LD, op.D, op.E, F_NO},       {LD, op.D, op.H, F_NO},             {LD, op.D, op.L, F_NO},             {LD, op.B, op.HL_ptr, F_NO},     {LD, op.D, op.A, F_NO},      {LD, op.E, op.B, F_NO},        {LD, op.E, op.C, F_NO},  {LD, op.E, op.D, F_NO},       {LD, op.E, op.E, F_NO},  {LD, op.E, op.H, F_NO},  {LD, op.E, op.L, F_NO},  {LD, op.C, op.HL_ptr, F_NO},  {LD, op.E, op.A, F_NO}, 
    /* 4 */ {LD, op.B,  op.B, F_NO},     {LD, op.B,  op.C, F_NO},       {LD, op.B, op.D, F_NO},       {LD, op.B, op.E, F_NO},       {LD, op.B, op.H, F_NO},             {LD, op.B, op.L, F_NO},             {LD, op.D, op.HL_ptr, F_NO},     {LD, op.B, op.A, F_NO},      {LD, op.C, op.B, F_NO},        {LD, op.C, op.C, F_NO},  {LD, op.C, op.D, F_NO},       {LD, op.C, op.E, F_NO},  {LD, op.C, op.H, F_NO},  {LD, op.C, op.L, F_NO},  {LD, op.E, op.HL_ptr, F_NO},  {LD, op.C, op.A, F_NO}, 
    /* 6 */ {LD, op.H,  op.B, F_NO},     {LD, op.H,  op.C, F_NO},       {LD, op.H, op.D, F_NO},       {LD, op.H, op.E, F_NO},       {LD, op.H, op.H, F_NO},             {LD, op.H, op.L, F_NO},             {LD, op.H, op.HL_ptr, F_NO},     {LD, op.H, op.A, F_NO},      {LD, op.L, op.B, F_NO},        {LD, op.L, op.C, F_NO},  {LD, op.L, op.D, F_NO},       {LD, op.L, op.E, F_NO},  {LD, op.L, op.H, F_NO},  {LD, op.L, op.L, F_NO},  {LD, op.L, op.HL_ptr, F_NO},  {LD, op.L, op.A, F_NO}, 
    /* 7 */ {LD, op.HL_ptr, op.B, F_NO}, {LD, op.HL_ptr, op.C, F_NO},   {LD, op.HL_ptr, op.D, F_NO},  {LD, op.HL_ptr, op.E, F_NO},  {LD, op.HL_ptr, op.H, F_NO},        {LD, op.HL_ptr, op.L, F_NO},        {HALT, nil, nil, F_NO},          {LD, op.HL_ptr, op.A, F_NO}, {LD, op.A, op.B, F_NO},        {LD, op.A, op.C, F_NO},  {LD, op.A, op.D, F_NO},       {LD, op.A, op.E, F_NO},  {LD, op.A, op.H, F_NO},  {LD, op.A, op.L, F_NO},  {LD, op.A, op.HL_ptr, F_NO},  {LD, op.A, op.A, F_NO}, 
    /* 8 */ {ADD, op.A, op.B, F_ALL},    {ADD, op.A, op.C, F_ALL},      {ADD, op.A, op.D, F_ALL},     {ADD, op.A, op.E, F_ALL},     {ADD, op.A, op.H, F_ALL},           {ADD, op.A, op.L, F_ALL},           {ADD, op.A, op.HL_ptr, F_ALL},   {ADD, op.A, op.A, F_ALL},    NOOP,                          NOOP,                    NOOP,                         NOOP,                    NOOP,                    NOOP,                    NOOP,                         NOOP, 
    /* 9 */ {SUB, op.A, op.B, F_ALL},    {SUB, op.A, op.C, F_ALL},      {SUB, op.A, op.D, F_ALL},     {SUB, op.A, op.E, F_ALL},     {SUB, op.A, op.H, F_ALL},           {SUB, op.A, op.L, F_ALL},           {SUB, op.A, op.HL_ptr, F_ALL},   {SUB, op.A, op.A, F_ALL},    NOOP,                          NOOP,                    NOOP,                         NOOP,                    NOOP,                    NOOP,                    NOOP,                         NOOP, 
    /* A */ {AND, op.A, op.B, F_ALL},    {AND, op.A, op.C, F_ALL},      {AND, op.A, op.D, F_ALL},     {AND, op.A, op.E, F_ALL},     {AND, op.A, op.H, F_ALL},           {AND, op.A, op.L, F_ALL},           {AND, op.A, op.HL_ptr, F_ALL},   {AND, op.A, op.A, F_ALL},    {XOR, op.B, nil, F_ALL},       {XOR, op.C, nil, F_ALL}, {XOR, op.D, nil, F_ALL},      {XOR, op.E, nil, F_ALL}, {XOR, op.H, nil, F_ALL}, {XOR, op.L, nil, F_ALL}, {XOR, op.HL_ptr, nil, F_ALL}, {XOR, op.A, nil, F_ALL}, 
    /* B */ {OR, op.A, op.B, F_ALL},     {OR, op.A, op.C, F_ALL},       {OR, op.A, op.D, F_ALL},      {OR, op.A, op.E, F_ALL},      {OR, op.A, op.H, F_ALL},            {OR, op.A, op.L, F_ALL},            {OR, op.A, op.HL_ptr, F_ALL},    {OR, op.A, op.A, F_ALL},     NOOP,                          NOOP,                    NOOP,                         NOOP,                    NOOP,                    NOOP,                    NOOP,                         NOOP, 
    /* C */ NOOP,                        NOOP,                          {JP, NZ, next2Bytes, F_NO},   {JP, next2Bytes, nil, F_NO},  NOOP,                               NOOP,                               {ADD, op.A, nextByte, F_ALL},    NOOP,                        NOOP,                          NOOP,                    {JP, Z, next2Bytes, F_NO},    NOOP,                    NOOP,                    NOOP,                    NOOP,                         NOOP, 
    /* D */ NOOP,                        NOOP,                          {JP, NC, next2Bytes, F_NO},   NOOP,                         NOOP,                               NOOP,                               {SUB, op.A, nextByte, F_ALL},    NOOP,                        NOOP,                          NOOP,                    {JP, C, next2Bytes, F_NO},    NOOP,                    NOOP,                    NOOP,                    NOOP,                         NOOP, 
    /* E */ NOOP,                        NOOP,                          NOOP,                         NOOP,                         NOOP,                               NOOP,                               {AND, op.A, nextByte, F_ALL},    NOOP,                        {ADD, op.SP, nextByte, F_ALL}, {JP, op.HL, nil, F_NO},  NOOP,                         NOOP,                    NOOP,                    NOOP,                    {XOR, nextByte, nil, F_ALL},  NOOP, 
    /* F */ NOOP,                        NOOP,                          NOOP,                         NOOP,                         NOOP,                               NOOP,                               {OR, op.A, nextByte, F_ALL},     NOOP,                        NOOP,                          NOOP,                    NOOP,                         NOOP,                    NOOP,                    NOOP,                    NOOP,                         NOOP, 
  }
}
