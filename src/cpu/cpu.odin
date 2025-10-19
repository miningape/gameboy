package cpu

import "core:fmt"

import "../bus"

Cpu :: struct {
  done: bool,
  registers: Registers,
  bus: ^bus.Bus
}

createCpu :: proc(bus: ^bus.Bus) -> Cpu {
  fmt.println("Creating cpu...")
  return Cpu {
    done = false,
    // State following execution of boot ROM
    registers = {
      a = 0, f = 0,
      b = 0, c = 0,
      d = 0, e = 0,
      h = 0, l = 0,
      pc = 0x100,
      sp = 0xFFFE
    },
    bus = bus
  }
}

readBC :: proc(cpu: ^Cpu) -> u16 {
  upper := cpu.registers.b
  lower := cpu.registers.c

  return u16(upper) << 8 |  u16(lower)
}

getPC :: proc(cpu: ^Cpu) -> u16 {
  return cpu.registers.pc
}

incrementPC :: proc(cpu: ^Cpu) {
  cpu.registers.pc += 1
}
