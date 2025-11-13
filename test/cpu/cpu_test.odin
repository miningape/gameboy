package cpu_test

import "core:testing"

import _bus "../../src/bus"
import _cpu "../../src/cpu"
import _emulator "../../src"
import "../lib"

@require import "./math"
@require import "./jump"

@(test)
shouldLoad :: proc (t: ^testing.T) {
  rom := lib.createRom([]byte{ lib.LD_BC_u16, 0x69, 0x69 })
  bus := _bus.createBus(rom)

  cpu := _cpu.createCpu(&bus)
  defer _cpu.cleanup(&cpu)

  _emulator.emulate(&cpu)

  testing.expect_value(t, cpu.registers.b, 0x69)
  testing.expect_value(t, cpu.registers.c, 0x69)
}
