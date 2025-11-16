package resources

import "core:strings"
import "core:fmt"
import "core:log"
import "core:os"
import "core:encoding/json"

import "../../cpu"
import "../../bus"

@(private)
Operand :: struct {
  name: string,
  immediate: bool,
  increment: bool,
  decrement: bool,
  bytes: u8
}

@(private)
Opcode :: struct {
  mnemonic: string,
  // bytes: u8,
  // cycles: []u8,
  operands: []Operand,
  // immediate: bool,
  flags: struct {
    Z: string,
    N: string,
    H: string,
    C: string
  }
}

@(private)
Opcodes :: struct {
  unprefixed: map[string]Opcode
  // cbprefixed: map[string]Opcode
}

opcodes: Opcodes

describe :: proc(opcode: byte, c: ^cpu.Cpu) -> string {
  if opcodes.unprefixed == nil {
    bytes, success := os.read_entire_file("./resources/opcodes.json")
    if !success {
      panic("Error while reading opcodes.json")
    }

    err := json.unmarshal(bytes, &opcodes)
    if err != nil {
      log.error(err)
      panic("Error while unmarshalling opcodes.json")
    }
  }
  
  key := toKey(opcode)
  operation :=  opcodes.unprefixed[key]

  sb := strings.builder_make()
  fmt.sbprint(&sb, operation.mnemonic, "")

  pc := c.registers.pc

  for operand in operation.operands {
    switch operand.bytes {
      case 0:
        // TODO: Read values in registers / memory
        name := operandName(operand)
        fmt.sbprint(&sb, name)

      case 1:
        pc += 1
        value := bus.read(c.bus, pc)

        name := operandName(operand)  
        fmt.sbprintf(&sb, "%s:(%#02X)", name, value)

      case 2:
        pc += 1
        lower := bus.read(c.bus, pc)
        pc += 1
        upper := bus.read(c.bus, pc)

        name := operandName(operand)
        fmt.sbprintf(&sb, "%s:(%#02X%02X)", name, upper, lower)
    }

    fmt.sbprint(&sb, " ")
  }

  return strings.to_string(sb)
}

@(private)
operandName :: proc(operand: Operand) -> string {
  builder := strings.builder_make()

  ptr_left := ""
  ptr_right := ""
  if operand.immediate == false {
    ptr_left = "["
    ptr_right = "]"
  }

  sign := ""
  if operand.decrement {
    sign = "-"
  } else if operand.increment {
    sign = "+"
  }

  fmt.sbprintf(&builder, "%s%s%s%s", ptr_left, operand.name, sign, ptr_right)

  return strings.to_string(builder)
}

@(private)
toKey :: proc(opcode: byte) -> string {
  builder := strings.builder_make()

  fmt.sbprintf(&builder, "%#02X", opcode) // Can definitely be optimised with just %
  return strings.to_string(builder)
}
