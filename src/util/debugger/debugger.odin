#+feature dynamic-literals

package debugger

import "core:fmt"
import "base:runtime"
import "core:log"
import "core:strings"

import "../cli"
import "../resources"
import _cpu "../../cpu"

T :: struct {
  cpu: ^_cpu.Cpu,
  stdin: ^cli.Stdin,

  commands: map[string]proc(debugger: ^T, args: []string) -> bool,

  logged: bool,
  stepping: bool,
  breakpoints: map[u16]bool
}

create :: proc(cpu: ^_cpu.Cpu, stdin: ^cli.Stdin, allocator: runtime.Allocator) -> T {
  return T {
    cpu = cpu,
    stdin = stdin,
    commands = {
      "print" = print,
      "next" = next,
      "exec" = next,
      "set" = set,
      "help" = help,
      "continue" = continueToNextBreakpoint,
      "regs" = proc(debugger: ^T, args: []string) -> bool {
        return print(debugger, {"print", "regs"})
      },
      "exit" = proc(debugger: ^T, args: []string) -> bool {\
        debugger.cpu.done = true
        return true
      }
    },
    stepping = false,
    breakpoints = {
      0x100 = true
    }
  }
}

step :: proc(debugger: ^T) -> bool {
  if !debugger.stepping {
    if !(debugger.cpu.registers.pc in debugger.breakpoints) {
      opcode, description := resources.describeCurrentOpcode(debugger.cpu)
      log.infof("$%04X = %#02X %s", debugger.cpu.registers.pc, opcode, description)
      
      return true
    }

    log.infof("Triggered breakpoint at %#04X", debugger.cpu.registers.pc)
    debugger.stepping = true
  }

  if !debugger.logged {
    opcode, description := resources.describeCurrentOpcode(debugger.cpu)
    log.infof("$%04X = %#02X %s", debugger.cpu.registers.pc, opcode, description)

    fmt.print("gameboy --> ")
    debugger.logged = true
  }

  input, didRead := cli.read(debugger.stdin)
  if !didRead {
    return false
  }

  debugger.logged = false
  command, err := strings.split(input, " ") // Will get messed up but multiple spaces "  "

  fn, found := debugger.commands[command[0]]
  if !found {
    log.debugf("Command \"&s\" was not recognized!", command)
    return false
  }

  return fn(debugger, command)
}
