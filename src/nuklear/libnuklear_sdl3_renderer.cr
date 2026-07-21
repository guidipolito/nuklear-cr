require "./libnuklear"
require "sdl3"
require "sdl3/image"

@[Link("nuklear", ldflags: "-L#{__DIR__}/../../c_wrapper/sdl3_renderer/build/ -lnuklear -Wl,-rpath,#{__DIR__}/../../c_wrapper/sdl3_renderer/build/")]
lib LibNK
  fun sdl_init = nk_sdl_init(win: LibSdl3::Window*, renderer : LibSdl3::Renderer*, allocator : Allocator) : Context*
  fun sdl_allocator = nk_sdl_allocator() : Allocator
  fun sdl_font_stash_begin = nk_sdl_font_stash_begin(ctx : Context*) : FontAtlas*
  fun sdl_font_stash_end = nk_sdl_font_stash_end(ctx : Context*)
  fun sdl_render = nk_sdl_render(ctx : Context*, aa : AntiAliasing)

  fun sdl_handle_event = nk_sdl_handle_event(ctx : Context*, event : LibSdl3::Event*);
  fun sdl_update_TextInput = nk_sdl_update_TextInput(ctx : Context*)
end

class Nuklear
  @renderer : Sdl3::Renderer
  @win : Sdl3::Window
  @userfont_default : LibNK::UserFont

  def initialize(win : Sdl3::Window)
    @allocator =  LibNK.sdl_allocator()
    @renderer = win.renderer.not_nil!
    @win = win
    @ctx = LibNK.sdl_init(@win.to_unsafe, @renderer.to_unsafe, @allocator)

    @font_config = LibNK.font_config(0)
    # ====== Setting default font
    @atlas = LibNK.sdl_font_stash_begin(@ctx)
    @font_default = LibNK.font_atlas_add_default(@atlas, 13, pointerof(@font_config));
    LibNK.sdl_font_stash_end(@ctx)

    @userfont_default = @font_default.value.handle
    LibNK.style_set_font(@ctx, pointerof(@userfont_default))
  end

  def handle_input( event : Sdl3::Event)
    LibNK.sdl_handle_event(@ctx, event.to_unsafe)
  end

  def frame_start
  end

  def frame_end
    LibNK.sdl_render(@ctx, LibNK::AntiAliasing::NkAntiAliasingOn)
    LibNK.sdl_update_TextInput(@ctx);
  end
end
