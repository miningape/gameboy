package cpu

import "core:log"
import "core:strings"
import "core:fmt"
import "base:runtime"

import "../bus"

Cpu :: struct {
  done: bool,
  registers: Registers,
  bus: ^bus.Bus
}

createCpu :: proc(bus: ^bus.Bus) -> Cpu {
  log.debug("Creating cpu...")
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

sprint :: proc(cpu: ^Cpu) -> string {
  builder := strings.builder_make()
  
  fmt.sbprintln(&builder, "----- REGISTERS -------- COMBO --")
  fmt.sbprintln(&builder, "+---------+---------+")
  fmt.sbprintfln(&builder, "| A: 0x%02X | F: 0x%02X | -> 0x%02X%02X", cpu.registers.a, cpu.registers.f, cpu.registers.a, cpu.registers.f)
  fmt.sbprintln(&builder, "+---------+---------+")
  fmt.sbprintfln(&builder, "| B: 0x%02X | C: 0x%02X | -> 0x%02X%02X", cpu.registers.b, cpu.registers.c, cpu.registers.b, cpu.registers.c)
  fmt.sbprintln(&builder, "+---------+---------+")
  fmt.sbprintfln(&builder, "| D: 0x%02X | E: 0x%02X | -> 0x%02X%02X", cpu.registers.d, cpu.registers.e, cpu.registers.d, cpu.registers.e)
  fmt.sbprintln(&builder, "+---------+---------+")
  fmt.sbprintfln(&builder, "| H: 0x%02X | L: 0x%02X | -> 0x%02X%02X", cpu.registers.h, cpu.registers.l, cpu.registers.h, cpu.registers.l)
  fmt.sbprintln(&builder, "+---------+---------+")
  fmt.sbprintfln(&builder, "| PC:   0x%04X      |", cpu.registers.pc)
  fmt.sbprintln(&builder, "+---------+---------+")
  fmt.sbprintfln(&builder, "| SP:   0x%04X      |", cpu.registers.sp)
  fmt.sbprintln(&builder, "+---------+---------+")

  return strings.to_string(builder)
}

// Cleans up any references / memory the CPU owns
cleanup :: proc(cpu: ^Cpu, allocator: runtime.Allocator = context.allocator) {
  bus.cleanupBus(cpu.bus, allocator)
}
