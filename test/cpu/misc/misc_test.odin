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

@(test)
shouldComplementRegister :: proc(t: ^testing.T) {
  using _cpu

  cpu := lib.emulate({ lib.CPL }, proc(cpu: ^Cpu) {
    cpu.registers.a = 0b1010_0101

    setFlagZ(cpu, false)
    setFlagN(cpu, false)
    setFlagH(cpu, false)
    setFlagC(cpu, true)
  })

  testing.expect_value(t, cpu.registers.a, 0b0101_1010)
  testing.expect_value(t, getFlagZ(&cpu), false) // Unaffected
  testing.expect_value(t, getFlagN(&cpu), true)
  testing.expect_value(t, getFlagH(&cpu), true)
  testing.expect_value(t, getFlagC(&cpu), true)  // Unaffected
}
