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

  flags := cli.getFlags()

  logger := log.create_console_logger(flags.debug ? .Debug : .Warning)
  context.logger = logger

  rom := readCartridge(flags.file)
  bus := createBus(rom)
  cpu := createCpu(&bus)
  defer cleanup(&cpu)

  debugger := debugger.create(&cpu)

  emulate(&cpu, flags.debug ? &debugger : nil)
}