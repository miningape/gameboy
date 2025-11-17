package main

import "core:os"
import "core:log"

import e_cpu "cpu"
import "bus"
import "cpu/instructions"
import _debugger "util/debugger"
import "util/resources"

emulate :: proc(cpu: ^e_cpu.Cpu, debugger: ^_debugger.T) {
  read := instructions.MAPPING()
  
  log.debug("Starting emulation...")

  for !cpu.done {
    pc := e_cpu.getPC(cpu)
    opcode := bus.read(cpu.bus, pc)
    
    if debugger != nil {
      description := resources.describe(opcode, cpu)
      log.debugf("$%04X = %#02X %s", cpu.registers.pc, opcode, description)

      _debugger.debugStep(debugger)
    } else {
      log.debugf("Executing: PC: %#04X, OP: %#02X", cpu.registers.pc, opcode)
    }

    instruction := read[opcode]
    instruction.operation(cpu, instruction)    
  }
}
