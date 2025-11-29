package bus

import "core:log"

// Will need to fill out more later 
// Memory Bank Controllers (MBC): https://gbdev.io/pandocs/MBCs.html

// Memory map: https://gbdev.io/pandocs/Memory_Map.html
// ----------------------------------------------------
// 0xFFFF - Interrup Enable register (IE)
// 0xFF80 - High RAM (fast)
// 0xFF00 - I/O Registers
// 0xFEA0 - Not usable
// 0xFE00 - OAM
// 0xE000 - Echo RAM, prohibited
// 0xC000 - RAM, Work RAM
// 0xA000 - RAM, External
// 0x8000 - VRAM
// 0x4000 - ROM, Cartridge switchable bank
// 0x0000 - ROM, Cartridge bank 0

Bus :: struct {
  rom: []byte,
  vram: []byte,
  ram: []byte,
  hram: []byte // Includes IE register
}

createBus :: proc(rom: []byte) -> Bus {
  log.debug("Creating bus...")
  return Bus {
    rom, // Maybe bus should read rom?
    make([]byte, 0x2000), // 8 KiB video ram (vram)
    make([]byte, 0x2000), // 8 KiB work ram (ram / wram)
    make([]byte, 0x0100), // 255 (ff) bytes high ram (hram) + IE register
  }
}

read :: proc(bus: ^Bus, location: u16) -> byte {
  switch location {
    // ROM cartridge, including 1 switch bank (i.e. no switching)
    case 0x0000..<0x8000:
      return bus.rom[location]

    // Video RAM
    case 0x8000..<0xA000:
      return bus.vram[location - 0x8000]

    // Work RAM
    case 0xC000..<0xE000:
      return bus.ram[location - 0xC000]

    // High RAM
    case 0xFF00..=0xFFFF:
      return bus.hram[location - 0xFF00]
  }

  log.errorf("Reading memory: 0x%04X", location)
  panic("Tried to access an unmapped area of memory")
}

write :: proc(bus: ^Bus, location: u16, data: byte) {
  switch location {
    // ROM cartridge, including 1 switch bank (i.e. no switching)
    case 0x0000..<0x8000:
      panic("Cannot write to ROM cartridge")

    // Video RAM
    case 0x8000..<0xA000:
      bus.vram[location - 0x8000] = data
      return

    // Work RAM
    case 0xC000..<0xE000:
      bus.ram[location - 0xC000] = data
      return

    // High RAM
    case 0xFF00..=0xFFFF:
      bus.hram[location - 0xFF00] = data
      return
  }

  log.errorf("Writing memory: 0x%04X - data: 0x%02X", location, data)
  panic("Tried to access an unmapped area of memory")
}

pointer :: proc(bus: ^Bus, location: u16) -> ^byte {
  switch location {
    // ROM cartridge, including 1 switch bank (i.e. no switching)
    case 0x0000..<0x8000:
      panic("Cannot create a pointer to ROM")
      // return &bus.rom[location]

    // Video RAM
    case 0x8000..<0xA000:
      return &bus.vram[location - 0x8000]

    // Work RAM
    case 0xC000..<0xE000:
      return &bus.ram[location - 0xC000]

    // High RAM
    case 0xFF00..=0xFFFF:
      return &bus.hram[location - 0xFF00]
  }

  log.debugf("Pointer to (inc): 0x%04X", location)
  panic("Tried to access an unmapped area of memory")
}

cleanupBus :: proc(bus: ^Bus) {
  delete(bus.rom)
  delete(bus.ram)
  delete(bus.hram)
}
