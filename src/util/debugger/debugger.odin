#+feature dynamic-literals

package debugger

import "core:strconv"
import "core:slice"
import "core:os"
import "core:fmt"
import "core:log"
import "core:strings"

import _cpu "../../cpu"

T :: struct {
  cpu: ^_cpu.Cpu,
  commands: map[string]proc(debugger: ^T, args: []string) -> bool,

  stepping: bool,
  breakpoints: map[u16]bool
}

create :: proc(cpu: ^_cpu.Cpu) -> T {
  return T {
    cpu = cpu,
    commands = {
      "print" = print,
      "next" = next,
      "exec" = next,
      "set" = set,
      "help" = help,
      "continue" = continueToNextBreakpoint,
      "exit" = proc(debugger: ^T, args: []string) -> bool {
        os.exit(0)
      }
    },
    stepping = false,
    breakpoints = {
      0x100 = true
    }
  }
}

debugStep :: proc(debugger: ^T) {
  if !debugger.stepping {
    if !(debugger.cpu.registers.pc in debugger.breakpoints) {
      return
    }

    log.infof("Triggered breakpoint at %#04X", debugger.cpu.registers.pc)
    debugger.stepping = true
  }

  for true {
    input := readUntilNewline()
    command, err := strings.split(input, " ") // Will get messed up but multiple spaces "  "

    fn, found := debugger.commands[command[0]]
    if !found {
      log.debug("Command \"", command, "\" was not recognized!", sep="")
      continue
    }

    done := fn(debugger, command)
    if done {
      break
    }
  }
}

@(private)
readUntilNewline :: proc() -> string {
  buffer := make([]byte, 0xFF)

  fmt.print("gameboy --> ")
  n, err := os.read(os.stdin, buffer)
  if err != nil {
    log.error(err)
    panic("Error reading from stdin")
  }

  return string(buffer[:n - 1])
}
