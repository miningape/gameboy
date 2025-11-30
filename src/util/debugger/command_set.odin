package debugger

import "core:strconv"
import "core:log"

import "../../../src/bus"

@(private)
set :: proc(debugger: ^T, args: []string) -> bool {
  switch args[1] {
    case "breakpoint":
      return setBreakpoint(debugger, args)

    case "memory":
      if len(args) != 4 { // set memory address value
        log.errorf("Incorrect args supplied to `set memory $address $value`,  %w", args)
      }

      
      address, parsedAddress := getAddress(args)
      if !parsedAddress {
        return false
      }

      value, parsedValue := getValue(args)
      if !parsedValue {
        return false
      }

      bus.write(debugger.cpu.bus, address, value)
      return false
      
    case:
      log.warnf("Unrecognised `set` target: %s", args[1])
  }

  return false
}

@(private="file")
getAddress :: proc(args: []string) -> (u16, bool) {
  str := args[2]
  arg, parsed := strconv.parse_u64_maybe_prefixed(str)
  if !parsed {
    log.errorf("Could not parse uint \"%s\" in command %w (address, 3rd position)", str, args)
    return 0, false
  }

  if arg > 0xFFFF {
    log.warnf("Address %s out of range (0x0000 - 0xFFFF), truncating", str)
  }

  return u16(arg), true
}

@(private="file")
getValue :: proc(args: []string) -> (u8, bool) {
  str := args[3]
  arg, parsed := strconv.parse_u64_maybe_prefixed(str)
  if !parsed {
    log.errorf("Could not parse uint \"%s\" in command %w (value, 4th position)", str, args)
    return 0, false
  }

  if arg > 0xFF {
    log.warnf("Value %s out of range (0x00 - 0xFF), truncating", str)
  }

  return u8(arg), true
}
