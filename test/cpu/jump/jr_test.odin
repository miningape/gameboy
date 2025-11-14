package cpu_jump_test

import "core:testing"

import "../../lib"
import _cpu "../../../src/cpu"

@(test)
shouldJumpRelative :: proc(t: ^testing.T) {
  instructions := []byte { 
    0 = lib.JR_i8, 
    1 = 0x50, 
    2 = lib.HALT, 
    0x50 = lib.HALT
  }

  cpu := lib.emulate(instructions)

  testing.expect_value(t, cpu.registers.pc, 0x150)
}

@(test)
shouldJumpRelativeWhenC :: proc(t: ^testing.T) {
  instructions := []byte { 
    0 = lib.JR_C_i8, 
    1 = 0x50, 
    2 = lib.HALT, 
    0x50 = lib.HALT
  }

  cpu := lib.emulate(instructions, proc(c: ^_cpu.Cpu) {
    _cpu.setFlagC(c, true)
  })

  testing.expect_value(t, cpu.registers.pc, 0x150)
}

@(test)
shouldNotJumpRelativeWhenC :: proc(t: ^testing.T) {
  instructions := []byte { 
    0 = lib.JR_C_i8, 
    1 = 0x50, 
    2 = lib.HALT, 
    0x50 = lib.HALT
  }

  cpu := lib.emulate(instructions, proc(c: ^_cpu.Cpu) {
    _cpu.setFlagC(c, false)
  })

  testing.expect_value(t, cpu.registers.pc, 0x102)
}

@(test)
shouldJumpRelativeWhenNC :: proc(t: ^testing.T) {
  instructions := []byte { 
    0 = lib.JR_NC_i8, 
    1 = 0x50, 
    2 = lib.HALT, 
    0x50 = lib.HALT
  }

  cpu := lib.emulate(instructions, proc(c: ^_cpu.Cpu) {
    _cpu.setFlagC(c, false)
  })

  testing.expect_value(t, cpu.registers.pc, 0x150)
}

@(test)
shouldNotJumpRelativeWhenNC :: proc(t: ^testing.T) {
  instructions := []byte { 
    0 = lib.JR_NC_i8, 
    1 = 0x50, 
    2 = lib.HALT, 
    0x50 = lib.HALT
  }

  cpu := lib.emulate(instructions, proc(c: ^_cpu.Cpu) {
    _cpu.setFlagC(c, true)
  })

  testing.expect_value(t, cpu.registers.pc, 0x102)
}

@(test)
shouldJumpRelativeWhenZ :: proc(t: ^testing.T) {
  instructions := []byte { 
    0 = lib.JR_Z_i8, 
    1 = 0x50,
    2 = lib.HALT,
    0x50 = lib.HALT
  }


  cpu := lib.emulate(instructions, proc(cpu: ^_cpu.Cpu) {
    _cpu.setFlagZ(cpu, true)
  })

  testing.expect_value(t, cpu.registers.pc, 0x0150)
}

@(test)
shouldNotJumpRelativeWhenZ :: proc(t: ^testing.T) {
  instructions := []byte { 
    0 = lib.JR_Z_i8, 
    1 = 0x50,
    2 = lib.HALT,
    0x50 = lib.HALT
  }


  cpu := lib.emulate(instructions, proc(cpu: ^_cpu.Cpu) {
    _cpu.setFlagZ(cpu, false)
  })

  testing.expect_value(t, cpu.registers.pc, 0x0102)
}

@(test)
shouldJumpRelativeWhenNZ :: proc(t: ^testing.T) {
  instructions := []byte { 
    0 = lib.JR_NZ_i8, 
    1 = 0x50,
    2 = lib.HALT,
    0x50 = lib.HALT
  }

  cpu := lib.emulate(instructions, proc(cpu: ^_cpu.Cpu) {
    _cpu.setFlagZ(cpu, false)
  })

  testing.expect_value(t, cpu.registers.pc, 0x0150)
}

@(test)
shouldNotJumpRelativeWhenNZ :: proc(t: ^testing.T) {
  instructions := []byte { 
    0 = lib.JR_NZ_i8, 
    1 = 0x50,
    2 = lib.HALT,
    0x50 = lib.HALT
  }

  cpu := lib.emulate(instructions, proc(cpu: ^_cpu.Cpu) {
    _cpu.setFlagZ(cpu, true)
  })

  testing.expect_value(t, cpu.registers.pc, 0x0102)
}
