package cpu_load_test

import "core:testing"

import "../../lib"
import "../../../src/bus"
import _cpu "../../../src/cpu"

@(test)
shouldLoadIntoHramU8 :: proc(t: ^testing.T) {
  using _cpu

  cpu := lib.emulate({lib.LDH_u8_A, 0x00}, proc(cpu: ^Cpu) {
    cpu.registers.a = 0xB1
  })

  testing.expect_value(t, bus.read(cpu.bus, 0xFF00), 0xB1)
}

@(test)
shouldLoadFromHramU8 :: proc(t: ^testing.T) {
  using _cpu

  cpu := lib.emulate({lib.LDH_A_u8, 0x11}, proc(cpu: ^Cpu) {
    bus.write(cpu.bus, 0xFF11, 0xDC)
    cpu.registers.a = 0x00
  })

  testing.expect_value(t, cpu.registers.a, 0xDC)
}

@(test)
shouldLoadIntoHramC :: proc(t: ^testing.T) {
  using _cpu

  cpu := lib.emulate({lib.LDH_C_ptr_A}, proc(cpu: ^Cpu) {
    cpu.registers.a = 0xA8
    cpu.registers.c = 0xBA
  })

  testing.expect_value(t, bus.read(cpu.bus, 0xFFBA), 0xA8)
}

@(test)
shouldLoadFromHramC :: proc(t: ^testing.T) {
  using _cpu

  cpu := lib.emulate({lib.LDH_A_C_ptr}, proc(cpu: ^Cpu) {
    bus.write(cpu.bus, 0xFFEE, 0x49)
    cpu.registers.a = 0x00
    cpu.registers.c = 0xEE
  })

  testing.expect_value(t, cpu.registers.a, 0x49)
}
