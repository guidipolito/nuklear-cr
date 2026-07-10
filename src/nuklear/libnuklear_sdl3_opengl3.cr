require "./libnuklear"
require "sdl3"

@[Link("nuklear")]
lib LibNK
  fun sdl_init = nk_sdl_init(win : LibSdl3::Window*) : Context*
  fun sdl_font_stash_begin = nk_sdl_font_stash_begin(ctx : FontAtlas**)
  fun sdl_font_stash_end = nk_sdl_font_stash_end()
  fun sdl_render = nk_sdl_render(aa : AntiAliasing, max_vertex_buffer : LibC::Int, max_element_buffer : LibC::Int)

  fun sdl_handle_event = nk_sdl_handle_event(ctx : Context*, event : LibSdl3::Event*);
  fun sdl_update_TextInput = nk_sdl_update_TextInput(ctx : Context*)
end

class Nuklear
  def initialize(win : LibSdl3::Window*)
    @nk_ctx = LibNK.sdl_init win
  end
end
