package ppu

import "core:strings"
import "core:mem"
import "core:log"
import SDL "vendor:sdl2"

import _bus "../bus"

T :: distinct struct {
  window: ^SDL.Window,
  renderer: ^SDL.Renderer,
  texture: ^SDL.Texture,

  bus: ^_bus.Bus
}

@(private="file")
gameboyImage := []byte {
  0b00111100, 0b01111110,
  0b01000010, 0b01000010,
  0b01000010, 0b01000010,
  0b01000010, 0b01000010,
  0b01111110, 0b01011110,
  0b01111110, 0b00001010,
  0b01111100, 0b01010110,
  0b00111000, 0b01111100
}

// https://lospec.com/palette-list/nintendo-gameboy-bgb
@(private="file")
palette :: proc(format: ^SDL.PixelFormat) -> [4]u32 {
  return {
    0b00 = SDL.MapRGBA(format, 0xc5, 0xde, 0x8c, 0xFF),
    0b01 = SDL.MapRGBA(format, 0x84, 0xa5, 0x63, 0xFF),
    0b10 = SDL.MapRGBA(format, 0x39, 0x61, 0x39, 0xFF),
    0b11 = SDL.MapRGBA(format, 0x08, 0x18, 0x10, 0xFF)
  }
}

setPixel :: proc(surface: ^SDL.Surface, x: i32, y: i32, pixel: u32) {
  pixels := cast(^u8)surface.pixels

  // (cast(^u32)mem.ptr_offset(pixels, surface.pitch * y + i32(surface.format.BytesPerPixel) * x))^ = pixel
  pixelPtr := cast(^u32) mem.ptr_offset(pixels, (surface.pitch * y) + (i32(surface.format.BytesPerPixel) * x))
  pixelPtr^ = pixel
}

renderSprite :: proc(renderer: ^SDL.Renderer, window: ^SDL.Window) -> ^SDL.Texture {
  format := SDL.PixelFormatEnum.RGBA8888
  surface := SDL.CreateRGBSurfaceWithFormat(0, 8, 8, 32, u32(format))
  // defer SDL.FreeSurface(surface)

  palette := palette(surface.format)

  SDL.LockSurface(surface)

  for line := 0; line < 8 * 2; line += 2 {
    lower := gameboyImage[line]
    upper := gameboyImage[line + 1]

    for bit := 7; bit >= 0; bit -= 1 {
      log.debug(7 - bit, line / 2)
      mask := byte(1) << byte(bit)
      
      lower := (lower & mask) >> byte(bit)
      upper := ((upper & mask) >> byte(bit)) << 1
      
      color := lower + upper
      pixel := palette[color]

      setPixel(surface, i32(7 - bit), i32(line / 2), pixel)
    }
  }

  SDL.UnlockSurface(surface)
  return SDL.CreateTextureFromSurface(renderer, surface)
}

createRenderer :: proc(bus: ^_bus.Bus) -> T {
  sdl_init_error := SDL.Init(SDL.INIT_VIDEO)
  if sdl_init_error != 0 {
    log.error(SDL.GetError())
    panic("Could not initialise SDL")
  }

  window := SDL.CreateWindow("Gameboy", SDL.WINDOWPOS_CENTERED, SDL.WINDOWPOS_CENTERED, 160, 144, SDL.WINDOW_SHOWN | SDL.WINDOW_RESIZABLE)
  if window == nil {
    log.error(SDL.GetError())
    panic("Could not create window")
  }

  renderer := SDL.CreateRenderer(window, -1, SDL.RENDERER_ACCELERATED)
  if renderer == nil {
    log.error(SDL.GetError())
    panic("Could not create renderer")
  }


  // format := SDL.GetWindowPixelFormat(window)
  // surface := SDL.CreateRGBSurfaceWithFormat(0, 8, 8, 32, format)
  // defer SDL.FreeSurface(surface)

  // pixel := SDL.MapRGBA(surface.format, 0x08, 0x18, 0x20, 0xFF)
  // pixel2 := SDL.MapRGBA(surface.format, 0x34, 0x68, 0x56, 0xFF)

  
  // SDL.LockSurface(surface)
  
  // // Convert to u8 so that `mem.ptr_offset` moves us by bytes - `surface.format.BytesPerPixel` tells us how much we should move by
  // // https://stackoverflow.com/questions/20070155/how-to-set-a-pixel-in-a-sdl-surface
  // // https://stackoverflow.com/questions/69259974/pixel-manipulation-with-sdl-surface
  // // https://wiki.libsdl.org/SDL3/SDL_PixelFormat#remarks
  // surface_pixels := cast(^u8)surface.pixels;
  // for x :i32= 0; x < 8; x += 1 {
  //   for y :i32= 0; y < 8; y += 1 {
  //     (cast(^u32)mem.ptr_offset(surface_pixels, surface.pitch * y + i32(surface.format.BytesPerPixel) * x))^ = (x + y )% 2 == 0 ? pixel : pixel2
  //   } 
  // }

  // SDL.UnlockSurface(surface)

  // texture := SDL.CreateTextureFromSurface(renderer, surface)

  texture := renderSprite(renderer, window)
  log.debug("has texture")

  return T {
    window,
    renderer,
    texture,
    bus
  }
}

destroyRenderer :: proc(renderer: ^T) {
  SDL.DestroyTexture(renderer.texture)
  SDL.DestroyRenderer(renderer.renderer)
  SDL.DestroyWindow(renderer.window)

  SDL.Quit()
}

render :: proc(renderer: ^T) -> bool {
  event: SDL.Event
  if SDL.PollEvent(&event) {
    if (event.type == .QUIT) {
      return false
    }
  }
// #c5de8c
  SDL.SetRenderDrawColor(renderer.renderer, 0xc5, 0xde, 0x8c, 255)
  SDL.RenderClear(renderer.renderer)
  SDL.RenderCopy(renderer.renderer, renderer.texture, &{0, 0, 8, 8}, &{8, 8, 64, 64})

  SDL.RenderPresent(renderer.renderer)

  return true
}
