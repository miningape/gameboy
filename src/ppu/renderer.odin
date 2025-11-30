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

  bus: ^_bus.Bus,
  lcdcRegister: ^LCDC_Register, // LCDC Register 0xFF40 - https://gbdev.io/pandocs/LCDC.html#ff40--lcdc-lcd-control
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

// https://lospec.com/palette-list/nintendo-gameboy-bgbd
@(private="file")
palette :: proc(format: ^SDL.PixelFormat) -> [4]u32 {
  return {
    0b00 = SDL.MapRGBA(format, 0xc5, 0xde, 0x8c, 0xFF),
    0b01 = SDL.MapRGBA(format, 0x84, 0xa5, 0x63, 0xFF),
    0b10 = SDL.MapRGBA(format, 0x39, 0x61, 0x39, 0xFF),
    0b11 = SDL.MapRGBA(format, 0x08, 0x18, 0x10, 0xFF)
  }
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

  texture := renderSprite(renderer, window)

  lcdcRegisterPointer := _bus.pointer(bus, LCDC_REGISTER_ADDRESS)
  lcdcRegister := cast(^LCDC_Register)lcdcRegisterPointer

  return T {
    window,
    renderer,
    texture,
    bus,
    lcdcRegister
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

  if !renderer.lcdcRegister.lcdEnabled {
    // https://gbdev.io/pandocs/LCDC.html#lcdc7--lcd-enable
    // Ligher color when disabled: #d2e6a7 (technically should be delayed by a frame)
    SDL.SetRenderDrawColor(renderer.renderer, 0xD2, 0xE6, 0xA7, 255)
    SDL.RenderClear(renderer.renderer)
    SDL.RenderPresent(renderer.renderer)
    return true
  }

  SDL.SetRenderDrawColor(renderer.renderer, 0xc5, 0xde, 0x8c, 255)
  SDL.RenderClear(renderer.renderer)
  SDL.RenderCopy(renderer.renderer, renderer.texture, &{0, 0, 8, 8}, &{8, 8, 64, 64})

  SDL.RenderPresent(renderer.renderer)

  return true
}

setPixel :: proc(surface: ^SDL.Surface, x: i32, y: i32, pixel: u32) {
  pixels := cast(^u8)surface.pixels

  pixelPtr := cast(^u32) mem.ptr_offset(pixels, (surface.pitch * y) + (i32(surface.format.BytesPerPixel) * x))
  pixelPtr^ = pixel
}

renderSprite :: proc(renderer: ^SDL.Renderer, window: ^SDL.Window) -> ^SDL.Texture {
  format := SDL.GetWindowPixelFormat(window)
  surface := SDL.CreateRGBSurfaceWithFormat(0, 8, 8, 32, u32(format))
  defer SDL.FreeSurface(surface)

  palette := palette(surface.format)

  SDL.LockSurface(surface)

  for line := 0; line < 8 * 2; line += 2 {
    lower := gameboyImage[line]
    upper := gameboyImage[line + 1]

    for bit := 7; bit >= 0; bit -= 1 {
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
