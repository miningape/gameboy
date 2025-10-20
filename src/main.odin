package main

import "core:fmt"
import "core:os"
import "cartridge"
import "cpu/instructions"
import "cpu"
import "bus"
import SDL "vendor:sdl2"



main :: proc () {
  fmt.println()

  rom, _ := cartridge.readCartridge(os.args[1])
  bus := bus.createBus(&rom)
  cpu := cpu.createCpu(&bus)

  emulate(&cpu)

  fmt.println()
  fmt.print("Value in register BC: ")
  fmt.printf("%02X%02X\n", cpu.registers.b, cpu.registers.c) 

  fmt.print("Value in register AF: ")
  fmt.printf("%02X%02X\n", cpu.registers.a, cpu.registers.f) 
}