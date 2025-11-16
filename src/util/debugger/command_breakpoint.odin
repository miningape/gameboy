package debugger

import "core:log"
import "core:strconv"

@(private)
setBreakpoint :: proc(debugger: ^T, args: []string) -> bool {
  breakpoint := args[2]
  arg, parsed := strconv.parse_u64_maybe_prefixed(breakpoint)
  if !parsed {
    log.errorf("Could not parse uint \"%s\" in command %w", breakpoint, args)
    return false
  }

  address := u16(arg)
  if arg != u64(address) {
    log.warnf("Breakpoint out of range, got: %#X, truncated: %#04X\n", arg, address)
  }

  log.infof("Breakpoint set at %#04X", address)

  debugger.breakpoints[address] = true
  return false
}

@(private)
continueToNextBreakpoint :: proc(debugger: ^T, args: []string) -> bool {
  if len(args) > 1 {
    log.warn("Too many arguments passed to `next` - recieved:", args)
  }

  debugger.stepping = false
  return true
}
