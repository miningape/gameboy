package main

import "core:os"
import "core:log"

import e_cpu "cpu"
import "bus"
import "cpu/instructions"
import _debugger "util/debugger"

emulate :: proc(cpu: ^e_cpu.Cpu, debugger: ^_debugger.T) {
  read := instructions.MAPPING()
  
  log.debug("Starting emulation...")

  for !cpu.done {
    pc := e_cpu.getPC(cpu)

    if debugger != nil {
      _debugger.debugStep(debugger)
    }
    
    opcode := bus.read(cpu.bus, pc)
    log.debugf("PC: %#04X, OP: %#02X", cpu.registers.pc, opcode)

    instruction := read[opcode]
    instruction.operation(cpu, instruction)
  }

  l := e_cpu.sprint(cpu)
  defer delete(l)
  log.debug("\n", l, sep="")
}
