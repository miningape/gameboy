package main

import "core:log"

import e_cpu "cpu"
import "bus"
import "cpu/instructions"

emulate :: proc(cpu: ^e_cpu.Cpu) {
  read := instructions.MAPPING()
  
  log.debug("Starting emulation...")

  for !cpu.done {
    pc := e_cpu.getPC(cpu)

    opcode := bus.read(cpu.bus, pc)

    instruction := read[opcode]
    instruction.operation(cpu, instruction)
    
    e_cpu.incrementPC(cpu)
  }

  l := e_cpu.sprint(cpu)
  defer delete(l)
  log.debug("\n", l, sep="")
}
