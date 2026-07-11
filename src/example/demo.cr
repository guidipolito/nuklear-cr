require "../nuklear"
require "../nuklear/libnuklear_sdl3_renderer"

# ====== Open sdl window
window = Sdl3::Window.new("Demo", 1280, 720, Sdl3::Window::Flags::Resizable)
renderer = window.create_renderer
nk = Nuklear.new window
surface = Sdl3::Image.load("#{__DIR__}/tex.jpeg")
tex = Sdl3::Texture.new renderer, surface

running = true
show_demo = true
fps = 0
elapsed = 0
counter = 0

check = false
radio = 0
option = false
show_popup = false
str = "Given text"
vi = 5
vf = 5.0
size = 200

last_time = Time.instant
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
  nk.window("Flower") do
    nk.row
    size = nk.property("Size ", size)
    nk.row 2,  height: size, col_width: size
    nk.contextual do
      nk.row
      if nk.contextual_item "Redimensionar imagem"
        puts "Redimencionar imagem"
      end
    end
    nk.image tex
  end

  if show_demo
    nk.window("Demo") do
      nk.menubar do
        nk.row
        nk.menu_label "Teste" do
          nk.row
          if nk.menu_item_label "Hello"
            p "Item pressed"
          end
          nk.tree "Frutas", is_tab: true do
            nk.row
            nk.menu_item_label "Maça"
            nk.menu_item_label "Banana"
            nk.menu_item_label "Laranja"
          end
        end
      end
      nk.row
      nk.label "teste"

      nk.widget_tooltip "Open context menu when right clicked"
      nk.contextual(200, 200) do
        nk.row
        nk.contextual_item "Hi"
      end
      if nk.button "Context"
      end
      nk.row height: 100
      str = nk.edit_box str, 20000
      nk.row
      nk.label str
      nk.tree("Frutas") do
        nk.tree("Banana") do
          nk.row
          nk.label "Muito saudavel"
        end
        nk.row 3
        nk.tree("Maça", true, true) do
          nk.row 2
          nk.label "Maças são muito daora"
          nk.label "banana também"
          nk.label "banana também"
        end
        nk.label "Hiii"
        if nk.button("hello")
          puts "pressed"
        end

      end

      check = nk.check("Teste", check)
      option = nk.option("Teste3", option)

      show_popup = true if nk.button "Open popup"
      if show_popup
        nk.popup "hello pop" do
          nk.row
          vi = nk.property "Vi", vi
          vf = nk.property "Vf", vf
          nk.label "Popup"
          if nk.button "Fechar"
            show_popup = false
            nk.popup_close
          end
        end
      end

    end
  end

  nk.window("Fps", title: "Fps "+fps.to_s, width: 120, height: 200, x: 500, closable: false) do
    nk.row height: 80
    nk.chart_column 20 do
      20.times do |i|
        event = nk.chart_push_slot i, 0
        if event.hovering?
          nk.tooltip i.to_s
        end
      end
    end

    nk.chart_lines 20 do
      20.times do |i|
        event = nk.chart_push_slot i, 0
        if event.hovering?
          nk.tooltip i.to_s
        end
      end
    end
  end

  nk.frame_end
  show_demo = false if nk.window_closed? "Demo"
  renderer.present
end
