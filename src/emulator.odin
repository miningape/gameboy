package main

import "core:os"
import "core:log"

import e_cpu "cpu"
import "bus"
import "cpu/instructions"

readUntilNewline :: proc() -> string {
  buffer := make([]byte, 0xFF)

  n, err := os.read(os.stdin, buffer)
  if err != nil {
    log.error(err)
    panic("Error reading from stdin")
  }

  return string(buffer[:n])
}

emulate :: proc(cpu: ^e_cpu.Cpu, debug: bool) {
  read := instructions.MAPPING()
  
  log.debug("Starting emulation...")

  for !cpu.done {
    pc := e_cpu.getPC(cpu)

    if debug {
      s := readUntilNewline()
      log.debug(s)
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
