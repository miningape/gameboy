package main

import "core:log"

import e_cpu "cpu"
import "bus"
import "cpu/instructions"
import "util/debugger"

emulate :: proc(cpu: ^e_cpu.Cpu, debug: ^debugger.T) {
  read := instructions.MAPPING()
  
  log.debug("Starting emulation...")

  for !cpu.done {
    if debug != nil {
      if !debugger.step(debug) {
        continue
      }
    }

    pc := e_cpu.getPC(cpu)
    opcode := bus.read(cpu.bus, pc)
    
    if debug == nil {
      log.debugf("Executing: PC: %#04X, OP: %#02X", cpu.registers.pc, opcode)
    }

    instruction := read[opcode]
    instruction.operation(cpu, instruction)
  }

  log.debug("Finished emulation")
}
