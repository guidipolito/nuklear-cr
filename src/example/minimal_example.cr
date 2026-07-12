require "../nuklear"
require "../nuklear/libnuklear_sdl3_renderer"

# ====== Open sdl window
window = Sdl3::Window.new("Demo", 1280, 720, Sdl3::Window::Flags::Resizable)
renderer = window.create_renderer
nk = Nuklear.new window


# ==================
# Outside the render loop
count = 0

# ==================
loop do
  nk.input_begin
  while event = Sdl3::Events.poll
    nk.handle_input event
    case event
    when Sdl3::Event::Quit
      break
    end
  end
  nk.input_end

  renderer.clear
  nk.frame_start
  # ==================
  # Inside the render loop
  nk.window("demo") do
    nk.row
    count += 1 if nk.button("Increase")
    nk.label "Count: " + count.to_s
  end
  # ==================
  nk.frame_end
  renderer.present
end
