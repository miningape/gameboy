package cartridge

import "core:log"
import "core:os"
import "core:fmt"

@(private = "file")
assertRomSize :: proc(handle: os.Handle, stated: i64) -> (i64, os.Error) {
  actual, error := os.file_size(handle)
  if (error != nil) {
    return 0, error
  }

  // assert(stated == actual, "ROM stated size did not match actual size")
  return actual, nil
}

readCartridge :: proc(filepath: string) -> []byte {
  log.debug("Reading cartridge...")

  handle, openErr := os.open(filepath)
  if openErr != nil {
    log.error(openErr)
    panic("Error while opening a file")
  }
  defer os.close(handle)

  header := getRomHeader(handle)

  size, error := assertRomSize(handle, i64(header.sizeKiB * 1024))
  if error != nil {
    log.error(error)
    panic("Error while reading ROM size")
  }

  log.debug("Successfully read header\n", header)
  log.debug("This rom is ", isRomValid(header) ? "uncorrupted" : "corrupted")

  buf := make([]byte, size)
  _, error = os.read(handle, buf)
  if error != nil {
    log.error(error)
    panic("Error reading file")
  }

  return buf
}
