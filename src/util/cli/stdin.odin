package cli

import "base:runtime"
import "core:os"
import "core:log"
import "core:time"
import "core:sync/chan"
import _thread "core:thread"

@(private="file")
MS_IN_NS :: 1e6

Stdin :: struct {
  channel: chan.Chan(string),
  thread: ^_thread.Thread
}

createListener :: proc(allocator: runtime.Allocator) -> ^Stdin {
  channel, err := chan.create_buffered(chan.Chan(string), 6, allocator)
  if err != nil {
    log.error(err)
    panic("Could not read from stdin")
  }

  // Thread must not create other threads or hold critical resources as it will be forcibly terminated
  thread := _thread.create_and_start_with_poly_data(channel, proc(channel: chan.Chan(string)) {
    buffer := make([]byte, 0xFF)
    defer delete(buffer)

    for !chan.is_closed(channel) {
      read, err := os.read(os.stdin, buffer)
      if err != nil {
        chan.close(channel)
        log.error(err)
        panic("Could not read from stdin")
      }

      ok := chan.send(channel, string(buffer[:read - 1]))
      if !ok {
        chan.close(channel)
        panic("Stdin - could not send line")
      }

      // Not great, but it gives the main thread a chance to close the channel before we lock up, and eases pressure on computers
      time.sleep(50 * MS_IN_NS) // 50 ms
    }
  })

  stdin, allocateErr := new_clone(Stdin {
    channel,
    thread
  }, allocator)

  if allocateErr != nil {
    log.error(allocateErr)
    panic("Could not allocate stdin reader")
  }

  return stdin
}

stopListener :: proc(stdin: ^Stdin, allocator: runtime.Allocator) {
  chan.close(stdin.channel)

  _thread.terminate(stdin.thread, 1)

  free(stdin, allocator)
}

read :: proc(stdin: ^Stdin) -> (string, bool) {
  if chan.is_closed(stdin.channel) {
    panic("stdin was closed")
  }

  return chan.try_recv(stdin.channel)
}
