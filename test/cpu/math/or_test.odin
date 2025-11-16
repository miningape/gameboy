package cpu_math_test

import "core:testing"

import "../../lib"
import "../../../src/bus"
import _cpu "../../../src/cpu"

@(test)
shouldOr :: proc(t: ^testing.T) {
  using _cpu

  cpu := lib.emulate({ lib.OR_A_B }, proc(cpu: ^Cpu) {
    cpu.registers.a = 0b1010_1010
    cpu.registers.b = 0b0101_0101
  })

  testing.expect_value(t, cpu.registers.a, 0b1111_1111)
  testing.expect_value(t, getFlagZ(&cpu), false)
  testing.expect_value(t, getFlagN(&cpu), false)
  testing.expect_value(t, getFlagH(&cpu), false)
  testing.expect_value(t, getFlagC(&cpu), false)
}

@(test)
shouldOrU8 :: proc(t: ^testing.T) {
  using _cpu

  cpu := lib.emulate({ lib.OR_A_u8, 0b0101_0101 }, proc(cpu: ^Cpu) {
    cpu.registers.a = 0b1010_1010
  })

  testing.expect_value(t, cpu.registers.a, 0b1111_1111)
  testing.expect_value(t, getFlagZ(&cpu), false)
  testing.expect_value(t, getFlagN(&cpu), false)
  testing.expect_value(t, getFlagH(&cpu), false)
  testing.expect_value(t, getFlagC(&cpu), false)
}

@(test)
shouldOrHL_ptr :: proc(t: ^testing.T) {
  using _cpu

  cpu := lib.emulate({ lib.OR_A_HL_ptr }, proc(cpu: ^Cpu) {
    bus.write(cpu.bus, 0xC100, 0b0101_0101)
    cpu.registers.h = 0xC1
    cpu.registers.l = 0x00

    cpu.registers.a = 0b1010_1010
  })

  testing.expect_value(t, cpu.registers.a, 0b1111_1111)
  testing.expect_value(t, getFlagZ(&cpu), false)
  testing.expect_value(t, getFlagN(&cpu), false)
  testing.expect_value(t, getFlagH(&cpu), false)
  testing.expect_value(t, getFlagC(&cpu), false)
}

@(test)
shouldOrSelf :: proc(t: ^testing.T) {
  using _cpu

  cpu := lib.emulate({ lib.OR_A_A }, proc(cpu: ^Cpu) {
    cpu.registers.a = 0b1010_1010
  })

  testing.expect_value(t, cpu.registers.a, 0b1010_1010)
  testing.expect_value(t, getFlagZ(&cpu), false)
  testing.expect_value(t, getFlagN(&cpu), false)
  testing.expect_value(t, getFlagH(&cpu), false)
  testing.expect_value(t, getFlagC(&cpu), false)
}

@(test)
shouldOrAndSetZFlag :: proc(t: ^testing.T) {
  using _cpu

  cpu := lib.emulate({ lib.OR_A_B }, proc(cpu: ^Cpu) {
    cpu.registers.a = 0x00
    cpu.registers.b = 0x00
  })

  testing.expect_value(t, cpu.registers.a, 0x00)
  testing.expect_value(t, getFlagZ(&cpu), true)
  testing.expect_value(t, getFlagN(&cpu), false)
  testing.expect_value(t, getFlagH(&cpu), false)
  testing.expect_value(t, getFlagC(&cpu), false)
}
