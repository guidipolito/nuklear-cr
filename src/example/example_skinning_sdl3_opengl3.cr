require "opengl"
require "sdl3/image"
require "../nuklear"
require "../nuklear/libnuklear_sdl3_opengl3"


window = Sdl3::Window.new("Demo", 1280, 720, Sdl3::Window::Flags::Resizable|Sdl3::Window::Flags::Opengl)
# Can pass this Context to LibGL, bind buffers and and so on
gl_ctx = LibSdl3.gl_create_context(window)
LibSdl3.gl_make_current(window, gl_ctx)

surface = Sdl3::Image.load("#{__DIR__}/images/buttons.png")
surface = surface.convert LibSdl3::PixelFormat::Rgba32
tex = 0u32
LibGL.gen_textures(1, pointerof(tex))
LibGL.bind_texture(LibGL::TextureTarget::Texture2D, tex)
LibGL.tex_image_2d(LibGL::TextureTarget::Texture2D,  0, LibGL::InternalFormat::RGBA8, surface.width, surface.height, 0u32, LibGL::PixelFormat::RGBA, LibGL::PixelType::UnsignedByte, surface.pixels)
LibGL.generate_mipmap(LibGL::TextureTarget::Texture2D)
LibGL.bind_texture(LibGL::TextureTarget::Texture2D, 0)
button_style = ->(i : Int32) do
  sub = LibNK.rect 58*i, 58*i, 58, 58
  image = LibNK.sub9slice_id(tex, surface.width, surface.height, sub, 14, 14, 14, 14)
  LibNK.style_item_nine_slice(image)
end

surface2 = Sdl3::Image.load("#{__DIR__}/images/panels.png")
surface2 = surface2.convert LibSdl3::PixelFormat::Rgba32
tex2 = 0u32
LibGL.gen_textures(1, pointerof(tex2))
LibGL.bind_texture(LibGL::TextureTarget::Texture2D, tex2)
LibGL.tex_image_2d(LibGL::TextureTarget::Texture2D,  0, LibGL::InternalFormat::RGBA8, surface2.width, surface2.height, 0u32, LibGL::PixelFormat::RGBA, LibGL::PixelType::UnsignedByte, surface2.pixels)
LibGL.generate_mipmap(LibGL::TextureTarget::Texture2D)
LibGL.bind_texture(LibGL::TextureTarget::Texture2D, 0)
panel_style = ->(i : Int32) do
  sub = LibNK.rect 200*i, 200*i, 200, 200
  image = LibNK.sub9slice_id(tex2, surface2.width, surface2.height, sub, 8, 8, 8, 8)
  LibNK.style_item_nine_slice(image)
end

LibGL.enable(LibGL::EnableCap::Blend);
LibGL.blend_func(LibGL::BlendingFactor::SrcAlpha, LibGL::BlendingFactor::OneMinusSrcAlpha);
# example opengl usage
# tex = 0u32
# LibGL.gen_textures(1, pointerof(tex))
nk = Nuklear.new window
#style = LibNK.style_item_image(image)
nk.ctx.value.style.button.normal = button_style.call(0)
nk.ctx.value.style.button.hover = button_style.call(1)
nk.ctx.value.style.button.active = button_style.call(2)
nk.ctx.value.style.window.fixed_background = panel_style.call(1)
nk.ctx.value.style.window.header.active = panel_style.call(0)
nk.ctx.value.style.property.normal = button_style.call(6)
nk.ctx.value.style.property.hover = button_style.call(6)
nk.ctx.value.style.property.active = button_style.call(6)
transparent = LibNK::Color.new
transparent.a = 0
nk.ctx.value.style.window.header.close_button.normal = LibNK.style_item_color(transparent)
nk.ctx.value.style.window.header.minimize_button.normal = LibNK.style_item_color(transparent)
nk.ctx.value.style.property.inc_button.normal = LibNK.style_item_color(transparent)
nk.ctx.value.style.property.dec_button.normal = LibNK.style_item_color(transparent)
nk.ctx.value.style.property.edit.normal = LibNK.style_item_color(transparent)
nk.ctx.value.style.property.padding = LibNK.vec2i 15, 15
running = true
count = 0
while running
  nk.input_begin
  while event = Sdl3::Events.poll
    nk.handle_input event
    case event
    when Sdl3::Event::Quit
      running = false
    end
  end
  nk.input_end
  LibGL.clear_color(0.2, 0.2, 0.3, 1.0)
  LibGL.clear LibGL::ClearBufferMask::ColorBuffer | LibGL::ClearBufferMask::DepthBuffer

  nk.frame_start
  # ==================
  # Inside the render loop
  nk.window("demo") do
    nk.row
    count = nk.property("count", count)
    nk.row height: 40
    count += 1 if nk.button("Increase")
    nk.label "Count: " + count.to_s
    nk.row height: 50, col_width: 100
    if nk.button "click"
      puts "Clicked"
    end
    #LibNK.image nk.ctx, image
  end

  nk.frame_end
  LibSdl3.gl_swap_window window
end
