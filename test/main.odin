package main

import "core:fmt"
import "core:os"

SharedMem :: struct #raw_union {
  shared: u16,
  split: [2]u8
}

main :: proc() {
  upper: u8 = 0
  lower: u8 = 0xFF

  mem: SharedMem = {
    split = { upper, lower }
  }

  mem.shared += 1

  fmt.println(os.ENDIAN == .Little, "Endian")
  fmt.printf("Original: %02X %02X\n", upper, lower)
  fmt.printf("Shared: %04X\n", mem.shared)
  fmt.printf("Split: %02X %02X\n", mem.split[0], mem.split[1])
}