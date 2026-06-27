require "./libnuklear"
require "sdl3"

@[Link("nuklear")]
lib LibNK
  fun sdl_init = nk_sdl_init(win: LibSdl3::Window*, renderer : LibSdl3::Renderer*, allocator : Allocator) : Context*
  fun sdl_allocator = nk_sdl_allocator() : Allocator
  fun sdl_font_stash_begin = nk_sdl_font_stash_begin(ctx : Context*) : FontAtlas*
  fun sdl_font_stash_end = nk_sdl_font_stash_end(ctx : Context*)
  fun sdl_render = nk_sdl_render(ctx : Context*, aa : AntiAliasing)

  fun sdl_handle_event = nk_sdl_handle_event(ctx : Context*, event : LibSdl3::Event*);
  fun sdl_update_TextInput = nk_sdl_update_TextInput(ctx : Context*)
end
