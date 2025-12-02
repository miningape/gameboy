package cpu_stack_test

import "core:testing"

import "../../lib"

import "../../../src/bus"
import "../../../src/cpu"

@(test)
shouldCall :: proc(t: ^testing.T) {
  cpu := lib.emulate({ 
    0 = lib.CALL_u16, 
    1 = 0x50, 
    2 = 0x01, 
    3 = lib.HALT,
    0x50 = lib.HALT
  })

  testing.expect_value(t, cpu.registers.pc, 0x0150)
  testing.expect_value(t, cpu.registers.sp, 0xFFFC)
  testing.expect_value(t, bus.read(cpu.bus, 0xFFFD), 0x01)
  testing.expect_value(t, bus.read(cpu.bus, 0xFFFC), 0x03)
}

@(test)
shouldCallZ :: proc(t: ^testing.T) {
  using cpu

  cpu := lib.emulate({ 
    0 = lib.CALL_Z_u16, 
    1 = 0x50, 
    2 = 0x01, 
    3 = lib.HALT,
    0x50 = lib.HALT
  }, proc(cpu: ^Cpu) {
    setFlagZ(cpu, true)
  })

  testing.expect_value(t, cpu.registers.pc, 0x0150)
  testing.expect_value(t, cpu.registers.sp, 0xFFFC)
  testing.expect_value(t, bus.read(cpu.bus, 0xFFFD), 0x01)
  testing.expect_value(t, bus.read(cpu.bus, 0xFFFC), 0x03)
}

@(test)
shouldNotCallZ :: proc(t: ^testing.T) {
  using cpu

  cpu := lib.emulate({ 
    0 = lib.CALL_Z_u16, 
    1 = 0x50, 
    2 = 0x01, 
    3 = lib.HALT,
    0x50 = lib.HALT
  }, proc(cpu: ^Cpu) {
    setFlagZ(cpu, false)
  })

  testing.expect_value(t, cpu.registers.pc, 0x0103)
  testing.expect_value(t, cpu.registers.sp, 0xFFFE)
}

@(test)
shouldReturn :: proc(t: ^testing.T) {
  using cpu

  cpu := lib.emulate({
    0 = lib.RET,
    1 = lib.HALT,
    0x50 = lib.HALT
  }, proc(cpu: ^Cpu) {
    push(cpu, 0x0150)
  })

  testing.expect_value(t, cpu.registers.pc, 0x0150)
  testing.expect_value(t, cpu.registers.sp, 0xFFFE)
}

@(test)
shouldReturnZ :: proc(t: ^testing.T) {
  using cpu

  cpu := lib.emulate({
    0 = lib.RET_Z,
    1 = lib.HALT,
    0x50 = lib.HALT
  }, proc(cpu: ^Cpu) {
    push(cpu, 0x0150)
    setFlagZ(cpu, true)
  })

  testing.expect_value(t, cpu.registers.pc, 0x0150)
  testing.expect_value(t, cpu.registers.sp, 0xFFFE)
}

@(test)
shouldNotReturnZ :: proc(t: ^testing.T) {
  using cpu

  cpu := lib.emulate({
    0 = lib.RET_Z,
    1 = lib.HALT,
    0x50 = lib.HALT
  }, proc(cpu: ^Cpu) {
    push(cpu, 0x0150)
    setFlagZ(cpu, false)
  })

  testing.expect_value(t, cpu.registers.pc, 0x0101)
  testing.expect_value(t, cpu.registers.sp, 0xFFFC)
}
