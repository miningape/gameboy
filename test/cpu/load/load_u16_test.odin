package cpu_load_test

import "core:testing"

import "../../lib"
import "../../../src/bus"
import _cpu "../../../src/cpu"

@(test)
shouldLoadIntoU16Ptr :: proc(t: ^testing.T) {
  using _cpu

  cpu := lib.emulate({lib.LD_u16_ptr_A, 0x00, 0xFF}, proc(cpu: ^Cpu) {
    cpu.registers.a = 0xB1
  })

  testing.expect_value(t, bus.read(cpu.bus, 0xFF00), 0xB1)
}

@(test)
shouldLoadFromU16Ptr :: proc(t: ^testing.T) {
  using _cpu

  cpu := lib.emulate({lib.LD_A_u16_ptr, 0x98, 0xFF}, proc(cpu: ^Cpu) {
    bus.write(cpu.bus, 0xFF98, 0xBB)
    cpu.registers.a = 0x00
  })

  testing.expect_value(t, cpu.registers.a, 0xBB)
}

@(test)
shouldLoadSPIntoU16Ptr :: proc(t: ^testing.T) {
  using _cpu
  
  cpu := lib.emulate({lib.LD_u16_ptr_SP, 0xF0, 0xFF}, proc(cpu: ^Cpu) {
    bus.write(cpu.bus, 0xFFF0, 0x00)
    bus.write(cpu.bus, 0xFFF1, 0x00)

    cpu.registers.sp = 0xFF04
  }, context.allocator)

  testing.expect_value(t, bus.read(cpu.bus, 0xFFF0), 0x04)
  testing.expect_value(t, bus.read(cpu.bus, 0xFFF1), 0xFF)
}

@(test)
shouldLoadHLIntoSP :: proc(t: ^testing.T) {
  using _cpu
  
  cpu := lib.emulate({lib.LD_SP_HL}, proc(cpu: ^Cpu) {
    cpu.registers.sp = 0x0000
    cpu.registers.h = 0xA8
    cpu.registers.l = 0xBD
  })

  testing.expect_value(t, cpu.registers.sp, 0xA8BD)
}
