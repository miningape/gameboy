package main

import "core:fmt"

import e_cpu "cpu"
import "bus"
import "cpu/instructions"

emulate :: proc(cpu: ^e_cpu.Cpu) {
  read := instructions.MAPPING()

  fmt.println("Starting emulation...")
  fmt.println()

  for !cpu.done {
    pc := e_cpu.getPC(cpu)

    opcode := bus.read(cpu.bus, pc)

    instruction := read[opcode]
    instruction.operation(cpu, instruction)
    
    e_cpu.incrementPC(cpu)
  }

  fmt.println(e_cpu.sprint(cpu))
}
