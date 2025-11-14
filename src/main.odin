package main

import "core:fmt"
import "core:log"
import "core:os"
import "cartridge"
import "cpu"
import "bus"
import SDL "vendor:sdl2"

import "./util/cli"

main :: proc () {
  using cartridge
  using cpu
  using bus

  logger := log.create_console_logger()
  context.logger = logger

  fmt.println()

  flags := cli.getFlags()
  rom := readCartridge(os.args[1])
  bus := createBus(rom)
  cpu := createCpu(&bus)
  defer cleanup(&cpu)

  emulate(&cpu, flags.debug)
}