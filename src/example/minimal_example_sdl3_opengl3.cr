require "opengl"
require "../nuklear"
require "../nuklear/libnuklear_sdl3_opengl3"

Sdl3.init(LibSdl3::InitFlags::Video) do
  window = Sdl3::Window.new("Demo", 1280, 720, Sdl3::Window::Flags::Resizable|Sdl3::Window::Flags::Opengl)
  # Can pass this Context to LibGL, bind buffers and and so on
  gl_ctx = LibSdl3.gl_create_context(window)
  LibSdl3.gl_make_current(window, gl_ctx)
  # example opengl usage
  # tex = 0u32
  # LibGL.gen_textures(1, pointerof(tex))
  nk = Nuklear.new window
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
      count += 1 if nk.button("Increase")
      nk.label "Count: " + count.to_s
    end

    nk.frame_end
    LibSdl3.gl_swap_window window
  end
end
