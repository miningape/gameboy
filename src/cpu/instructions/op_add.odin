package instructions

import "core:log"
import "core:flags"
import "core:fmt"

import "../"
import "../operands"

@(private)
setFlagZ :: proc (c: ^cpu.Cpu, flags: Flags, z: bool) {
  if (flags.z) {
    cpu.setFlagZ(c, z)
  }
}

@(private)
setFlagN :: proc (c: ^cpu.Cpu, flags: Flags, n: bool) {
  if (flags.n) {
    cpu.setFlagN(c, n)
  }
}

@(private)
setFlagH :: proc (c: ^cpu.Cpu, flags: Flags, h: bool) {
  if (flags.h) {
    cpu.setFlagH(c, h)
  }
}

@(private)
setFlagC :: proc (c_: ^cpu.Cpu, flags: Flags, c: bool) {
  if (flags.c) {
    cpu.setFlagC(c_, c)
  }
}

ADD :: proc(c: ^cpu.Cpu, instruction: Instruction) {
  reg := instruction.left(c).(operands.Register)
  data := instruction.right(c)

  setFlagN(c, instruction.flags, false)

  switch register in reg {
    case ^cpu.Register:
      d := operands.operandIsU8(data)
      value := register^

      register^ = value + d

      setFlagZ(c, instruction.flags, register^ == 0)
      setFlagC(c, instruction.flags, value > 0xFF - d)
      setFlagH(c, instruction.flags, (((value & 0x0F) + (d & 0x0F)) & 0x10) == 0x10)

    case ^cpu.Register16:
      d := operands.operandIsU8(data)
      _, lower := cpu.split(register^)


      // We calculate the carry and half carry using regular addition since this is how twos complement and the gameboy ALU work
      carry := lower > 0xFF - d
      halfCarry := (((lower & 0x0F) + (d & 0x0F)) & 0x10) == 0x10
    
      // first we convert u8 op to i8 - this preserves the sign
      // then we since we want to add to a u16 we need to first convert to a shared (signed) type
      // for this we upcast to i32 - since it allows all values stored by u16
      // converting i8 to i32 preserves the sign
      // We add the i32s then downcast to u16 since we don't care about the overflow
      register^ = u16(i32(register^) + i32(i8(d)))
      
      setFlagZ(c, instruction.flags, false)
      setFlagH(c, instruction.flags, halfCarry)
      setFlagC(c, instruction.flags, carry)

    case [2]^cpu.Register:
      d := operands.operandIsU16(data)
      r := toComboRegister(register)
      value := r.shared
      
      r.shared = value + d

      register[0]^, register[1]^ = fromComboRegister(r)

      setFlagH(c, instruction.flags, (((value & 0xFFF) + (value & 0xFFF)) & 0x1000) == 0x1000)
      setFlagC(c, instruction.flags, value > 0xFFFF - d)
    }
}