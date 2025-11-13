package test_lib

import "core:log"

import _bus "../../src/bus"
import _cpu "../../src/cpu"
import _emulator "../../src"

createRom :: proc(instructions: []byte) -> []byte {
  header := make([]byte, 0x100 + 1 + len(instructions))
  
  for instruction, i in instructions {
    header[0x100 + i] = instruction
  }

  header[len(header) - 1] = HALT

  return header
}

emulate :: proc(instructions: []byte, hook: proc(_: ^_cpu.Cpu) = proc(cpu: ^_cpu.Cpu) {}) -> _cpu.Cpu {
  rom := createRom(instructions)
  log.debug("Created ROM:", rom)

  bus := _bus.createBus(rom)
  cpu := _cpu.createCpu(&bus)
  defer _cpu.cleanup(&cpu)

  hook(&cpu)
  _emulator.emulate(&cpu)

  return cpu
}

logFlags :: proc(cpu: ^_cpu.Cpu) {
  s := _cpu.sprint_flags(cpu) 
  defer delete(s)
  log.debug("\n", s, sep="")
}
