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
  @win : Sdl3::Window
  @userfont_default : LibNK::UserFont
  @atlas_ptr : LibNK::FontAtlas*
  def initialize(@win : Sdl3::Window)
    @ctx = LibNK.sdl_init @win.to_unsafe

    @font_config = LibNK.font_config(0)
    # ====== Setting default font
    @atlas = LibNK::FontAtlas.new
    @atlas_ptr = pointerof(@atlas)
    LibNK.sdl_font_stash_begin(pointerof(@atlas_ptr))
    @font_default = LibNK.font_atlas_add_default(@atlas_ptr, 13, pointerof(@font_config));
    LibNK.sdl_font_stash_end()

    @userfont_default = @font_default.value.handle
    LibNK.style_set_font(@ctx, pointerof(@userfont_default))
  end

  def handle_input( event : Sdl3::Event)
    LibNK.sdl_handle_event(@ctx, event.to_unsafe)
  end

  def frame_start
  end

  def frame_end
    LibNK.sdl_render(LibNK::AntiAliasing::NkAntiAliasingOn, 9999, 9999)
    LibNK.sdl_update_TextInput(@ctx);
  end
end

