package cpu_math_test

import "core:testing"
import "../../lib"
import _cpu "../../../src/cpu"

@(test)
shouldXorAB :: proc(t: ^testing.T) {
  cpu := lib.emulate({ lib.XOR_A_B }, proc(cpu: ^_cpu.Cpu) {
    cpu.registers.a = 0b1010_1010
    cpu.registers.b = 0b0101_0111
  })

  testing.expect_value(t, cpu.registers.a, 0b1111_1101)
}

@(test)
shouldXorAA_setAto0 :: proc(t: ^testing.T) {
  cpu := lib.emulate({ lib.XOR_A_A }, proc(cpu: ^_cpu.Cpu) {
    cpu.registers.a = 0b1001_0110
  })

  testing.expect_value(t, cpu.registers.a, 0x00)
}

@(test)
shouldXorAu8 :: proc(t: ^testing.T) {
  cpu := lib.emulate({ lib.XOR_A_u8, 0b1001_0110 }, proc(cpu: ^_cpu.Cpu) {
    cpu.registers.a = 0b1010_1010
  })

  testing.expect_value(t, cpu.registers.a, 0b0011_1100)
}

@(test)
shouldXorAHL_ptr :: proc(t: ^testing.T) {
  cpu := lib.emulate({ lib.XOR_A_HL_ptr }, proc(cpu: ^_cpu.Cpu) {
    cpu.bus.ram[0]  = 0b1000_1000
    cpu.registers.a = 0b1001_1001
    cpu.registers.h = 0xC0
    cpu.registers.l = 0x00
  })

  testing.expect_value(t, cpu.registers.a, 0b0001_0001)
}
