package ppu

@(private)
LCDC_REGISTER_ADDRESS :: 0xFF40

LCDC_Register :: bit_field u8 {
  priorityBgWindowEnabled: bool | 1,
  objEnabled:              bool | 1,
  objSize:                 bool | 1,
  bgTilemap:               bool | 1,
  bgWindowTilemap:         bool | 1,
  windowEnabled:           bool | 1,
  windowTileMap:           bool | 1,
  lcdEnabled:              bool | 1,
}
