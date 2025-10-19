package cartridge

import "core:os"
import "core:fmt"
import "core:strings"

// https://gbdev.io/pandocs/The_Cartridge_Header.html

CartridgeType :: enum u8 {
  ROM_ONLY = 0x00,
  MBC1 = 0x01,
  MBC1_RAM = 0x02,
  MBC1_RAM_BATTERY = 0x03,
  MBC2 = 0x05,
  MBC2_BATTERY = 0x06,
  ROM_RAM = 0x08, // No licensed cartridge makes use of this option. The exact behavior is unknown.
  ROM_RAM_BATTERY = 0x09, // No licensed cartridge makes use of this option. The exact behavior is unknown.
  MMM01 = 0x0B,
  MMM01_RAM = 0x0C,
  MMM01_RAM_BATTERY = 0x0D,
  MBC3_TIMER_BATTERY = 0x0F,
  MBC3_TIMER_RAM_BATTERY = 0x10, // MBC3 with 64 KiB of SRAM refers to MBC30, used only in Pocket Monsters: Crystal Version (the Japanese version of Pokémon Crystal Version).
  MBC3 = 0x11,
  MBC3_RAM = 0x12, // MBC3 with 64 KiB of SRAM refers to MBC30, used only in Pocket Monsters: Crystal Version (the Japanese version of Pokémon Crystal Version).
  MBC3_RAM_BATTERY = 0x13, // MBC3 with 64 KiB of SRAM refers to MBC30, used only in Pocket Monsters: Crystal Version (the Japanese version of Pokémon Crystal Version).
  MBC5 = 0x19,
  MBC5_RAM = 0x1A,
  MBC5_RAM_BATTERY = 0x1B,
  MBC5_RUMBLE = 0x1C,
  MBC5_RUMBLE_RAM = 0x1D,
  MBC5_RUMBLE_RAM_BATTERY = 0x1E,
  MBC6 = 0x20,
  MBC7_SENSOR_RUMBLE_RAM_BATTERY = 0x22,
  POCKET_CAMERA = 0xFC,
  BANDAI_TAMA5 = 0xFD,
  HuC3 = 0xFE,
  HuC1_RAM_BATTERY = 0xFF
}

RamSize :: enum u8 {
  NoRAM = 0x00,
  Unused = 0x01,
  SingleBank_8KiB = 0x02,
  FourBanks_32KiB = 0x03,
  SixteenBanks_128KiB = 0x04,
  EightBanks_64KiB = 0x05
}

RomHeader :: struct {
  title: string,
  ramSize: RamSize,
  sizeKiB: i64,
  version: int,
  cartridgeType: CartridgeType,
  validation: struct {
    checksum: byte,
    parityByte: byte
  }
}

@(private = "file")
readBytesAt :: proc(handle: os.Handle, offset: int, length: int) -> []byte {
  buffer := make([]byte, length)
  bytesRead, err := os.read_at(handle, buffer, i64(offset))

  if err != nil {
    panic(strings.join({"Encountered error while reading ROM:\n\t", os.error_string(err)}, ""))
  }

  if bytesRead != length {
    panic("Did not read the expected number of bytes")
  }
  
  return buffer
}

@(private = "file")
readByteAt :: proc(handle: os.Handle, offset: int) -> byte {
  buffer := readBytesAt(handle, offset, 1)

  return buffer[0]
}

@(private = "file")
ROM_TITLE_PTR, ROM_TITLE_LENGTH :: 0x0134, 16

@(private = "file")
readRomTitle :: proc(handle: os.Handle) -> string {
  buf := readBytesAt(handle, ROM_TITLE_PTR, ROM_TITLE_LENGTH)

  // Trim the end of 0x00 chars
  for buf[len(buf) - 1] == 0x00 {
    buf = buf[:len(buf) - 1]
  }

  return string(buf[:])
}

// Pointers to ROM header sections of interest
@(private = "file")
CARTRIDGE_TYPE_PTR, ROM_SIZE_PTR, RAM_SIZE_PTR, ROM_VERSION_NUMBER_PTR :: 0x0147, 0x0148, 0x0149, 0x014C

@(private = "file")
readCartridgeType :: proc(handle: os.Handle) -> CartridgeType {
  cartridgeType := readByteAt(handle, CARTRIDGE_TYPE_PTR)

  for type in CartridgeType {
    if cartridgeType == u8(type) {
      return type
    }
  }

  panic("Could not match cartridge type")
}

@(private = "file")
readRomSizeKiB :: proc(handle: os.Handle) -> i64 {
  romSize := readByteAt(handle, ROM_SIZE_PTR)

  return 32 << romSize
}

@(private = "file")
readRamSize :: proc(handle: os.Handle) -> RamSize {
  ramSize := readByteAt(handle, RAM_SIZE_PTR)

  for type in RamSize {
    if ramSize == u8(type) {
      return type
    }
  }

  panic("Could not match RAM size")
}

@(private = "file")
readRomVersionNumber :: proc(handle: os.Handle) -> int {
  version := readByteAt(handle, ROM_VERSION_NUMBER_PTR)

  return int(version)
}

@(private = "file")
HEADER_CHECKSUM_PTR, HEADER_CHECKSUM_LENGTH, HEADER_PARITY_BYTE :: 0x0134, 25, 0x014D

@(private = "file")
readRomChecksum :: proc(handle: os.Handle) -> (u8, byte) {
  checksum: u8 = 0
  buffer := readBytesAt(handle, HEADER_CHECKSUM_PTR, HEADER_CHECKSUM_LENGTH)

  for cell in buffer {
    checksum = checksum - cell - 1
  }

  parityByte := readByteAt(handle, HEADER_PARITY_BYTE)

  return checksum, parityByte
}

isRomValid :: proc(header: RomHeader) -> bool {
  return header.validation.checksum == header.validation.parityByte
}

getRomHeader :: proc(handle: os.Handle) -> RomHeader {
  checksum, parityByte := readRomChecksum(handle)

  return RomHeader {
    title = readRomTitle(handle),
    ramSize = readRamSize(handle),
    sizeKiB = readRomSizeKiB(handle),
    version = readRomVersionNumber(handle),
    cartridgeType = readCartridgeType(handle),
    validation = {
      checksum = checksum,
      parityByte = parityByte
    }
  }
}