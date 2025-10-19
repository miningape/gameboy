package operands

import "../"
import "../../bus"

@(private = "file")
intoBC_ :: proc(c: ^cpu.Cpu, operand: Operand) {
  data := operandIsU16(operand)
  intoRegisterPair(&c.registers.b, &c.registers.c, data)
}

intoBC :: proc(c: ^cpu.Cpu) -> Operand {
  return intoBC_
}

intoRamBC :: proc(c: ^cpu.Cpu) -> Operand {
  return proc(c: ^cpu.Cpu, o: Operand) {
    location := cpu.readBC(c)
     
    bus.write(c.bus, location, c.registers.a)
  }
}
