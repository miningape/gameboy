package cpu_stack_test

import "core:testing"

import "../../../src/bus"
import _cpu "../../../src/cpu"

import "../../lib"

@(test)
shouldPushBC :: proc(t: ^testing.T) {
  cpu := lib.emulate({ lib.LD_BC_u16, 0x69, 0xFF, lib.PUSH_BC, lib.HALT })

  testing.expect_value(t, cpu.registers.sp, 0xFFFC)
  testing.expect_value(t, bus.read(cpu.bus, 0xFFFC), 0x69)
  testing.expect_value(t, bus.read(cpu.bus, 0xFFFD), 0xFF)
  testing.expect_value(t, cpu.registers.c, 0x69)
  testing.expect_value(t, cpu.registers.b, 0xFF)
}

@(test)
shouldPushDE :: proc(t: ^testing.T) {
  cpu := lib.emulate({ lib.LD_DE_u16, 0x69, 0xFF, lib.PUSH_DE, lib.HALT })

  testing.expect_value(t, cpu.registers.sp, 0xFFFC)
  testing.expect_value(t, bus.read(cpu.bus, 0xFFFC), 0x69)
  testing.expect_value(t, bus.read(cpu.bus, 0xFFFD), 0xFF)
  testing.expect_value(t, cpu.registers.e, 0x69)
  testing.expect_value(t, cpu.registers.d, 0xFF)
}

@(test)
shouldPushHL :: proc(t: ^testing.T) {
  cpu := lib.emulate({ lib.LD_HL_u16, 0x69, 0xFF, lib.PUSH_HL, lib.HALT })

  testing.expect_value(t, cpu.registers.sp, 0xFFFC)
  testing.expect_value(t, bus.read(cpu.bus, 0xFFFC), 0x69)
  testing.expect_value(t, bus.read(cpu.bus, 0xFFFD), 0xFF)
  testing.expect_value(t, cpu.registers.l, 0x69)
  testing.expect_value(t, cpu.registers.h, 0xFF)
}

@(test)
shouldPushAF :: proc(t: ^testing.T) {
  cpu := lib.emulate({ 
    lib.SUB_A_A, // Set flags, z=1 n=1, h=0, c=0
    lib.LD_A_u8, 0x69,
    lib.PUSH_AF,
    lib.HALT
  })

  testing.expect_value(t, cpu.registers.sp, 0xFFFC)
  testing.expect_value(t, bus.read(cpu.bus, 0xFFFC), 0b1100_0000)
  testing.expect_value(t, bus.read(cpu.bus, 0xFFFD), 0x69)
  testing.expect_value(t, cpu.registers.f, 0b1100_0000)
  testing.expect_value(t, cpu.registers.a, 0x69)

  testing.expect_value(t, _cpu.getFlagZ(&cpu), true)
  testing.expect_value(t, _cpu.getFlagN(&cpu), true)
  testing.expect_value(t, _cpu.getFlagH(&cpu), false)
  testing.expect_value(t, _cpu.getFlagC(&cpu), false)
}

@(test)
shouldPushBCPopDE :: proc(t: ^testing.T) {
  cpu := lib.emulate({ lib.LD_BC_u16, 0xAA, 0x1F, lib.PUSH_BC, lib.POP_DE, lib.HALT })

  testing.expect_value(t, cpu.registers.sp, 0xFFFE)
  testing.expect_value(t, bus.read(cpu.bus, 0xFFFC), 0xAA)
  testing.expect_value(t, bus.read(cpu.bus, 0xFFFD), 0x1F)

  // BC
  testing.expect_value(t, cpu.registers.c, 0xAA)
  testing.expect_value(t, cpu.registers.b, 0x1F)

  // DE
  testing.expect_value(t, cpu.registers.e, 0xAA)
  testing.expect_value(t, cpu.registers.d, 0x1F)
}
