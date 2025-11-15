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
      "next" = proc(debugger: ^T, args: []string) -> bool {
        if len(args) > 1 {
          log.warn("Too many arguments passed to `next` - recieved:", args)
        }

        return true
      },
      "breakpoint" = proc(debugger: ^T, args: []string) -> bool {
        arg, parsed := strconv.parse_u64_maybe_prefixed(args[1])
        if !parsed {
          log.error("Could not parse uint \"", args[1], "\"", sep="")
          return false
        }

        address := u16(arg)
        if arg != u64(address) {
          log.warnf("Breakpoint out of range, got: %#X, truncated: %#04X\n", arg, address)
        }

        log.infof("Breakpoint set at %#04X", address)

        debugger.breakpoints[address] = true
        return false
      },
      "continue" = proc(debugger: ^T, args: []string) -> bool {
        if len(args) > 1 {
          log.warn("Too many arguments passed to `next` - recieved:", args)
        }

        debugger.stepping = false
        return true
      },
      "exit" = proc(debugger: ^T, args: []string) -> bool {
        os.exit(0)
      }
    },
    stepping = true,
    breakpoints = {}
  }
}

debugStep :: proc(debugger: ^T) {
  if !debugger.stepping {
    if !(debugger.cpu.registers.pc in debugger.breakpoints) {
      return
    }

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
