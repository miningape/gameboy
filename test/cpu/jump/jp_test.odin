package cpu_jump_test

import "core:testing"

import _cpu "../../../src/cpu"
import "../../lib"



@(test)
shouldJump :: proc(t: ^testing.T) {
  cpu := shouldJumpTestMacro(lib.JP_u16)

  testing.expect_value(t, cpu.registers.pc, 0x0150)
}

@(test)
shouldJumpToHL :: proc(t: ^testing.T) {  
  cpu := shouldJumpTestMacro(lib.JP_HL, proc(cpu: ^_cpu.Cpu) {
    cpu.registers.h = 0x01
    cpu.registers.l = 0x50
  })

  testing.expect_value(t, cpu.registers.pc, 0x0150)
}

@(test)
shouldJumpZ :: proc(t: ^testing.T) {
  cpu := shouldJumpTestMacro(lib.JP_Z_u16, proc(cpu: ^_cpu.Cpu) {
    _cpu.setFlagZ(cpu, true)
  })

  testing.expect_value(t, cpu.registers.pc, 0x0150)
}

@(test)
shouldNotJumpZ :: proc(t: ^testing.T) {
  cpu := shouldJumpTestMacro(lib.JP_Z_u16, proc(cpu: ^_cpu.Cpu) {
    _cpu.setFlagZ(cpu, false)
  })

  testing.expect_value(t, cpu.registers.pc, 0x0103)
}

@(test)
shouldJumpNZ :: proc(t: ^testing.T) {
  cpu := shouldJumpTestMacro(lib.JP_NZ_u16, proc(cpu: ^_cpu.Cpu) {
    _cpu.setFlagZ(cpu, false)
  })

  testing.expect_value(t, cpu.registers.pc, 0x0150)
}

@(test)
shouldNotJumpNZ :: proc(t: ^testing.T) {
  cpu := shouldJumpTestMacro(lib.JP_NZ_u16, proc(cpu: ^_cpu.Cpu) {
    _cpu.setFlagZ(cpu, true)
  })

  testing.expect_value(t, cpu.registers.pc, 0x0103)
}

@(test)
shouldJumpC :: proc(t: ^testing.T) {
  cpu := shouldJumpTestMacro(lib.JP_C_u16, proc(cpu: ^_cpu.Cpu) {
    _cpu.setFlagC(cpu, true)
  })

  testing.expect_value(t, cpu.registers.pc, 0x0150)
}

@(test)
shouldNotJumpC :: proc(t: ^testing.T) {
  cpu := shouldJumpTestMacro(lib.JP_C_u16, proc(cpu: ^_cpu.Cpu) {
    _cpu.setFlagC(cpu, false)
  })

  testing.expect_value(t, cpu.registers.pc, 0x0103)
}

@(test)
shouldJumpNC :: proc(t: ^testing.T) {
  cpu := shouldJumpTestMacro(lib.JP_NC_u16, proc(cpu: ^_cpu.Cpu) {
    _cpu.setFlagC(cpu, false)
  })

  testing.expect_value(t, cpu.registers.pc, 0x0150)
}

@(test)
shouldNotJumpNC :: proc(t: ^testing.T) {
  cpu := shouldJumpTestMacro(lib.JP_NC_u16, proc(cpu: ^_cpu.Cpu) {
    _cpu.setFlagC(cpu, true)
  })

  testing.expect_value(t, cpu.registers.pc, 0x0103)
}


/*
 Sets up jump test such that you can set first 2 instructions
 * The following bytes 2 are set as the address 0x0150
 * Followed by a halt on byte 0x0104 <-- Non jump location
 * And then a bunch of NOOPs (0x00)
 * And then a halt on byte 0x0150 <-- Jump location
 */
@(private="file")
shouldJumpTestMacro :: proc(instruction: byte, hook: proc(cpu: ^_cpu.Cpu) = proc(cpu: ^_cpu.Cpu) {}) -> _cpu.Cpu {
  instructions := [0x0051]byte {
    0 = instruction,
    1 = 0x50,
    2 = 0x01,
    3 = lib.HALT,
    0x0050 = lib.HALT
  }

  return lib.emulate(instructions[:], hook)
}
