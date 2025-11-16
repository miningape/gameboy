package cpu_math_test

import "core:testing"

import "../../lib"
import "../../../src/bus"
import _cpu "../../../src/cpu"

@(test)
shouldAnd :: proc(t: ^testing.T) {
  using _cpu

  cpu := lib.emulate({lib.AND_A_B}, proc(cpu: ^Cpu) {
    cpu.registers.a = 0x01
    cpu.registers.b = 0x27
  })
  
  testing.expect_value(t, cpu.registers.a, 0x01)
  testing.expect_value(t, getFlagZ(&cpu), false)
  testing.expect_value(t, getFlagN(&cpu), false)
  testing.expect_value(t, getFlagH(&cpu), true)
  testing.expect_value(t, getFlagC(&cpu), false)
}

@(test)
shouldAndU8 :: proc(t: ^testing.T) {
  using _cpu

  cpu := lib.emulate({lib.AND_A_u8, 0xAB}, proc(cpu: ^Cpu) {
    cpu.registers.a = 0x0F
  })

  testing.expect_value(t, cpu.registers.a, 0x0B)
  testing.expect_value(t, getFlagZ(&cpu), false)
  testing.expect_value(t, getFlagN(&cpu), false)
  testing.expect_value(t, getFlagH(&cpu), true)
  testing.expect_value(t, getFlagC(&cpu), false)
}

@(test)
shouldAndHL_ptr :: proc(t: ^testing.T) {
  using _cpu

  cpu := lib.emulate({lib.AND_A_HL_ptr}, proc(cpu: ^Cpu) {
    bus.write(cpu.bus, 0xC100, 0x1B)

    cpu.registers.h = 0xC1
    cpu.registers.l = 0x00
    
    cpu.registers.a = 0xFF
  })

  testing.expect_value(t, cpu.registers.a, 0x1B)
  testing.expect_value(t, getFlagZ(&cpu), false)
  testing.expect_value(t, getFlagN(&cpu), false)
  testing.expect_value(t, getFlagH(&cpu), true)
  testing.expect_value(t, getFlagC(&cpu), false)
}

@(test)
shouldAndSelf :: proc(t: ^testing.T) {
  using _cpu

  cpu := lib.emulate({lib.AND_A_A}, proc(cpu: ^Cpu) {
    cpu.registers.a = 0xF1
  })

  testing.expect_value(t, cpu.registers.a, 0xF1)
  testing.expect_value(t, getFlagZ(&cpu), false)
  testing.expect_value(t, getFlagN(&cpu), false)
  testing.expect_value(t, getFlagH(&cpu), true)
  testing.expect_value(t, getFlagC(&cpu), false)
}

@(test)
shouldAndAndSetZFlag :: proc(t: ^testing.T) {
  using _cpu

  cpu := lib.emulate({lib.AND_A_B}, proc(cpu: ^Cpu) {
    cpu.registers.a = 0b1010_1010
    cpu.registers.b = 0b0101_0101
  })

  testing.expect_value(t, cpu.registers.a, 0x00)
  testing.expect_value(t, getFlagZ(&cpu), true)
  testing.expect_value(t, getFlagN(&cpu), false)
  testing.expect_value(t, getFlagH(&cpu), true)
  testing.expect_value(t, getFlagC(&cpu), false)
}
