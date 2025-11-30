package ppu_test

import "core:testing"

import "../../src/ppu"

@(test)
shouldGetLCDCBitInByte :: proc(t: ^testing.T) {
  memory: byte = 0b0000_0000
  register := cast(^ppu.LCDC_Register)&memory

  memory = 0b1000_0000

  testing.expect_value(t, register.lcdEnabled, true)
  testing.expect_value(t, register.priorityBgWindowEnabled, false)
  testing.expect_value(t, register.objEnabled, false)
  testing.expect_value(t, register.objSize, false)
  testing.expect_value(t, register.bgTilemap, false)
  testing.expect_value(t, register.bgWindowTilemap, false)
  testing.expect_value(t, register.windowEnabled, false)
  testing.expect_value(t, register.windowTileMap, false)
}

@(test)
shouldSetLCDCBitInByte :: proc(t: ^testing.T) {
  memory: byte = 0b0000_0000
  register := cast(^ppu.LCDC_Register)&memory

  register.lcdEnabled = true
  register.bgTilemap = true

  testing.expect_value(t, memory, 0b1000_1000)
}
