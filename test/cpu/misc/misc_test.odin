package cpu_misc_test

import "core:testing"

import "../../lib"
import _cpu "../../../src/cpu"


@(test)
shouldSetCarryFlag :: proc(t: ^testing.T) {
  using _cpu

  cpu := lib.emulate({ lib.SCF }, proc(cpu: ^Cpu) {
    setFlagN(cpu, true)
    setFlagH(cpu, true)
    setFlagC(cpu, false)
  })

  testing.expect_value(t, getFlagN(&cpu), false)
  testing.expect_value(t, getFlagH(&cpu), false)
  testing.expect_value(t, getFlagC(&cpu), true)
}

@(test)
shouldToggleCarryFlagOn :: proc(t: ^testing.T) {
  using _cpu

  cpu := lib.emulate({ lib.CCF }, proc(cpu: ^Cpu) {
    setFlagN(cpu, true)
    setFlagH(cpu, true)
    setFlagC(cpu, false)
  })

  testing.expect_value(t, getFlagN(&cpu), false)
  testing.expect_value(t, getFlagH(&cpu), false)
  testing.expect_value(t, getFlagC(&cpu), true)
}

@(test)
shouldToggleCarryFlagOff :: proc(t: ^testing.T) {
  using _cpu

  cpu := lib.emulate({ lib.CCF }, proc(cpu: ^Cpu) {
    setFlagN(cpu, false)
    setFlagH(cpu, false)
    setFlagC(cpu, true)
  })

  testing.expect_value(t, getFlagN(&cpu), false)
  testing.expect_value(t, getFlagH(&cpu), false)
  testing.expect_value(t, getFlagC(&cpu), false)
}
