package scratch_test

import "core:testing"
import "core:log"

@(test)
convertU8ToS8 :: proc(t: ^testing.T) {
  maxu8: u8 = 0xFF 
  neg1 := i8 (maxu8)


  log.debug(maxu8, neg1)
}

@(test)
dropSignBit :: proc(t: ^testing.T) {
  value := u8(0xFF) // signed -1
  isNegative := (0b1000_0000 & value) != 0

  dropped := isNegative ? u16(~value + 1) : u16(value)

  log.infof("negative = %t, %#04X = %i -> %i, sign removed: %#04X = %i -> %i", isNegative, value, value, i8(value), dropped, dropped, dropped)
}
