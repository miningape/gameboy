package debugger

import "core:log"

import "../../cpu"

@(private)
print :: proc(debugger: ^T, args: []string) -> bool {
  if len(args) != 2 {
    log.error("Didn't supply right amount of args for print, recieved", args)
    return false
  }
    
  target := args[1]

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
