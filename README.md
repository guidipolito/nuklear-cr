# nuklear

Nuklear bindings for SDL3 renderer and SDL3 OpenGL3

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     nuklear:
       github: dipolito/nuklear-cr
   ```

2. Run `shards install`

## Usage

```crystal

Sdl3.init(LibSdl3::InitFlags::Video) do
  # ====== Open sdl window
  window = Sdl3::Window.new("01-Clear", 640, 480, Sdl3::Window::Flags::None)
  renderer = window.create_renderer
  renderer.logical_presentation = {640, 480, LibSdl3::RendererLogicalPresentation::Letterbox}
  nk_ctx = LibNK.sdl_init(window.to_unsafe, renderer.to_unsafe, LibNK.sdl_allocator())
  config = LibNK.font_config(0)

  # ====== Setting default font
  atlas = LibNK.sdl_font_stash_begin(nk_ctx)
  font = LibNK.font_atlas_add_from_file(atlas, "roboto.ttf", 18, pointerof(config));
  LibNK.sdl_font_stash_end(nk_ctx)
  userfont = font.value.handle
  LibNK.style_set_font(nk_ctx, pointerof(userfont))



  # ====== variable for text input
  input_val = Bytes.new(256)
  "Hello world \0".to_slice.copy_to input_val

  running = true
  while running
    # ====== Process Inputs
    LibNK.input_begin nk_ctx
    while event = Sdl3::Events.poll
      LibNK.sdl_handle_event(nk_ctx, event.to_unsafe)
      case event
      when Sdl3::Event::Quit
        running = false
      end
    end
    LibNK.input_end nk_ctx
    renderer.clear

     # ====== Open panel
    rect = LibNK.rect 50, 50, 200, 200
    flags = LibNK::PanelFlags::Title | LibNK::PanelFlags::Movable | LibNK::PanelFlags::Closable | LibNK::PanelFlags::Scalable
    LibNK.begin(nk_ctx, "Program name", rect, flags)

     # ====== Add a new row with a button
    LibNK.layout_row_static(nk_ctx, 30, 80, 1);
    if(LibNK.button_label(nk_ctx, "button 1"))
      puts "Button 1 pressed"
    end
    # ====== Add another row dynamic with 1 item per row with a text input
    LibNK.layout_row_dynamic(nk_ctx, 40, 1);
    LibNK.edit_string_zero_terminated(nk_ctx, LibNK::EditTypes::FIELD, input_val.to_unsafe, 256, ->LibNK.filter_default)
    LibNK.label(nk_ctx, "The text below changes dynamically", LibNK::TextAlignment::TEXT_LEFT)
    LibNK.label(nk_ctx, input_val, LibNK::TextAlignment::TEXT_RIGHT)

    LibNK._end(nk_ctx)

    LibNK.sdl_render(nk_ctx, LibNK::AntiAliasing::NkAntiAliasingOn)
    LibNK.sdl_update_TextInput(nk_ctx);
    renderer.present
  end
end
```

TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/your-github-user/nuklear/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [guidipolito](https://github.com/your-github-user) - creator and maintainer
