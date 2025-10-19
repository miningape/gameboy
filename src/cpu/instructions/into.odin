package instructions

import "../"
import "../../bus"

@(private = "file")
operandIsU8 :: proc(operand: Operand) -> byte {
  data, ok := operand.(byte)

  if !ok {
    panic("Could not read operand for u8")
  }

  return data
}

@(private = "file")
operandIsU16 :: proc(operand: Operand) -> u16 {
  data, ok := operand.(u16)

  if !ok {
    bt: byte
    bt, ok = operand.(byte)

    if !ok {
      panic("Could not read operand for u16")
    }

    data = u16(bt)
  }

  return data
}

@(private = "file")
intoRegisterPair :: proc(upper: ^cpu.Register, lower: ^cpu.Register, data: u16) {
  upper^ = u8(data >> 8)
  lower^ = u8(data)
}

@(private = "file")
intoBC_ :: proc(c: ^cpu.Cpu, operand: Operand) {
  data := operandIsU16(operand)
  intoRegisterPair(&c.registers.b, &c.registers.c, data)
}

intoBC :: proc(c: ^cpu.Cpu) -> Operand {
  return intoBC_
}

@(private = "file")
intoDE_ :: proc(c: ^cpu.Cpu, operand: Operand) {
  data := operandIsU16(operand)
  intoRegisterPair(&c.registers.d, &c.registers.e, data)
}

intoDE :: proc(c: ^cpu.Cpu) -> Operand {
  return intoDE_
}

@(private = "file")
intoHL_ :: proc(c: ^cpu.Cpu, operand: Operand) {
  data := operandIsU16(operand)
  intoRegisterPair(&c.registers.h, &c.registers.l, data)
}

intoHL :: proc(c: ^cpu.Cpu) -> Operand {
  return intoHL_
}

@(private = "file")
intoA_ :: proc(c: ^cpu.Cpu, operand: Operand) {
  data := operandIsU8(operand)
  c.registers.a = data
}

intoA :: proc(c: ^cpu.Cpu) -> Operand {
  return intoA_
}

@(private = "file")
intoB_ :: proc(c: ^cpu.Cpu, operand: Operand) {
  data := operandIsU8(operand)
  c.registers.b = data
}

intoB :: proc(c: ^cpu.Cpu) -> Operand {
  return intoB_
}

@(private = "file")
intoC_ :: proc(c: ^cpu.Cpu, operand: Operand) {
  data := operandIsU8(operand)
  c.registers.c = data
}

intoC :: proc(c: ^cpu.Cpu) -> Operand {
  return intoC_
}

@(private = "file")
intoD_ :: proc(c: ^cpu.Cpu, operand: Operand) {
  data := operandIsU8(operand)
  c.registers.d = data
}

intoD :: proc(c: ^cpu.Cpu) -> Operand {
  return intoD_
}

@(private = "file")
intoE_ :: proc(c: ^cpu.Cpu, operand: Operand) {
  data := operandIsU8(operand)
  c.registers.e = data
}

intoE :: proc(c: ^cpu.Cpu) -> Operand {
  return intoE_
}

@(private = "file")
intoH_ :: proc(c: ^cpu.Cpu, operand: Operand) {
  data := operandIsU8(operand)
  c.registers.h = data
}

intoH :: proc(c: ^cpu.Cpu) -> Operand {
  return intoH_
}

@(private = "file")
intoL_ :: proc(c: ^cpu.Cpu, operand: Operand) {
  data := operandIsU8(operand)
  c.registers.l = data
}

intoL :: proc(c: ^cpu.Cpu) -> Operand {
  return intoL_
}

@(private = "file")
intoSP_ :: proc(c: ^cpu.Cpu, operand: Operand) {
  data := operandIsU16(operand)
  c.registers.sp = data
}

intoSP :: proc(c: ^cpu.Cpu) -> Operand {
  return intoSP_
}

intoRamBC :: proc(c: ^cpu.Cpu) -> Operand {
  return proc(c: ^cpu.Cpu, o: Operand) {
    location := cpu.readBC(c)
     
    bus.write(c.bus, location, c.registers.a)
  }
}