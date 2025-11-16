package cpu_math_test

import "core:testing"

import "../../lib"
import _cpu "../../../src/cpu"

@(test)
shouldSub :: proc(t: ^testing.T) {
  using _cpu

  cpu := lib.emulate({lib.SUB_A_B}, proc(cpu: ^_cpu.Cpu) {
    cpu.registers.a = 0xFF
    cpu.registers.b = 0x0F
  })

  testing.expect_value(t, cpu.registers.a, 0xF0)
  testing.expect_value(t, getFlagZ(&cpu), false)
  testing.expect_value(t, getFlagN(&cpu), true)
  testing.expect_value(t, getFlagH(&cpu), false)
  testing.expect_value(t, getFlagC(&cpu), false)
}

@(test)
shouldCompare :: proc(t: ^testing.T) {
  // CP is the same as SUB, except we don't store the result in the A register
  using _cpu

  cpu := lib.emulate({lib.CP_A_B}, proc(cpu: ^_cpu.Cpu) {
    cpu.registers.a = 0xFF
    cpu.registers.b = 0xFF
  })

  testing.expect_value(t, cpu.registers.a, 0xFF)
  testing.expect_value(t, getFlagZ(&cpu), true)
  testing.expect_value(t, getFlagN(&cpu), true)
  testing.expect_value(t, getFlagH(&cpu), false)
  testing.expect_value(t, getFlagC(&cpu), false)
}

@(test)
shouldSubSelf :: proc(t: ^testing.T) {
  using _cpu

  cpu := lib.emulate({lib.SUB_A_A}, proc(cpu: ^_cpu.Cpu) {
    cpu.registers.a = 0xFF
  })

  testing.expect_value(t, cpu.registers.a, 0x00)
  testing.expect_value(t, getFlagZ(&cpu), true) // Sets Z flag because result is 0
  testing.expect_value(t, getFlagN(&cpu), true)
  testing.expect_value(t, getFlagH(&cpu), false)
  testing.expect_value(t, getFlagC(&cpu), false)
}

@(test)
shouldSubU8 :: proc(t: ^testing.T) {
  using _cpu

  cpu := lib.emulate({lib.SUB_A_u8, 0x01}, proc(cpu: ^_cpu.Cpu) {
    cpu.registers.a = 0x11
  })

  testing.expect_value(t, cpu.registers.a, 0x10)
  testing.expect_value(t, getFlagZ(&cpu), false)
  testing.expect_value(t, getFlagN(&cpu), true)
  testing.expect_value(t, getFlagH(&cpu), false)
  testing.expect_value(t, getFlagC(&cpu), false)
}

@(test)
shouldSubAndSetZeroFlag :: proc(t: ^testing.T) {
  using _cpu

  cpu := lib.emulate({lib.SUB_A_B}, proc(cpu: ^_cpu.Cpu) {
    cpu.registers.a = 0xCB
    cpu.registers.b = 0xCB
  })

  testing.expect_value(t, cpu.registers.a, 0x00)
  testing.expect_value(t, getFlagZ(&cpu), true)
  testing.expect_value(t, getFlagN(&cpu), true)
  testing.expect_value(t, getFlagH(&cpu), false)
  testing.expect_value(t, getFlagC(&cpu), false)
}

@(test)
shouldSubAndSetHalfCarryFlag :: proc(t: ^testing.T) {
  using _cpu

  cpu := lib.emulate({lib.SUB_A_B}, proc(cpu: ^_cpu.Cpu) {
    cpu.registers.a = 0x10
    cpu.registers.b = 0x01
  })

  testing.expect_value(t, cpu.registers.a, 0x0F)
  testing.expect_value(t, getFlagZ(&cpu), false)
  testing.expect_value(t, getFlagN(&cpu), true)
  testing.expect_value(t, getFlagH(&cpu), true)
  testing.expect_value(t, getFlagC(&cpu), false)
}

@(test)
shouldSubAndSetCarryFlag :: proc(t: ^testing.T) {
  using _cpu

  cpu := lib.emulate({lib.SUB_A_B}, proc(cpu: ^_cpu.Cpu) {
    cpu.registers.a = 0x01
    cpu.registers.b = 0x02
  })

  testing.expect_value(t, cpu.registers.a, 0xFF)
  testing.expect_value(t, getFlagZ(&cpu), false)
  testing.expect_value(t, getFlagN(&cpu), true)
  testing.expect_value(t, getFlagH(&cpu), true)
  testing.expect_value(t, getFlagC(&cpu), true)
}
