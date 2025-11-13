package cpu_add_test

import "core:testing"

import "../../lib"
import _cpu "../../../src/cpu"

@(private)
negate :: proc(num: u8) -> u8 {
  return (~num) + 1
}

@(test)
shouldAdd :: proc(t: ^testing.T) {
  using _cpu

  instructions := []byte{ lib.ADD_SP_i8, 0x0F }

  cpu := lib.emulate(instructions, proc(cpu: ^Cpu) {
    cpu.registers.sp = 0x0000
  })

  testing.expect(t, cpu.registers.sp == 0x000F)
  testing.expect_value(t, getFlagZ(&cpu), false)
  testing.expect_value(t, getFlagN(&cpu), false)
  testing.expect_value(t, getFlagH(&cpu), false)
  testing.expect_value(t, getFlagC(&cpu), false)
}

@(test)
shouldAddAndOverflowToNextBit :: proc(t: ^testing.T) {
  using _cpu

  instructions := []byte{ lib.ADD_SP_i8, 0x7F } // 0x7F is the largest signed 8-bit integer

  cpu := lib.emulate(instructions, proc(cpu: ^Cpu) {
    cpu.registers.sp = 0x0081
  })

  testing.expect(t, cpu.registers.sp == 0x0100)
  testing.expect_value(t, getFlagZ(&cpu), false)
  testing.expect_value(t, getFlagN(&cpu), false)
  testing.expect_value(t, getFlagH(&cpu), true)
  testing.expect_value(t, getFlagC(&cpu), true)
}

@(test)
shouldAddAndOverflow :: proc(t: ^testing.T) {
  using _cpu

  instructions := []byte{ lib.ADD_SP_i8, 0x01 }

  cpu := lib.emulate(instructions, proc(cpu: ^Cpu) {
    cpu.registers.sp = 0xFFFF
  })

  testing.expect(t, cpu.registers.sp == 0x0000)
  testing.expect_value(t, getFlagZ(&cpu), false)
  testing.expect_value(t, getFlagN(&cpu), false)
  testing.expect_value(t, getFlagH(&cpu), true)
  testing.expect_value(t, getFlagC(&cpu), true)
}

@(test)
shouldSub :: proc(t: ^testing.T) {
  using _cpu

  instructions := []byte{ lib.ADD_SP_i8, negate(0x7F)}

  cpu := lib.emulate(instructions, proc(cpu: ^Cpu) {
    cpu.registers.sp = 0x017F
  })

  testing.expect_value(t, cpu.registers.sp, 0x0100)
  testing.expect_value(t, getFlagZ(&cpu), false)
  testing.expect_value(t, getFlagN(&cpu), false)
  testing.expect_value(t, getFlagH(&cpu), true)
  testing.expect_value(t, getFlagC(&cpu), true)
}

@(test)
shouldSubAndUnderflowToNextBit :: proc(t: ^testing.T) {
  using _cpu

  instructions := []byte{ lib.ADD_SP_i8, negate(0x7F) }

  cpu := lib.emulate(instructions, proc (cpu: ^Cpu) {
    cpu.registers.sp = 0x017E
  })

  lib.logFlags(&cpu)

  testing.expect_value(t, cpu.registers.sp, 0x00FF)
  testing.expect_value(t, getFlagZ(&cpu), false)
  testing.expect_value(t, getFlagN(&cpu), false)
  testing.expect_value(t, getFlagH(&cpu), false)
  testing.expect_value(t, getFlagC(&cpu), false)
}

@(test)
shouldSubAndUnderflow :: proc(t: ^testing.T) {
  using _cpu

  instructions := []byte{ lib.ADD_SP_i8, negate(0x01) }

  cpu := lib.emulate(instructions, proc (cpu: ^Cpu) {
    cpu.registers.sp = 0x0000
  })

  lib.logFlags(&cpu)

  testing.expect_value(t, cpu.registers.sp, 0xFFFF)
  testing.expect_value(t, getFlagZ(&cpu), false)
  testing.expect_value(t, getFlagN(&cpu), false)
  testing.expect_value(t, getFlagH(&cpu), false)
  testing.expect_value(t, getFlagC(&cpu), false)
}

@(test)
// based on - https://stackoverflow.com/questions/57958631/game-boy-half-carry-flag-and-16-bit-instructions-especially-opcode-0xe8
shouldSubAndSetCarryFlags :: proc(t: ^testing.T) {
  using _cpu

  instructions := []byte{ lib.ADD_SP_i8, 0xFF } // 0xFF is -1 in twos complement

  cpu := lib.emulate(instructions, proc(cpu: ^Cpu) {
    cpu.registers.sp = 0x00FF
  })

  testing.expect(t, cpu.registers.sp == 0x00FE)
  testing.expect_value(t, getFlagZ(&cpu), false)
  testing.expect_value(t, getFlagN(&cpu), false)
  testing.expect_value(t, getFlagH(&cpu), true)
  testing.expect_value(t, getFlagC(&cpu), true)
}
