package cpu_jump_test

import "core:testing"
import "core:time"

import "../../lib"
import _cpu "../../../src/cpu"

@(test)
shouldJumpRelative :: proc(t: ^testing.T) {
  instructions := []byte { 
    0 = lib.JR_i8, 
    1 = 0x50, 
    2 = lib.HALT, 
    0x52 = lib.HALT
  }

  cpu := lib.emulate(instructions)

  testing.expect_value(t, cpu.registers.pc, 0x152)
}

@(test)
shouldJumpNegativeRelative :: proc(t: ^testing.T) {
  // Jump relative is from the next instruction - since previous instructions are "consumed"
  // https://www.reddit.com/r/EmuDev/comments/jmo5x1/gameboy_0x20_instruction/
  instructions := []byte { 
    0 = lib.HALT,
    1 = lib.HALT,
    2 = lib.JR_i8, 
    3 = 0xFB, // 0xFB is -4 
    4 = lib.HALT, 
  }

  cpu := lib.emulate(instructions, proc(cpu: ^_cpu.Cpu) {
    cpu.registers.pc = 0x0102
  })

  testing.expect_value(t, cpu.registers.pc, 0x0100)
}

@(test)
shouldJumpRelativeWhenC :: proc(t: ^testing.T) {
  instructions := []byte { 
    0 = lib.JR_C_i8, 
    1 = 0x50, 
    2 = lib.HALT, 
    0x52 = lib.HALT
  }

  cpu := lib.emulate(instructions, proc(c: ^_cpu.Cpu) {
    _cpu.setFlagC(c, true)
  })

  testing.expect_value(t, cpu.registers.pc, 0x152)
}

@(test)
shouldJumpNegativeRelativeWhenC :: proc(t: ^testing.T) {
  // Jump relative is from the next instruction - since previous instructions are "consumed"
  // https://www.reddit.com/r/EmuDev/comments/jmo5x1/gameboy_0x20_instruction/
  instructions := []byte { 
    0 = lib.HALT,
    1 = lib.HALT,
    2 = lib.HALT,
    3 = lib.JR_C_i8, // Entrypoint
    4 = 0xFA, // 0xFA is -5
    5 = lib.HALT, 
  }

  cpu := lib.emulate(instructions, proc(cpu: ^_cpu.Cpu) {
    cpu.registers.pc = 0x0103
    _cpu.setFlagC(cpu, true)
  })

  testing.expect_value(t, cpu.registers.pc, 0x0100)
}

@(test)
shouldNotJumpRelativeWhenC :: proc(t: ^testing.T) {
  instructions := []byte { 
    0 = lib.JR_C_i8, 
    1 = 0x50, 
    2 = lib.HALT, 
    0x52 = lib.HALT
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
    0x52 = lib.HALT
  }

  cpu := lib.emulate(instructions, proc(c: ^_cpu.Cpu) {
    _cpu.setFlagC(c, false)
  })

  testing.expect_value(t, cpu.registers.pc, 0x152)
}

@(test)
shouldNotJumpRelativeWhenNC :: proc(t: ^testing.T) {
  instructions := []byte { 
    0 = lib.JR_NC_i8, 
    1 = 0x50, 
    2 = lib.HALT, 
    0x52 = lib.HALT
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
    0x52 = lib.HALT
  }

  cpu := lib.emulate(instructions, proc(cpu: ^_cpu.Cpu) {
    _cpu.setFlagZ(cpu, true)
  })

  testing.expect_value(t, cpu.registers.pc, 0x0152)
}

@(test)
shouldNotJumpRelativeWhenZ :: proc(t: ^testing.T) {
  instructions := []byte { 
    0 = lib.JR_Z_i8, 
    1 = 0x50,
    2 = lib.HALT,
    0x52 = lib.HALT
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
    0x52 = lib.HALT
  }

  cpu := lib.emulate(instructions, proc(cpu: ^_cpu.Cpu) {
    _cpu.setFlagZ(cpu, false)
  })

  testing.expect_value(t, cpu.registers.pc, 0x0152)
}

@(test)
shouldNotJumpRelativeWhenNZ :: proc(t: ^testing.T) {
  instructions := []byte { 
    0 = lib.JR_NZ_i8, 
    1 = 0x50,
    2 = lib.HALT,
    0x52 = lib.HALT
  }

  cpu := lib.emulate(instructions, proc(cpu: ^_cpu.Cpu) {
    _cpu.setFlagZ(cpu, true)
  })

  testing.expect_value(t, cpu.registers.pc, 0x0102)
}
