package main

import "core:log"

import "cartridge"
import "cpu"
import "bus"
import "./util/cli"
import "./util/debugger"

main :: proc () {
  using cartridge
  using cpu
  using bus

  flags := cli.getFlags()

  logger := log.create_console_logger(flags.debug ? .Debug : .Warning)
  context.logger = logger

  stdin := cli.createListener(context.allocator)
  defer cli.stopListener(stdin, context.allocator)

  rom := readCartridge(flags.file)
  bus := createBus(rom)
  cpu := createCpu(&bus)
  defer cleanup(&cpu)

  debug: debugger.T
  if flags.debug {
    debug = debugger.create(&cpu, stdin, context.allocator)
  }

  emulate(&cpu, flags.debug ? &debug : nil)
}