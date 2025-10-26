package cpu

// CPU Registers and Flags: https://gbdev.io/pandocs/CPU_Registers_and_Flags.html

@(private)
setFlag :: proc(c: ^Cpu, value: bool, flagMask: byte) {
  if value {
    c.registers.f |= flagMask
  } else {
    c.registers.f &= ~flagMask
  }
}

// Zero flag - This bit is set if and only if the result of an operation is zero. Used by conditional jumps.
@(private)
zMask : byte :  0b1000_0000
setFlagZ :: proc(c: ^Cpu, value: bool) {
  setFlag(c, value, zMask)
}

// Carry flag - This bit is set if we "lose" bits in an operation, e.g. overflow: 0xFF + 1 
@(private)
cMask : byte : 0b0001_0000
setFlagC :: proc(c: ^Cpu, value: bool) {
  setFlag(c, value, cMask)
}

// The BCD flags (N, H) - used by the DAA instruction only

// Subtraction Flag (BCD)
@(private)
nMask : byte : 0b0100_0000
setFlagN :: proc(c: ^Cpu, value: bool) {
  setFlag(c, value, nMask)
}

// Half Carry Flag (BCD)
@(private)
hMask : byte : 0b0010_0000
setFlagH :: proc(c: ^Cpu, value: bool) {
  setFlag(c, value, hMask)
}
