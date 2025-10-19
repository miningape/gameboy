package cartridge

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

readCartridge :: proc(filepath: string) -> ([]byte, os.Error) {
  fmt.println("Reading cartridge...")

  handle, openErr := os.open(filepath)
  if openErr != nil {
    return nil, openErr
  }
  defer os.close(handle)

  header := getRomHeader(handle)

  size, error := assertRomSize(handle, i64(header.sizeKiB * 1024))
  if error != nil {
    return nil, error
  }

  fmt.println()
  fmt.println(header)
  fmt.print("This rom is ")
  fmt.println(isRomValid(header) ? "uncorrupted" : "corrupted")
  fmt.println()

  buf := make([]byte, size)
  _, error = os.read(handle, buf)
  if error != nil {
    return nil, error
  }

  return buf, nil
}
