package cpu

import "core:fmt"
import "core:strings"

// CPU Registers and Flags: https://gbdev.io/pandocs/CPU_Registers_and_Flags.html
// TODO: Refactor to use enum

@(private)
setFlag :: proc(c: ^Cpu, value: bool, flagMask: byte) {
  if value {
    c.registers.f |= flagMask
  } else {
    c.registers.f &= ~flagMask
  }
}

@(private)
getFlag :: proc(c: ^Cpu, flagMask: byte) -> bool {
  return (c.registers.f & flagMask) == flagMask
}

// Zero flag - This bit is set if and only if the result of an operation is zero. Used by conditional jumps.
@(private)
zFlagMask : byte :  0b1000_0000

setFlagZ :: proc(c: ^Cpu, value: bool) {
  setFlag(c, value, zFlagMask)
}

getFlagZ :: proc(c: ^Cpu) -> bool {
  return getFlag(c, zFlagMask)
}

// Carry flag - This bit is set if we "lose" bits in an operation, e.g. overflow: 0xFF + 1 
@(private)
cFlagMask : byte : 0b0001_0000

setFlagC :: proc(c: ^Cpu, value: bool) {
  setFlag(c, value, cFlagMask)
}

getFlagC :: proc(c: ^Cpu) -> bool {
  return getFlag(c, cFlagMask)
}

toggleFlagC :: proc(c: ^Cpu) {
  c.registers.f ~= cFlagMask
}

// The BCD flags (N, H) - used by the DAA instruction only

// Subtraction Flag (BCD)
@(private)
nFlagMask : byte : 0b0100_0000

setFlagN :: proc(c: ^Cpu, value: bool) {
  setFlag(c, value, nFlagMask)
}

getFlagN :: proc(c: ^Cpu) -> bool {
  return getFlag(c, nFlagMask)
}

// Half Carry Flag (BCD)
@(private)
hFlagMask : byte : 0b0010_0000

setFlagH :: proc(c: ^Cpu, value: bool) {
  setFlag(c, value, hFlagMask)
}

getFlagH :: proc(c: ^Cpu) -> bool {
  return getFlag(c, hFlagMask)
}

// Utilities

sprint_flags :: proc(c: ^Cpu, sep := "\n", end := "\n") -> string {
  builder := strings.builder_make()

  fmt.sbprint(&builder, "0bZNHC----", sep)
  fmt.sbprintf(&builder, "%#08b", c.registers.f)
  fmt.sbprint(&builder)

  return strings.to_string(builder)
}
