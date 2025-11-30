package debugger

import "core:log"

import "../../cpu"
import "../../bus"

@(private)
print :: proc(debugger: ^T, args: []string) -> bool {
  target := args[1]

  // TODO: Refactor so each target checks args
  if target == "memory" {
    // TODO: Print memory range / hexdump
    if len(args) != 3 {
      log.error("Didn't supply right amount of args for `print memory`, recieved", args)
      return false
    }

    address, parsedAddress := getAddress(args, 2)
    if !parsedAddress {
      return false
    }
  
    value := bus.read(debugger.cpu.bus, address)
    log.infof("Memory: %#02X (%#08b)", value, value)
    return false
  }

  if len(args) != 2 {
    log.error("Didn't supply right amount of args for print, recieved", args)
    return false
  }
    
  switch target {
    case "regs":
      fallthrough
    case "registers":
      log.info("Registers:", cpu.sprint(debugger.cpu), sep="\n")

    case "flags":
      log.info("Flags:", cpu.sprint_flags(debugger.cpu), sep="\n")

    case "breakpoints":
      log.info("Breakpoints", debugger.breakpoints)

    case:
      log.error("Unrecognized print target \"", target, "\"", sep="")
  }
  
  return false
}
