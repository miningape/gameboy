#+feature dynamic-literals

package debugger

import "core:os"
import "core:fmt"
import "core:log"

import _cpu "../../cpu"

T :: struct {
  commands: map[string]proc(debugger: ^T) -> bool,
  cpu: ^_cpu.Cpu,
}

create :: proc(cpu: ^_cpu.Cpu) -> T {
  return T {
    cpu = cpu,
    commands = {
      "print reg" = proc(debugger: ^T) -> bool {
        log.debug("Registers:", _cpu.sprint(debugger.cpu), sep="\n")
        return false
      },
      "print flags" = proc(debugger: ^T) -> bool {
        log.debug("Flags:", _cpu.sprint_flags(debugger.cpu), sep="\n")
        return false
      },
      "next" = proc(debugger: ^T) -> bool {
        return true
      }
    }
  }
}

debugStep :: proc(debugger: ^T) {
  for true {
    command := readUntilNewline()

    fn, found := debugger.commands[command]
    if !found {
      log.debug("Command \"", command, "\" was not recognized!")
      continue
    }

    done := fn(debugger)
    if done {
      break
    }
  }
}

@(private)
readUntilNewline :: proc() -> string {
  buffer := make([]byte, 0xFF)

  fmt.print("gameboy > ")
  n, err := os.read(os.stdin, buffer)
  if err != nil {
    log.error(err)
    panic("Error reading from stdin")
  }

  return string(buffer[:n - 1])
}
