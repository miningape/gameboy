package main

import "core:fmt"
import "core:log"
import "core:os"
import "cartridge"
import "cpu"
import "bus"
import SDL "vendor:sdl2"

import "./util/cli"
import "./util/debugger"

main :: proc () {
  using cartridge
  using cpu
  using bus

  logger := log.create_console_logger()
  context.logger = logger

  flags := cli.getFlags()
  rom := readCartridge(flags.file)
  bus := createBus(rom)
  cpu := createCpu(&bus)
  defer cleanup(&cpu)

  debugger := debugger.create(&cpu)

  emulate(&cpu, flags.debug ? &debugger : nil)
}