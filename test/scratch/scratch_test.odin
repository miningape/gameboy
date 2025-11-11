package scratch_test

import "core:testing"
import "core:log"

@(test)
convertU8ToS8 :: proc(t: ^testing.T) {
  maxu8: u8 = 0xFF 
  neg1 := i8 (maxu8)


  log.debug(maxu8, neg1)
}
