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
}