package cpu_stack_test

import "core:testing"

import "../../../src/bus"
import _cpu "../../../src/cpu"

import "../../lib"

@(test)
shouldPopBC :: proc(t: ^testing.T) {
  using _cpu

  cpu := lib.emulate({ lib.POP_BC, lib.HALT }, proc(cpu: ^Cpu) {
    cpu.registers.sp = 0xFFFC
    bus.write(cpu.bus, 0xFFFC, 0x19)
    bus.write(cpu.bus, 0xFFFD, 0xAB)
  })

  testing.expect_value(t, cpu.registers.sp, 0xFFFE)
  testing.expect_value(t, cpu.registers.c, 0x19)
  testing.expect_value(t, cpu.registers.b, 0xAB)
}

@(test)
shouldPopDE :: proc(t: ^testing.T) {
  using _cpu

  cpu := lib.emulate({ lib.POP_DE, lib.HALT }, proc(cpu: ^Cpu) {
    cpu.registers.sp = 0xFFFC
    bus.write(cpu.bus, 0xFFFC, 0x21)
    bus.write(cpu.bus, 0xFFFD, 0x9B)
  })

  testing.expect_value(t, cpu.registers.sp, 0xFFFE)
  testing.expect_value(t, cpu.registers.e, 0x21)
  testing.expect_value(t, cpu.registers.d, 0x9B)
}

@(test)
shouldPopHL :: proc(t: ^testing.T) {
  using _cpu

  cpu := lib.emulate({ lib.POP_HL, lib.HALT }, proc(cpu: ^Cpu) {
    cpu.registers.sp = 0xFFFC
    bus.write(cpu.bus, 0xFFFC, 0x41)
    bus.write(cpu.bus, 0xFFFD, 0xA7)
  })

  testing.expect_value(t, cpu.registers.sp, 0xFFFE)
  testing.expect_value(t, cpu.registers.l, 0x41)
  testing.expect_value(t, cpu.registers.h, 0xA7)
}

@(test)
shouldPopAF :: proc(t: ^testing.T) {
  using _cpu

  cpu := lib.emulate({ lib.POP_AF, lib.HALT }, proc(cpu: ^Cpu) {
    cpu.registers.sp = 0xFFFC
    bus.write(cpu.bus, 0xFFFC, 0b1101_0001)
    bus.write(cpu.bus, 0xFFFD, 0x57)
  })

  testing.expect_value(t, cpu.registers.sp, 0xFFFE)
  testing.expect_value(t, cpu.registers.f, 0b1101_0001)
  testing.expect_value(t, cpu.registers.a, 0x57)

  testing.expect_value(t, getFlagZ(&cpu), true)
  testing.expect_value(t, getFlagN(&cpu), true)
  testing.expect_value(t, getFlagH(&cpu), false)
  testing.expect_value(t, getFlagC(&cpu), true)
}
