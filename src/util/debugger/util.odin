package debugger

import "core:strconv"
import "core:log"


getAddress :: proc(args: []string, position: byte) -> (u16, bool) {
  str := args[position]
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
