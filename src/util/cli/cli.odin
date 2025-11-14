package cli

import "core:os"
import "core:flags"

EmulatorFlags :: struct {
  file: string `args:"pos=0,required" usage:"The path to the rom you'd like to run"`,
  
  debug: bool `usage:"Enable debug mode"`
}

getFlags :: proc() -> EmulatorFlags {
  emulatorFlags: EmulatorFlags

  flags.parse_or_exit(&emulatorFlags, os.args, .Unix)

  return emulatorFlags
}
