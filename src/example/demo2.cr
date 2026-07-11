require "../nuklear"
require "../nuklear/libnuklear_sdl3_renderer"

# ====== Open sdl window
window = Sdl3::Window.new("Demo", 1280, 720, Sdl3::Window::Flags::Resizable)
renderer = window.create_renderer
nk = Nuklear.new window

running = true
show_demo = true
fps = 0
elapsed = 0
counter = 0

last_time = Time.instant
mostrar_popup = false
c = 0
while running
  elapsed += last_time.elapsed.to_f
  if elapsed >= 1
    elapsed = 0
    fps = counter
    counter = 0
  end
  counter += 1
  last_time = Time.instant

  nk.input_begin
  while event = Sdl3::Events.poll
    nk.handle_input event
    case event
    when Sdl3::Event::Quit
      running = false
    end
  end
  nk.input_end

  renderer.clear
  nk.frame_start
  ##=======================




























































  nk.window "Milena teste" do
    nk.row
    nk.tree "Demo pra milena", is_tab: true do
      nk.tree "Exemplo 1" do
        nk.row
        nk.label "Uma linha para a milena"
        if nk.button "Contador + 1"
          c += 1
        end
        nk.label "Contador = "+ c.to_s
        c = nk.property("Contador", c)
      end
      nk.tree "Exemplo 2" do
        nk.widget_tooltip "Tooltip do botão"
        nk.button "Botão com tooltip"
      end
    end
  end



















































































































































  # ===============
  nk.window("Fps", width: 100, height: 100, x: 500) do
    nk.row
    nk.label fps.to_s
  end

  nk.frame_end
  renderer.present
end
