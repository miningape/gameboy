package debugger

import "core:log"

@(private)
next :: proc(debugger: ^T, args: []string) -> bool {
  if len(args) > 1 {
    log.warn("Too many arguments passed to `next` - recieved:", args)
  }

  return true
}

@(private)
DEBUGGER_HELP :: `Emulator Debugger Help:
This is the debugger - it's used to step through gameboy ROMs

By default there is a breakpoint set at 0x0100, the entrypoint following the boot ROM

Commands -
  - help      - Print this text
  - next|exec - Executes the current instruction, and steps to the next
  - exit      - Halt execution of the emulator with status 0
  - print     - print some information to the terminal
    Targets:
      - reg|registers - print the current values of all registers
      - flags         - print the current values of all strings
      - breakpoints   - print all currently active breakpoints
  - continue  - Resumes execution, will only stop at a breakpoint
  - set       - Set a debugger variable
    Targets:
      - breakpoint u16 - Set an instruction address to break execution into the debugger

  ** Not implemented
  - disassemble - Print the current and next several operations in human readable text
  - rm|unset    - Unset a variable
    - breakpoint - Remove a set breakpoint so it will not break execution anymore
  - print
    Targets:
      - memory u16 .. u16 - prints memory at specified address range
`

@(private)
help :: proc(debugger: ^T, args: []string) -> bool {
  if len(args) > 1 {
    log.warn("Too many arguments passed to `help` - recieved:", args)
  }

  log.info(DEBUGGER_HELP)
  return false
}
