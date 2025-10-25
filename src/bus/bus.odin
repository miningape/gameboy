package bus

// Will need to fill out more later 
// Memory map: https://gbdev.io/pandocs/Memory_Map.html
// Memory Bank Controllers (MBC): https://gbdev.io/pandocs/MBCs.html

import "core:fmt"

Bus :: struct {
  rom: ^[]byte
}

createBus :: proc(rom: ^[]byte) -> Bus {
  fmt.println("Creating bus...")
  return Bus {
    rom
  }
}

read :: proc(bus: ^Bus, location: u16) -> byte {
  return bus.rom[location]
}

write :: proc(bus: ^Bus, location: u16, data: byte) {
  bus.rom[location] = data
}

increment :: proc(bus: ^Bus, location: u16) {
  bus.rom[location] += 1
}
