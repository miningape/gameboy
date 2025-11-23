package ppu

import "core:log"
import SDL "vendor:sdl2"

T :: distinct struct {
  window: ^SDL.Window,
  renderer: ^SDL.Renderer
}

createRenderer :: proc() -> T {
  sdl_init_error := SDL.Init(SDL.INIT_VIDEO)
  if sdl_init_error != 0 {
    log.error(SDL.GetError())
    panic("Could not initialise SDL")
  }

  window := SDL.CreateWindow("Gameboy", 100, 100, 500, 500, SDL.WINDOW_SHOWN | SDL.WINDOW_RESIZABLE)
  if window == nil {
    log.error(SDL.GetError())
    panic("Could not create window")
  }

  renderer := SDL.CreateRenderer(window, -1, SDL.RENDERER_ACCELERATED)
  if renderer == nil {
    log.error(SDL.GetError())
    panic("Could not create renderer")
  }

  return T {
    window,
    renderer
  }
}

destroyRenderer :: proc(renderer: ^T) {
  SDL.DestroyWindow(renderer.window)
  SDL.DestroyRenderer(renderer.renderer)

  SDL.Quit()
}

render :: proc(renderer: ^T) -> bool {
  event: SDL.Event

  if SDL.PollEvent(&event) {
    if (event.type == .QUIT) {
      return false
    }
  }

  SDL.RenderPresent(renderer.renderer)
  SDL.SetRenderDrawColor(renderer.renderer, 0, 0, 0, 100)
  SDL.RenderClear(renderer.renderer)

  return true
}
