package instructions

import "../"
import "../../bus"
import op "../operands"

LD :: proc(c: ^cpu.Cpu, i: Instruction) {
  cpu.incrementPC(c)

  operand := i.left(c)
  data := i.right(c)

  switch left in operand {
    case op.Pointer:
      left^ = op.operandIsU8(data)

    case op.Register:
      op.intoRegister(left, data)

    case op.Literal:
      switch literal in left {
        case u8:
          panic("Cannot LD into u8")
    
        case u16:
          panic("Cannot LD into u16")

        case bool:
          panic("Cannot LD into boolean")
      }
  }

  // LD never affects flags
}

LDI :: proc(c: ^cpu.Cpu, instruction: Instruction) {
  // Only valid combinations are
  // LD [HL+] A
  // LD A [HL+]
  // We always subtract from the combo register (HL), but read/write from the memory location

  cpu.incrementPC(c)

  switch register in instruction.left(c).(op.Register) {
    case ^cpu.Register: // Read from 8 bit register
      address_register := instruction.right(c).(op.Register).([2]^cpu.Register)
      address := cpu.unify(address_register)

      bus.write(c.bus, address, register^)
      address += 1

      address_register[0]^, address_register[1]^ = cpu.split(address)

    case [2]^cpu.Register: // Write to address of combo register
      address := cpu.unify(register)
      data_register := instruction.right(c).(op.Register).(^cpu.Register)

      bus.write(c.bus, address, data_register^)
      address += 1

      register[0]^, register[1]^ = cpu.split(address)

    case ^cpu.Register16:
      panic("Cannot LDI a 16 bit register")
  }

  // LDI never affects flags
}

LDD :: proc(c: ^cpu.Cpu, instruction: Instruction) {
  // Only valid combinations are
  // LD [HL-] A
  // LD A [HL-]
  // We always subtract from the combo register (HL), but read/write from the memory location
  
  cpu.incrementPC(c)

  switch register in instruction.left(c).(op.Register) {
    case ^cpu.Register: // Read from 8 bit register
      address_register := instruction.right(c).(op.Register).([2]^cpu.Register)
      address := cpu.unify(address_register)

      bus.write(c.bus, address, register^)
      address -= 1

      address_register[0]^, address_register[1]^ = cpu.split(address)
    
    case [2]^cpu.Register: // Write to address of combo register
      address := cpu.unify(register)
      data_register := instruction.right(c).(op.Register).(^cpu.Register)

      bus.write(c.bus, address, data_register^)
      address -= 1

      register[0]^, register[1]^ = cpu.split(address)

    case ^cpu.Register16:
      panic("Cannot LDD a 16 bit register")
  }

  // LDD never affects flags
}
