require "./nuklear/libnuklear"

# Test
class Nuklear
  property ctx
  property current_window = ""

  # Begin collecting input for the frame, should be called before handle_input calls
  def input_begin
    LibNK.input_begin @ctx
  end

  # End the input collection, should be called before rendering the current frame
  def input_end
    LibNK.input_end @ctx
  end

  # Create a row with N cols, its dynamic if col_width not set
  def row(cols = 1, height = 0, col_width = 0)
    if col_width != 0
      return LibNK.layout_row_static @ctx, height, col_width, cols
    else
      return LibNK.layout_row_dynamic @ctx, height, cols
    end
  end


  # Creates a window receiving a block to be inside its context
  def window(name, x = 0, y = 0, width = 400, height = 300,
      title = name, movable = true, scalable = true, minimizable=true, closable = true, border = true,
      scrollbar = true, scrollbar_autohide = false, background = false, scale_left = false,
      no_input = false
  )
    rect = LibNK.rect x, y, width, height
    flags = LibNK::PanelFlags.new(0)
    flags |= LibNK::PanelFlags::Border if border
    flags |= LibNK::PanelFlags::Title if title
    flags |= LibNK::PanelFlags::Movable if movable
    flags |= LibNK::PanelFlags::Scalable if scalable
    flags |= LibNK::PanelFlags::Closable if closable
    flags |= LibNK::PanelFlags::Minimizable if minimizable
    flags |= LibNK::PanelFlags::NoScrollbar unless scrollbar
    flags |= LibNK::PanelFlags::ScrollAutoHide if scrollbar_autohide
    flags |= LibNK::PanelFlags::Background if background
    flags |= LibNK::PanelFlags::ScaleLeft if scale_left
    flags |= LibNK::PanelFlags::NoInput if no_input


    open = title ? LibNK.begin_titled(@ctx, name, title, rect, flags) : LibNK.begin(@ctx, name,  rect, flags)
    @current_window = name
    if open
      yield
    end
    @current_window = ""
    LibNK._end(@ctx)

    open
  end

  def group(name)
    flags = 0u32
    LibNK.group_begin @ctx, name, flags
    yield
    LibNK.group_end @ctx
  end

  # Returns if window of name has focus
  def window_has_focus?(name) : Bool
    LibNK.window_has_focus @ctx, name
  end

  # Returns if window of name is being hovered
  def window_hovered?(name) : Bool
    LibNK.window_is_hovered @ctx, name
  end

  # Returns if window of name is closed/was closed if called in the end of frame
  def window_closed?(name) : Bool
    LibNK.window_is_closed @ctx, name
  end

  # Returns if window is minimized, just having its title and not rendering the content
  def window_hidden?(name)
    LibNK.window_is_hidden @ctx, name
  end

  # Returns if the window is active, having focus
  def window_active?(name)
    LibNK.window_is_active @ctx, name
  end

  # Returns if any of the window is hovered
  def window_any_hovered?
    LibNK.window_is_any_hovered @ctx
  end

  # Create a label with text
  # Accepts align = :left | :center | :right
  def label(text = "", align = :left)
    alignment = LibNK::TextAlignment::TEXT_LEFT
    alignment = LibNK::TextAlignment::TEXT_RIGHT if align == :right
    alignment = LibNK::TextAlignment::TEXT_CENTERED if align == :center
    LibNK.label(@ctx, text, alignment)
  end

  @tree_states = { } of String => Pointer(LibNK::CollapseStates)
  @tree_stack = [] of String

  # Creates a collapsable tre node and accept a block for building its content
  # If 2 tree nodes has the same title in a given window, you may have to pass an id
  def tree(title, collapsed = true, is_tab = false, id = title)
    type = is_tab ? LibNK::TreeType::NkTreeTab : LibNK::TreeType::NkTreeNode
    state = collapsed ? LibNK::CollapseStates::NkMinimized :  LibNK::CollapseStates::NkMaximized
    hash = @current_window+"_$_"+@tree_stack.join("_$_")+id
    unless @tree_states.has_key? hash
      @tree_states[hash] ||= Pointer.malloc(1, state)
    end
    if LibNK.tree_state_push(@ctx, type, title, @tree_states[hash])
      @tree_stack << title
      yield
      LibNK.tree_pop @ctx
      @tree_stack.pop
    end
  end

  # Create a button and return if it was clicked
  def button(text)
    LibNK.button_label(@ctx, text)
  end

  # Create a checkbox and return if it was checked
  def check(text, val : Bool) : Bool
    LibNK.check_label @ctx, text, val
  end

  # Create a option button and return if it was checked
  def option(text, val : Bool) : Bool
    LibNK.option_label @ctx, text, val
  end

  #def radio(text, val : Bool) : Bool
  #  LibNK.radio_label @ctx, text, pointerof(val)
  #end

  def popup(name, x=0, y=0, width = 150, height = 350,
      title = false, movable = false, scalable = false, minimizable=false, closable = false, border = false,
      scrollbar = false, scrollbar_autohide = false, background = false, scale_left = false,
      no_input = false
  )
    flags = LibNK::PanelFlags.new(0)
    flags |= LibNK::PanelFlags::Border if border
    flags |= LibNK::PanelFlags::Title if title
    flags |= LibNK::PanelFlags::Movable if movable
    flags |= LibNK::PanelFlags::Scalable if scalable
    flags |= LibNK::PanelFlags::Closable if closable
    flags |= LibNK::PanelFlags::Minimizable if minimizable
    flags |= LibNK::PanelFlags::NoScrollbar unless scrollbar
    flags |= LibNK::PanelFlags::ScrollAutoHide if scrollbar_autohide
    flags |= LibNK::PanelFlags::Background if background
    flags |= LibNK::PanelFlags::ScaleLeft if scale_left
    flags |= LibNK::PanelFlags::NoInput if no_input
    rect = LibNK.rect x, y, width, height

    if LibNK.popup_begin(@ctx, LibNK::PopupType::NkPopupStatic, name, 0u32, rect)
      yield
      LibNK.popup_end @ctx
    end
  end

  def popup_close
    LibNK.popup_close @ctx
  end

  def property(name, val : Int, min = -999999, max = 999999, step = 1, inc_per_pixel = 0.5)
    LibNK.propertyi(@ctx, name, min, val, max, step, inc_per_pixel)
  end
  def property(name, val : Float, min = -999999, max = 999999, step = 1, inc_per_pixel = 0.5)
    LibNK.propertyf(@ctx, name, min, val, max, step, inc_per_pixel)
  end

  def edit(text : String, max : Int)
    max = Math.max(max, text.bytesize + 1)
    bytes = Bytes.new(max, 0)
    text.to_slice.copy_to(bytes)
    size = text.bytesize
    LibNK.edit_string(@ctx, LibNK::EditTypes::FIELD, bytes.to_unsafe, pointerof(size), max, ->LibNK.filter_default )
    return String.new(bytes.to_unsafe, size)
  end


  def edit_box(text : String, max : Int)
    max = Math.max(max, text.bytesize + 1)
    bytes = Bytes.new(max, 0)
    text.to_slice.copy_to(bytes)
    size = text.bytesize
    LibNK.edit_string(@ctx, LibNK::EditTypes::BOX, bytes.to_unsafe, pointerof(size), max, ->LibNK.filter_default )
    return String.new(bytes.to_unsafe, size)
  end

  def edit_editor(text : String, max : Int)
    max = Math.max(max, text.bytesize + 1)
    bytes = Bytes.new(max, 0)
    text.to_slice.copy_to(bytes)
    size = text.bytesize
    LibNK.edit_string(@ctx, LibNK::EditTypes::EDITOR, bytes.to_unsafe, pointerof(size), max, ->LibNK.filter_default )
    return String.new(bytes.to_unsafe, size)
  end

  def contextual(width=150, height=200, trigger_x=0, trigger_y=0, trigger_width=0, trigger_height=0)
    vec = LibNK.vec2 width, height
    rect : LibNK::Rect? = nil
    if [trigger_x, trigger_y, trigger_width, trigger_height].any?(&. != 0)
      rect = LibNK.rect trigger_x, trigger_y, trigger_width, trigger_height
    else
      rect = LibNK.widget_bounds @ctx
    end
    if LibNK.contextual_begin @ctx, 0u32, vec, rect
      yield
      LibNK.contextual_end @ctx
    end
  end

  def contextual_item(label)
    LibNK.contextual_item_label(@ctx, label, LibNK::TextAlignment::TEXT_LEFT)
  end

  def tooltip(label : String)
    LibNK.tooltip(@ctx, label)
  end

  def tooltip(width = 200)
    if LibNK.tooltip_begin(@ctx, width)
      yield
      LibNK.tooltip_end @ctx
    end
  end

  def widget_hovered?
    LibNK.widget_is_hovered @ctx
  end

  def widget_mouse_clicked?
    LibNK.widget_is_mouse_clicked @ctx
  end

  def widget_tooltip(label : String)
    if widget_hovered?
      tooltip label
    end
  end

  def widget_tooltip(width = 200, &block)
    if widget_hovered?
      tooltip(width, &block)
    end
  end

  def image(tex)
    handle = LibNK.handle_ptr tex
    img = LibNK.image_handle handle
    LibNK.image @ctx, img
  end

  def menubar
    LibNK.menubar_begin @ctx
    yield
    LibNK.menubar_end @ctx
  end

  def menu_item_label(label)
    LibNK.menu_item_label(@ctx, label, LibNK::TextAlignment::TEXT_LEFT)
  end

  def menu_label(label, width = 200, height = 200)
    vec = LibNK.vec2 width, height
    if LibNK.menu_begin_label @ctx, label, LibNK::TextAlignment::TEXT_LEFT, vec
      yield
      LibNK.menu_end @ctx
    end
  end

  def chart_lines(samples, min = 0, max = 100)
    LibNK.chart_begin(@ctx, LibNK::ChartType::NkChartLines, samples, min, max)
    yield
    LibNK.chart_end @ctx
  end

  def chart_column(samples, min = 0, max = 100)
    LibNK.chart_begin(@ctx, LibNK::ChartType::NkChartColumn, samples, min, max)
    yield
    LibNK.chart_end @ctx
  end

  def chart_max(samples, min = 0, max = 100)
    LibNK.chart_begin(@ctx, LibNK::ChartType::NkChartMax, samples, min, max)
    yield
    LibNK.chart_end @ctx
  end

  def chart_push_slot(val, index = 0) : ChartEvent
    ChartEvent.new(LibNK.chart_push_slot(@ctx, val, index))
  end

  struct ChartEvent
    getter value : LibNK::ChartEvent

    def initialize(value : UInt8 | LibNK::ChartEvent)
      @value = value
    end

    def hovering?
      @value == LibNK::ChartEvent::Hovering
    end

    def clicked?
      @value == LibNK::ChartEvent::Clicked
    end
  end
end
