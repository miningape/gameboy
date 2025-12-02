package cpu

import "../bus"

@(private="file")
incrementSP :: proc(cpu: ^Cpu) {
  // "Increments" downwards in memory
  cpu.registers.sp -= 1
}

push :: proc(cpu: ^Cpu, data: u16) {
  upper, lower := split(data)

  incrementSP(cpu)
  bus.write(cpu.bus, cpu.registers.sp, upper)
  incrementSP(cpu)
  bus.write(cpu.bus, cpu.registers.sp, lower)
}

@(private="file")
decrementSP :: proc(cpu: ^Cpu) {
  // "Decrements" upwards in memory
  cpu.registers.sp += 1
}

pop :: proc(cpu: ^Cpu) -> u16 {
  lower := bus.read(cpu.bus, cpu.registers.sp)
  decrementSP(cpu)
  upper := bus.read(cpu.bus, cpu.registers.sp)
  decrementSP(cpu)

  return unify(upper, lower)
}
