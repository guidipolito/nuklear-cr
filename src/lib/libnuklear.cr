require "../../lib/sdl3/src/sdl3"

@[Link("nuklear")]
lib LibNK
  alias Size = LibC::SizeT
  alias PluginFilter = (Pointer(TextEdit), UInt32) -> Bool
  alias PluginPaste = (Handle, Pointer(TextEdit)) -> Void
  alias PluginCopy = (Handle, LibC::Char*, LibC::Int) -> Void
  alias TextWidthF = (Handle, LibC::Float, Pointer(UInt8), LibC::Int) -> LibC::Float
  alias Flags = UInt32
  alias Glyph = StaticArray(LibC::Char, 4)

  union Handle
    ptr : Pointer(Void)
    id : LibC::Int
  end
  struct Buffer
    marker : StaticArray(BufferMarker, 2)
    pool : Allocator
    type : AllocationType
    memory : Memory
    grow_factor : LibC::Float
    allocated : Size
    needed : Size
    calls : Size
    size : Size
  end
  struct BufferMarker
    active : Size
    offset : Size
  end
  struct Allocator
    userdata : Size
    alloc : Size
    free : Size
  end
  enum AllocationType
    NkBufferFixed = 0
    NkBufferDynamic = 1
  end

  enum CommandType
    Nop
    Scissor
    Line
    Curve
    Rect
    RectFilled
    RectMultiColor
    Circle
    CircleFilled
    Arc
    ArcFilled
    Triangle
    TriangleFilled
    Polygon
    PolygonFilled
    Polyline
    Text
    Image
    Custom
  end

  enum TextAlign
    LEFT     = 0x01
    CENTERED = 0x02
    RIGHT    = 0x04
    TOP      = 0x08
    MIDDLE   = 0x10
    BOTTOM   = 0x20
  end

  enum TextAlignment
    TEXT_LEFT     = TextAlign::MIDDLE | TextAlign::LEFT
    TEXT_CENTERED = TextAlign::MIDDLE | TextAlign::CENTERED
    TEXT_RIGHT    = TextAlign::MIDDLE | TextAlign::RIGHT
  end

  struct Memory
    ptr : Pointer(Void)
    size : Size
  end
  struct CommandBuffer
    base : Pointer(Buffer)
    clip : Rect
    use_clipping : LibC::Int
    userdata : Handle
    begin : Size
    _end : Size
    last : Size
  end
  struct Rect
    x : LibC::Float
    y : LibC::Float
    w : LibC::Float
    h : LibC::Float
  end
  alias DrawCommand = Void
  struct ConvertConfig
    global_alpha : LibC::Float
    line_aa : AntiAliasing
    shape_aa : AntiAliasing
    circle_segment_count : LibC::UInt
    arc_segment_count : LibC::UInt
    curve_segment_count : LibC::UInt
    tex_null : DrawNullTexture
    vertex_layout : Pointer(DrawVertexLayoutElement)
    vertex_size : Size
    vertex_alignment : Size
  end
  enum AntiAliasing
    NkAntiAliasingOff = 0
    NkAntiAliasingOn = 1
  end
  struct DrawNullTexture
    texture : Handle
    uv : Vec2
  end
  struct Vec2
    x : LibC::Float
    y : LibC::Float
  end
  alias DrawVertexLayoutElement = Void
  struct StyleItem
    type : StyleItemType
    data : StyleItemData
  end
  enum StyleItemType
    NkStyleItemColor = 0
    NkStyleItemImage = 1
    NkStyleItemNineSlice = 2
  end
  union StyleItemData
    color : Color
    image : Image
    slice : NineSlice
  end
  struct Color
    r : UInt8
    g : UInt8
    b : UInt8
    a : UInt8
  end
  struct Image
    handle : Handle
    w : UInt16
    h : UInt16
    region : StaticArray(UInt16, 4)
  end
  struct NineSlice
    img : Image
    l, t, r, b : UInt16
  end
  struct TextEdit
    clip : Clipboard
    string : Str
    filter : PluginFilter
    scrollbar : Vec2
    cursor : LibC::Int
    select_start : LibC::Int
    select_end : LibC::Int
    mode : UInt8
    cursor_at_end_of_line : UInt8
    initialized : UInt8
    has_preferred_x : UInt8
    single_line : UInt8
    active : UInt8
    padding1 : UInt8
    preferred_x : LibC::Float
    undo : TextUndoState
  end
  struct Clipboard
    userdata : Handle
    paste : PluginPaste
    copy : PluginCopy
  end
  struct Str
    buffer : Buffer
    len : LibC::Int
  end
  struct TextUndoState
    undo_rec : StaticArray(TextUndoRecord, 99)
    undo_char : StaticArray(Void, 999)
    undo_point : LibC::Short
    redo_point : LibC::Short
    undo_char_point : LibC::Short
    redo_char_point : LibC::Short
  end
  struct TextUndoRecord
    where : LibC::Int
    insert_length : LibC::Short
    delete_length : LibC::Short
    char_storage : LibC::Short
  end
  alias DrawList = Void

   alias QueryFontGlyphF =
    (Handle, Float32, Pointer(UserFontGlyph), UInt32, UInt32) -> Void
  struct UserFont
    userdata : Handle
    height : LibC::Float
    width : TextWidthF

    query : QueryFontGlyphF
    texture : Handle
  end
  struct Panel
    type : PanelType
    flags : Flags
    bounds : Rect
    offset_x : Pointer(Void)
    offset_y : Pointer(Void)
    at_x : LibC::Float
    at_y : LibC::Float
    max_x : LibC::Float
    footer_height : LibC::Float
    header_height : LibC::Float
    border : LibC::Float
    has_scrolling : LibC::UInt
    clip : Rect
    menu : MenuState
    row : RowLayout
    chart : Chart
    buffer : Pointer(CommandBuffer)
    parent : Pointer(Panel)
  end
  enum PanelType
    NkPanelNone = 0
    NkPanelWindow = 1
    NkPanelGroup = 2
    NkPanelPopup = 4
    NkPanelContextual = 16
    NkPanelCombo = 32
    NkPanelMenu = 64
    NkPanelTooltip = 128
  end

  enum PanelFlags : UInt32
    Border           = 1 << 0
    Movable          = 1 << 1
    Scalable         = 1 << 2
    Closable         = 1 << 3
    Minimizable      = 1 << 4
    NoScrollbar      = 1 << 5
    Title            = 1 << 6
    ScrollAutoHide   = 1 << 7
    Background       = 1 << 8
    ScaleLeft        = 1 << 9
    NoInput          = 1 << 10
  end
  struct MenuState
    x : LibC::Float
    y : LibC::Float
    w : LibC::Float
    h : LibC::Float
    offset : Scroll
  end
  struct Scroll
    x : UInt32
    y : UInt32
  end
  struct RowLayout
    type : PanelRowLayoutType
    index : LibC::Int
    height : LibC::Float
    min_height : LibC::Float
    columns : LibC::Int
    ratio : Pointer(LibC::Float)
    item_width : LibC::Float
    item_height : LibC::Float
    item_offset : LibC::Float
    filled : LibC::Float
    item : Rect
    tree_depth : LibC::Int
    templates : StaticArray(LibC::Float, 16)
  end
  enum PanelRowLayoutType
    NkLayoutDynamicFixed = 0
    NkLayoutDynamicRow = 1
    NkLayoutDynamicFree = 2
    NkLayoutDynamic = 3
    NkLayoutStaticFixed = 4
    NkLayoutStaticRow = 5
    NkLayoutStaticFree = 6
    NkLayoutStatic = 7
    NkLayoutTemplate = 8
    NkLayoutCount = 9
  end
  struct Chart
    slot : LibC::Int
    x : LibC::Float
    y : LibC::Float
    w : LibC::Float
    h : LibC::Float
    slots : StaticArray(ChartSlot, 4)
  end
  struct ChartSlot
    type : ChartType
    color : Color
    highlight : Color
    min : LibC::Float
    max : LibC::Float
    range : LibC::Float
    count : LibC::Int
    last : Vec2
    index : LibC::Int
    show_markers : Bool
  end
  enum ChartType
    NkChartLines = 0
    NkChartColumn = 1
    NkChartMax = 2
  end
  struct Context
    input : Input
    style : Style
    memory : Buffer
    clip : Clipboard
    last_widget_state : Flags
    button_behavior : ButtonBehavior
    stacks : ConfigurationStacks
    delta_time_seconds : LibC::Float
    text_edit : TextEdit
    overlay : CommandBuffer
    build : LibC::Int
    use_pool : LibC::Int
    pool : Pool
    begin : Pointer(Window)
    _end : Pointer(Window)
    active : Pointer(Window)
    current : Pointer(Window)
    freelist : Pointer(PageElement)
    count : LibC::UInt
    seq : LibC::UInt
  end
  struct Input
    keyboard : Keyboard
    mouse : Mouse
  end
  struct Keyboard
    keys : StaticArray(Key, 43)
    text : StaticArray(LibC::Char, 16)
    text_len : LibC::Int
  end
  struct Key
    down : Bool
    clicked : LibC::UInt
  end
  struct Mouse
    buttons : StaticArray(MouseButton, 6)
    pos : Vec2
    prev : Vec2
    delta : Vec2
    scroll_delta : Vec2
    grab : UInt8
    grabbed : UInt8
    ungrab : UInt8
  end
  struct MouseButton
    down : Bool
    clicked : LibC::UInt
    clicked_pos : Vec2
  end
  struct Style
    font : Pointer(UserFont)
    cursors : StaticArray(Pointer(Cursor), 7)
    cursor_active : Pointer(Cursor)
    cursor_last : Pointer(Cursor)
    cursor_visible : LibC::Int
    text : StyleText
    button : StyleButton
    contextual_button : StyleButton
    menu_button : StyleButton
    option : StyleToggle
    checkbox : StyleToggle
    selectable : StyleSelectable
    slider : StyleSlider
    knob : StyleKnob
    progress : StyleProgress
    property : StyleProperty
    edit : StyleEdit
    chart : StyleChart
    scrollh : StyleScrollbar
    scrollv : StyleScrollbar
    tab : StyleTab
    combo : StyleCombo
    window : StyleWindow
  end
  struct Cursor
    img : Image
    size : Vec2
    offset : Vec2
  end
  struct StyleText
    color : Color
    padding : Vec2
    color_factor : LibC::Float
    disabled_factor : LibC::Float
  end
  struct StyleButton
    normal : StyleItem
    hover : StyleItem
    active : StyleItem
    border_color : Color
    color_factor_background : LibC::Float
    text_background : Color
    text_normal : Color
    text_hover : Color
    text_active : Color
    text_alignment : Flags
    color_factor_text : LibC::Float
    border : LibC::Float
    rounding : LibC::Float
    padding : Vec2
    image_padding : Vec2
    touch_padding : Vec2
    disabled_factor : LibC::Float
    userdata : Handle
    draw_begin : (Pointer(CommandBuffer), Void -> Void)
    draw_end : (Pointer(CommandBuffer), Void -> Void)
  end
  struct StyleToggle
    normal : StyleItem
    hover : StyleItem
    active : StyleItem
    border_color : Color
    cursor_normal : StyleItem
    cursor_hover : StyleItem
    text_normal : Color
    text_hover : Color
    text_active : Color
    text_background : Color
    text_alignment : Flags
    padding : Vec2
    touch_padding : Vec2
    spacing : LibC::Float
    border : LibC::Float
    color_factor : LibC::Float
    disabled_factor : LibC::Float
    userdata : Handle
    draw_begin : (Pointer(CommandBuffer), Void -> Void)
    draw_end : (Pointer(CommandBuffer), Void -> Void)
  end
  struct StyleSelectable
    normal : StyleItem
    hover : StyleItem
    pressed : StyleItem
    normal_active : StyleItem
    hover_active : StyleItem
    pressed_active : StyleItem
    text_normal : Color
    text_hover : Color
    text_pressed : Color
    text_normal_active : Color
    text_hover_active : Color
    text_pressed_active : Color
    text_background : Color
    text_alignment : Flags
    rounding : LibC::Float
    padding : Vec2
    touch_padding : Vec2
    image_padding : Vec2
    color_factor : LibC::Float
    disabled_factor : LibC::Float
    userdata : Handle
    draw_begin : (Pointer(CommandBuffer), Void -> Void)
    draw_end : (Pointer(CommandBuffer), Void -> Void)
  end
  struct StyleSlider
    normal : StyleItem
    hover : StyleItem
    active : StyleItem
    border_color : Color
    bar_normal : Color
    bar_hover : Color
    bar_active : Color
    bar_filled : Color
    cursor_normal : StyleItem
    cursor_hover : StyleItem
    cursor_active : StyleItem
    border : LibC::Float
    rounding : LibC::Float
    bar_height : LibC::Float
    padding : Vec2
    spacing : Vec2
    cursor_size : Vec2
    color_factor : LibC::Float
    disabled_factor : LibC::Float
    show_buttons : LibC::Int
    inc_button : StyleButton
    dec_button : StyleButton
    inc_symbol : SymbolType
    dec_symbol : SymbolType
    userdata : Handle
    draw_begin : (Pointer(CommandBuffer), Void -> Void)
    draw_end : (Pointer(CommandBuffer), Void -> Void)
  end
  enum SymbolType
    NkSymbolNone = 0
    NkSymbolX = 1
    NkSymbolUnderscore = 2
    NkSymbolCircleSolid = 3
    NkSymbolCircleOutline = 4
    NkSymbolRectSolid = 5
    NkSymbolRectOutline = 6
    NkSymbolTriangleUp = 7
    NkSymbolTriangleDown = 8
    NkSymbolTriangleLeft = 9
    NkSymbolTriangleRight = 10
    NkSymbolPlus = 11
    NkSymbolMinus = 12
    NkSymbolTriangleUpOutline = 13
    NkSymbolTriangleDownOutline = 14
    NkSymbolTriangleLeftOutline = 15
    NkSymbolTriangleRightOutline = 16
    NkSymbolChevronUp = 17
    NkSymbolChevronRight = 18
    NkSymbolChevronDown = 19
    NkSymbolChevronLeft = 20
    NkSymbolHamburger = 21
    NkSymbolMax = 22
  end
  struct StyleKnob
    normal : StyleItem
    hover : StyleItem
    active : StyleItem
    border_color : Color
    knob_normal : Color
    knob_hover : Color
    knob_active : Color
    knob_border_color : Color
    cursor_normal : Color
    cursor_hover : Color
    cursor_active : Color
    border : LibC::Float
    knob_border : LibC::Float
    padding : Vec2
    spacing : Vec2
    cursor_width : LibC::Float
    color_factor : LibC::Float
    disabled_factor : LibC::Float
    userdata : Handle
    draw_begin : (Pointer(CommandBuffer), Void -> Void)
    draw_end : (Pointer(CommandBuffer), Void -> Void)
  end
  struct StyleProgress
    normal : StyleItem
    hover : StyleItem
    active : StyleItem
    border_color : Color
    cursor_normal : StyleItem
    cursor_hover : StyleItem
    cursor_active : StyleItem
    cursor_border_color : Color
    rounding : LibC::Float
    border : LibC::Float
    cursor_border : LibC::Float
    cursor_rounding : LibC::Float
    padding : Vec2
    color_factor : LibC::Float
    disabled_factor : LibC::Float
    userdata : Handle
    draw_begin : (Pointer(CommandBuffer), Void -> Void)
    draw_end : (Pointer(CommandBuffer), Void -> Void)
  end
  struct StyleProperty
    normal : StyleItem
    hover : StyleItem
    active : StyleItem
    border_color : Color
    label_normal : Color
    label_hover : Color
    label_active : Color
    sym_left : SymbolType
    sym_right : SymbolType
    border : LibC::Float
    rounding : LibC::Float
    padding : Vec2
    color_factor : LibC::Float
    disabled_factor : LibC::Float
    edit : StyleEdit
    inc_button : StyleButton
    dec_button : StyleButton
    userdata : Handle
    draw_begin : (Pointer(CommandBuffer), Void -> Void)
    draw_end : (Pointer(CommandBuffer), Void -> Void)
  end
  struct StyleEdit
    normal : StyleItem
    hover : StyleItem
    active : StyleItem
    border_color : Color
    scrollbar : StyleScrollbar
    cursor_normal : Color
    cursor_hover : Color
    cursor_text_normal : Color
    cursor_text_hover : Color
    text_normal : Color
    text_hover : Color
    text_active : Color
    selected_normal : Color
    selected_hover : Color
    selected_text_normal : Color
    selected_text_hover : Color
    border : LibC::Float
    rounding : LibC::Float
    cursor_size : LibC::Float
    scrollbar_size : Vec2
    padding : Vec2
    row_padding : LibC::Float
    color_factor : LibC::Float
    disabled_factor : LibC::Float
  end
  struct StyleScrollbar
    normal : StyleItem
    hover : StyleItem
    active : StyleItem
    border_color : Color
    cursor_normal : StyleItem
    cursor_hover : StyleItem
    cursor_active : StyleItem
    cursor_border_color : Color
    border : LibC::Float
    rounding : LibC::Float
    border_cursor : LibC::Float
    rounding_cursor : LibC::Float
    padding : Vec2
    color_factor : LibC::Float
    disabled_factor : LibC::Float
    show_buttons : LibC::Int
    inc_button : StyleButton
    dec_button : StyleButton
    inc_symbol : SymbolType
    dec_symbol : SymbolType
    userdata : Handle
    draw_begin : (Pointer(CommandBuffer), Void -> Void)
    draw_end : (Pointer(CommandBuffer), Void -> Void)
  end
  struct StyleChart
    background : StyleItem
    border_color : Color
    selected_color : Color
    color : Color
    border : LibC::Float
    rounding : LibC::Float
    padding : Vec2
    color_factor : LibC::Float
    disabled_factor : LibC::Float
    show_markers : Bool
  end
  struct StyleTab
    background : StyleItem
    border_color : Color
    text : Color
    tab_maximize_button : StyleButton
    tab_minimize_button : StyleButton
    node_maximize_button : StyleButton
    node_minimize_button : StyleButton
    sym_minimize : SymbolType
    sym_maximize : SymbolType
    border : LibC::Float
    rounding : LibC::Float
    indent : LibC::Float
    padding : Vec2
    spacing : Vec2
    color_factor : LibC::Float
    disabled_factor : LibC::Float
  end
  struct StyleCombo
    normal : StyleItem
    hover : StyleItem
    active : StyleItem
    border_color : Color
    label_normal : Color
    label_hover : Color
    label_active : Color
    symbol_normal : Color
    symbol_hover : Color
    symbol_active : Color
    button : StyleButton
    sym_normal : SymbolType
    sym_hover : SymbolType
    sym_active : SymbolType
    border : LibC::Float
    rounding : LibC::Float
    content_padding : Vec2
    button_padding : Vec2
    spacing : Vec2
    color_factor : LibC::Float
    disabled_factor : LibC::Float
  end
  struct StyleWindow
    header : StyleWindowHeader
    fixed_background : StyleItem
    background : Color
    border_color : Color
    popup_border_color : Color
    combo_border_color : Color
    contextual_border_color : Color
    menu_border_color : Color
    group_border_color : Color
    tooltip_border_color : Color
    scaler : StyleItem
    border : LibC::Float
    combo_border : LibC::Float
    contextual_border : LibC::Float
    menu_border : LibC::Float
    group_border : LibC::Float
    tooltip_border : LibC::Float
    popup_border : LibC::Float
    min_row_height_padding : LibC::Float
    rounding : LibC::Float
    spacing : Vec2
    scrollbar_size : Vec2
    min_size : Vec2
    padding : Vec2
    group_padding : Vec2
    popup_padding : Vec2
    combo_padding : Vec2
    contextual_padding : Vec2
    menu_padding : Vec2
    tooltip_padding : Vec2
    tooltip_origin : TooltipPos
    tooltip_offset : Vec2
    tooltip_delay : LibC::Float
  end
  struct StyleWindowHeader
    normal : StyleItem
    hover : StyleItem
    active : StyleItem
    close_button : StyleButton
    minimize_button : StyleButton
    close_symbol : SymbolType
    minimize_symbol : SymbolType
    maximize_symbol : SymbolType
    label_normal : Color
    label_hover : Color
    label_active : Color
    align : StyleHeaderAlign
    padding : Vec2
    label_padding : Vec2
    spacing : Vec2
  end
  enum StyleHeaderAlign
    NkHeaderLeft = 0
    NkHeaderRight = 1
  end
  enum TooltipPos
    NkTopLeft = 0
    NkTopCenter = 1
    NkTopRight = 2
    NkMiddleLeft = 3
    NkMiddleCenter = 4
    NkMiddleRight = 5
    NkBottomLeft = 6
    NkBottomCenter = 7
    NkBottomRight = 8
  end
  enum ButtonBehavior
    NkButtonDefault = 0
    NkButtonRepeater = 1
  end
  struct ConfigurationStacks
    style_items : ConfigStackStyleItem
    floats : ConfigStackFloat
    vectors : ConfigStackVec2
    flags : ConfigStackFlags
    colors : ConfigStackColor
    fonts : ConfigStackUserFont
    button_behaviors : ConfigStackButtonBehavior
  end
  struct ConfigStackStyleItem
    head : LibC::Int
    elements : StaticArray(ConfigStackStyleItemElement, 16)
  end
  struct ConfigStackStyleItemElement
    address : Pointer(StyleItem)
    old_value : StyleItem
  end
  struct ConfigStackFloat
    head : LibC::Int
    elements : StaticArray(ConfigStackFloatElement, 32)
  end
  struct ConfigStackFloatElement
    address : Pointer(LibC::Float)
    old_value : LibC::Float
  end
  struct ConfigStackVec2
    head : LibC::Int
    elements : StaticArray(ConfigStackVec2Element, 16)
  end
  struct ConfigStackVec2Element
    address : Pointer(Vec2)
    old_value : Vec2
  end
  struct ConfigStackFlags
    head : LibC::Int
    elements : StaticArray(ConfigStackFlagsElement, 32)
  end
  struct ConfigStackFlagsElement
    address : Pointer(Void)
    old_value : Flags
  end
  struct ConfigStackColor
    head : LibC::Int
    elements : StaticArray(ConfigStackColorElement, 32)
  end
  struct ConfigStackColorElement
    address : Pointer(Color)
    old_value : Color
  end
  struct ConfigStackUserFont
    head : LibC::Int
    elements : StaticArray(ConfigStackUserFontElement, 8)
  end
  struct ConfigStackUserFontElement
    address : Pointer(Pointer(UserFont))
    old_value : Pointer(UserFont)
  end
  struct ConfigStackButtonBehavior
    head : LibC::Int
    elements : StaticArray(ConfigStackButtonBehaviorElement, 8)
  end
  struct ConfigStackButtonBehaviorElement
    address : Pointer(ButtonBehavior)
    old_value : ButtonBehavior
  end
  struct Pool
    alloc : Allocator
    type : AllocationType
    page_count : LibC::UInt
    pages : Pointer(Page)
    freelist : Pointer(PageElement)
    capacity : LibC::UInt
    size : Size
    cap : Size
  end
  struct Page
    size : LibC::UInt
    next : Pointer(Page)
    win : StaticArray(PageElement, 1)
  end
  struct PageElement
    data : PageData
    next : Pointer(PageElement)
    prev : Pointer(PageElement)
  end
  union PageData
    tbl : Table
    pan : Panel
    win : Window
  end
  struct Table
    seq : LibC::UInt
    size : LibC::UInt
    keys : StaticArray(Void, 69)
    values : StaticArray(Void, 69)
    next : Pointer(Table)
    prev : Pointer(Table)
  end
  struct Window
    seq : LibC::UInt
    name : UInt32
    name_string : StaticArray(LibC::Char, 64)
    flags : Flags
    bounds : Rect
    scrollbar : Scroll
    buffer : CommandBuffer
    layout : Pointer(Panel)
    scrollbar_hiding_timer : LibC::Float
    property : PropertyState
    popup : PopupState
    edit : EditState
    scrolled : LibC::UInt
    widgets_disabled : Bool
    tables : Pointer(Table)
    table_count : LibC::UInt
    next : Pointer(Window)
    prev : Pointer(Window)
    parent : Pointer(Window)
  end
  struct PropertyState
    active : LibC::Int
    prev : LibC::Int
    buffer : StaticArray(LibC::Char, 64)
    length : LibC::Int
    cursor : LibC::Int
    select_start : LibC::Int
    select_end : LibC::Int
    name : UInt32
    seq : LibC::UInt
    old : LibC::UInt
    state : LibC::Int
    prev_state : LibC::Int
    prev_name : UInt32
    prev_buffer : StaticArray(LibC::Char, 64)
    prev_length : LibC::Int
  end
  struct PopupState
    win : Pointer(Window)
    type : PanelType
    buf : PopupBuffer
    name : UInt32
    active : Bool
    combo_count : LibC::UInt
    con_count : LibC::UInt
    con_old : LibC::UInt
    active_con : LibC::UInt
    header : Rect
  end
  struct PopupBuffer
    begin, parent, last, _end : Size
    active : Bool
  end
  struct EditState
    name : UInt32
    seq : LibC::UInt
    old : LibC::UInt
    active : LibC::Int
    prev : LibC::Int
    cursor : LibC::Int
    sel_start : LibC::Int
    sel_end : LibC::Int
    scrollbar : Scroll
    mode : UInt8
    single_line : UInt8
  end
  alias StyleSlide = Void
  struct Colorf
    r : LibC::Float
    g : LibC::Float
    b : LibC::Float
    a : LibC::Float
  end
  struct Vec2i
    x : LibC::Short
    y : LibC::Short
  end
  struct Recti
    x : LibC::Short
    y : LibC::Short
    w : LibC::Short
    h : LibC::Short
  end
  fun init_fixed = nk_init_fixed(x0 : Pointer(Context), memory : Pointer(Void), size : Size, x3 : Pointer(UserFont))
  fun init = nk_init(x0 : Pointer(Context), x1 : Pointer(Allocator), x2 : Pointer(UserFont))
  fun init_custom = nk_init_custom(x0 : Pointer(Context), cmds : Pointer(Buffer), pool : Pointer(Buffer), x3 : Pointer(UserFont))
  fun clear = nk_clear(x0 : Pointer(Context))
  fun free = nk_free(x0 : Pointer(Context))
  fun input_begin = nk_input_begin(x0 : Pointer(Context))
  fun input_motion = nk_input_motion(x0 : Pointer(Context), x : LibC::Int, y : LibC::Int)
  fun input_key = nk_input_key(x0 : Pointer(Context), x1 : Keys, down : Bool)
  enum Keys
    NkKeyNone = 0
    NkKeyShift = 1
    NkKeyCtrl = 2
    NkKeyDel = 3
    NkKeyEnter = 4
    NkKeyTab = 5
    NkKeyBackspace = 6
    NkKeyCopy = 7
    NkKeyCut = 8
    NkKeyPaste = 9
    NkKeyUp = 10
    NkKeyDown = 11
    NkKeyLeft = 12
    NkKeyRight = 13
    NkKeyTextInsertMode = 14
    NkKeyTextReplaceMode = 15
    NkKeyTextResetMode = 16
    NkKeyTextLineStart = 17
    NkKeyTextLineEnd = 18
    NkKeyTextStart = 19
    NkKeyTextEnd = 20
    NkKeyTextUndo = 21
    NkKeyTextRedo = 22
    NkKeyTextSelectAll = 23
    NkKeyTextWordLeft = 24
    NkKeyTextWordRight = 25
    NkKeyScrollStart = 26
    NkKeyScrollEnd = 27
    NkKeyScrollDown = 28
    NkKeyScrollUp = 29
    NkKeyAlt = 30
    NkKeyF1 = 31
    NkKeyF2 = 32
    NkKeyF3 = 33
    NkKeyF4 = 34
    NkKeyF5 = 35
    NkKeyF6 = 36
    NkKeyF7 = 37
    NkKeyF8 = 38
    NkKeyF9 = 39
    NkKeyF10 = 40
    NkKeyF11 = 41
    NkKeyF12 = 42
    NkKeyMax = 43
  end
  fun input_button = nk_input_button(x0 : Pointer(Context), x1 : Buttons, x : LibC::Int, y : LibC::Int, down : Bool)
  enum Buttons
    NkButtonLeft = 0
    NkButtonMiddle = 1
    NkButtonRight = 2
    NkButtonDouble = 3
    NkButtonX1 = 4
    NkButtonX2 = 5
    NkButtonMax = 6
  end
  fun input_scroll = nk_input_scroll(x0 : Pointer(Context), val : Vec2)
  fun input_char = nk_input_char(x0 : Pointer(Context), x1 : LibC::Char)
  fun input_glyph = nk_input_glyph(x0 : Pointer(Context), x1 : Glyph)
  fun input_unicode = nk_input_unicode(x0 : Pointer(Context), x1 : UInt32)
  fun input_end = nk_input_end(x0 : Pointer(Context))
  struct Command
    type : CommandType
    next : Size
  end
  fun _begin = nk__begin(x0 : Pointer(Context)) : Pointer(Command)
  fun _next = nk__next(x0 : Pointer(Context), x1 : Pointer(Command)) : Pointer(Command)
  fun begin = nk_begin(ctx : Pointer(Context), title : Pointer(LibC::Char), bounds : Rect, flags : Flags)
  fun begin_titled = nk_begin_titled(ctx : Pointer(Context), name : Pointer(LibC::Char), title : Pointer(LibC::Char), bounds : Rect, flags : Flags)
  fun _end = nk_end(ctx : Pointer(Context))
  fun window_find = nk_window_find(ctx : Pointer(Context), name : Pointer(LibC::Char)) : Pointer(Window)
  fun window_get_bounds = nk_window_get_bounds(ctx : Pointer(Context)) : Rect
  fun window_get_position = nk_window_get_position(ctx : Pointer(Context)) : Vec2
  fun window_get_size = nk_window_get_size(ctx : Pointer(Context)) : Vec2
  fun window_get_width = nk_window_get_width(ctx : Pointer(Context)) : LibC::Float
  fun window_get_height = nk_window_get_height(ctx : Pointer(Context)) : LibC::Float
  fun window_get_panel = nk_window_get_panel(ctx : Pointer(Context)) : Pointer(Panel)
  fun window_get_content_region = nk_window_get_content_region(ctx : Pointer(Context)) : Rect
  fun window_get_content_region_min = nk_window_get_content_region_min(ctx : Pointer(Context)) : Vec2
  fun window_get_content_region_max = nk_window_get_content_region_max(ctx : Pointer(Context)) : Vec2
  fun window_get_content_region_size = nk_window_get_content_region_size(ctx : Pointer(Context)) : Vec2
  fun window_get_canvas = nk_window_get_canvas(ctx : Pointer(Context)) : Pointer(CommandBuffer)
  fun window_get_scroll = nk_window_get_scroll(ctx : Pointer(Context), offset_x : Pointer(Void), offset_y : Pointer(Void))
  fun window_has_focus = nk_window_has_focus(ctx : Pointer(Context))
  fun window_is_hovered = nk_window_is_hovered(ctx : Pointer(Context))
  fun window_is_collapsed = nk_window_is_collapsed(ctx : Pointer(Context), name : Pointer(LibC::Char))
  fun window_is_closed = nk_window_is_closed(ctx : Pointer(Context), name : Pointer(LibC::Char))
  fun window_is_hidden = nk_window_is_hidden(ctx : Pointer(Context), name : Pointer(LibC::Char))
  fun window_is_active = nk_window_is_active(ctx : Pointer(Context), name : Pointer(LibC::Char))
  fun window_is_any_hovered = nk_window_is_any_hovered(ctx : Pointer(Context))
  fun item_is_any_active = nk_item_is_any_active(ctx : Pointer(Context))
  fun window_set_bounds = nk_window_set_bounds(ctx : Pointer(Context), name : Pointer(LibC::Char), bounds : Rect)
  fun window_set_position = nk_window_set_position(ctx : Pointer(Context), name : Pointer(LibC::Char), pos : Vec2)
  fun window_set_size = nk_window_set_size(ctx : Pointer(Context), name : Pointer(LibC::Char), size : Vec2)
  fun window_set_focus = nk_window_set_focus(ctx : Pointer(Context), name : Pointer(LibC::Char))
  fun window_set_scroll = nk_window_set_scroll(ctx : Pointer(Context), offset_x : UInt32, offset_y : UInt32)
  fun window_close = nk_window_close(ctx : Pointer(Context), name : Pointer(LibC::Char))
  fun window_collapse = nk_window_collapse(ctx : Pointer(Context), name : Pointer(LibC::Char), state : CollapseStates)
  enum CollapseStates
    NkMinimized = 0
    NkMaximized = 1
  end
  fun window_collapse_if = nk_window_collapse_if(ctx : Pointer(Context), name : Pointer(LibC::Char), state : CollapseStates, cond : LibC::Int)
  fun window_show = nk_window_show(ctx : Pointer(Context), name : Pointer(LibC::Char), state : ShowStates)
  enum ShowStates
    NkHidden = 0
    NkShown = 1
  end
  fun window_show_if = nk_window_show_if(ctx : Pointer(Context), name : Pointer(LibC::Char), state : ShowStates, cond : LibC::Int)
  fun rule_horizontal = nk_rule_horizontal(ctx : Pointer(Context), color : Color, rounding : Bool)
  fun layout_set_min_row_height = nk_layout_set_min_row_height(x0 : Pointer(Context), height : LibC::Float)
  fun layout_reset_min_row_height = nk_layout_reset_min_row_height(x0 : Pointer(Context))
  fun layout_widget_bounds = nk_layout_widget_bounds(ctx : Pointer(Context)) : Rect
  fun layout_ratio_from_pixel = nk_layout_ratio_from_pixel(ctx : Pointer(Context), pixel_width : LibC::Float) : LibC::Float
  fun layout_row_dynamic = nk_layout_row_dynamic(ctx : Pointer(Context), height : LibC::Float, cols : LibC::Int)
  fun layout_row_static = nk_layout_row_static(ctx : Pointer(Context), height : LibC::Float, item_width : LibC::Int, cols : LibC::Int)
  fun layout_row_begin = nk_layout_row_begin(ctx : Pointer(Context), fmt : LayoutFormat, row_height : LibC::Float, cols : LibC::Int)
  enum LayoutFormat
    NkDynamic = 0
    NkStatic = 1
  end
  fun layout_row_push = nk_layout_row_push(x0 : Pointer(Context), value : LibC::Float)
  fun layout_row_end = nk_layout_row_end(x0 : Pointer(Context))
  fun layout_row = nk_layout_row(x0 : Pointer(Context), x1 : LayoutFormat, height : LibC::Float, cols : LibC::Int, ratio : Pointer(LibC::Float))
  fun layout_row_template_begin = nk_layout_row_template_begin(x0 : Pointer(Context), row_height : LibC::Float)
  fun layout_row_template_push_dynamic = nk_layout_row_template_push_dynamic(x0 : Pointer(Context))
  fun layout_row_template_push_variable = nk_layout_row_template_push_variable(x0 : Pointer(Context), min_width : LibC::Float)
  fun layout_row_template_push_static = nk_layout_row_template_push_static(x0 : Pointer(Context), width : LibC::Float)
  fun layout_row_template_end = nk_layout_row_template_end(x0 : Pointer(Context))
  fun layout_space_begin = nk_layout_space_begin(x0 : Pointer(Context), x1 : LayoutFormat, height : LibC::Float, widget_count : LibC::Int)
  fun layout_space_push = nk_layout_space_push(x0 : Pointer(Context), bounds : Rect)
  fun layout_space_end = nk_layout_space_end(x0 : Pointer(Context))
  fun layout_space_bounds = nk_layout_space_bounds(ctx : Pointer(Context)) : Rect
  fun layout_space_to_screen = nk_layout_space_to_screen(ctx : Pointer(Context), vec : Vec2) : Vec2
  fun layout_space_to_local = nk_layout_space_to_local(ctx : Pointer(Context), vec : Vec2) : Vec2
  fun layout_space_rect_to_screen = nk_layout_space_rect_to_screen(ctx : Pointer(Context), bounds : Rect) : Rect
  fun layout_space_rect_to_local = nk_layout_space_rect_to_local(ctx : Pointer(Context), bounds : Rect) : Rect
  fun spacer = nk_spacer(ctx : Pointer(Context))
  fun group_begin = nk_group_begin(x0 : Pointer(Context), title : Pointer(LibC::Char), x2 : Flags)
  fun group_begin_titled = nk_group_begin_titled(x0 : Pointer(Context), name : Pointer(LibC::Char), title : Pointer(LibC::Char), x3 : Flags)
  fun group_end = nk_group_end(x0 : Pointer(Context))
  fun group_scrolled_offset_begin = nk_group_scrolled_offset_begin(x0 : Pointer(Context), x_offset : Pointer(Void), y_offset : Pointer(Void), title : Pointer(LibC::Char), flags : Flags)
  fun group_scrolled_begin = nk_group_scrolled_begin(x0 : Pointer(Context), off : Pointer(Scroll), title : Pointer(LibC::Char), x3 : Flags)
  fun group_scrolled_end = nk_group_scrolled_end(x0 : Pointer(Context))
  fun group_get_scroll = nk_group_get_scroll(x0 : Pointer(Context), id : Pointer(LibC::Char), x_offset : Pointer(Void), y_offset : Pointer(Void))
  fun group_set_scroll = nk_group_set_scroll(x0 : Pointer(Context), id : Pointer(LibC::Char), x_offset : UInt32, y_offset : UInt32)
  fun tree_push_hashed = nk_tree_push_hashed(x0 : Pointer(Context), x1 : TreeType, title : Pointer(LibC::Char), initial_state : CollapseStates, hash : Pointer(LibC::Char), len : LibC::Int, seed : LibC::Int)
  enum TreeType
    NkTreeNode = 0
    NkTreeTab = 1
  end
  fun tree_image_push_hashed = nk_tree_image_push_hashed(x0 : Pointer(Context), x1 : TreeType, x2 : Image, title : Pointer(LibC::Char), initial_state : CollapseStates, hash : Pointer(LibC::Char), len : LibC::Int, seed : LibC::Int)
  fun tree_pop = nk_tree_pop(x0 : Pointer(Context))
  fun tree_state_push = nk_tree_state_push(x0 : Pointer(Context), x1 : TreeType, title : Pointer(LibC::Char), state : Pointer(CollapseStates))
  fun tree_state_image_push = nk_tree_state_image_push(x0 : Pointer(Context), x1 : TreeType, x2 : Image, title : Pointer(LibC::Char), state : Pointer(CollapseStates))
  fun tree_state_pop = nk_tree_state_pop(x0 : Pointer(Context))
  fun tree_element_push_hashed = nk_tree_element_push_hashed(x0 : Pointer(Context), x1 : TreeType, title : Pointer(LibC::Char), initial_state : CollapseStates, selected : Pointer(Void), hash : Pointer(LibC::Char), len : LibC::Int, seed : LibC::Int)
  fun tree_element_image_push_hashed = nk_tree_element_image_push_hashed(x0 : Pointer(Context), x1 : TreeType, x2 : Image, title : Pointer(LibC::Char), initial_state : CollapseStates, selected : Pointer(Void), hash : Pointer(LibC::Char), len : LibC::Int, seed : LibC::Int)
  fun tree_element_pop = nk_tree_element_pop(x0 : Pointer(Context))
  struct ListView
    begin : LibC::Int
    _end : LibC::Int
    count : LibC::Int
    total_height : LibC::Int
    ctx : Pointer(Context)
    scroll_pointer : Pointer(Void)
    scroll_value : UInt32
  end
  fun list_view_begin = nk_list_view_begin(x0 : Pointer(Context), out : Pointer(ListView), id : Pointer(LibC::Char), x3 : Flags, row_height : LibC::Int, row_count : LibC::Int)
  fun list_view_end = nk_list_view_end(x0 : Pointer(ListView))
  fun widget = nk_widget(x0 : Pointer(Rect), x1 : Pointer(Context)) : WidgetLayoutStates
  enum WidgetLayoutStates
    NkWidgetInvalid = 0
    NkWidgetValid = 1
    NkWidgetRom = 2
    NkWidgetDisabled = 3
  end
  fun widget_bounds = nk_widget_bounds(x0 : Pointer(Context)) : Rect
  fun widget_position = nk_widget_position(x0 : Pointer(Context)) : Vec2
  fun widget_size = nk_widget_size(x0 : Pointer(Context)) : Vec2
  fun widget_width = nk_widget_width(x0 : Pointer(Context)) : LibC::Float
  fun widget_height = nk_widget_height(x0 : Pointer(Context)) : LibC::Float
  fun widget_is_hovered = nk_widget_is_hovered(x0 : Pointer(Context))
  fun widget_is_mouse_clicked = nk_widget_is_mouse_clicked(x0 : Pointer(Context), x1 : Buttons)
  fun widget_has_mouse_click_down = nk_widget_has_mouse_click_down(x0 : Pointer(Context), x1 : Buttons, down : Bool)
  fun spacing = nk_spacing(x0 : Pointer(Context), cols : LibC::Int)
  fun widget_disable_begin = nk_widget_disable_begin(ctx : Pointer(Context))
  fun widget_disable_end = nk_widget_disable_end(ctx : Pointer(Context))
  fun text = nk_text(x0 : Pointer(Context), x1 : Pointer(LibC::Char), x2 : LibC::Int, x3 : Flags)
  fun text_colored = nk_text_colored(x0 : Pointer(Context), x1 : Pointer(LibC::Char), x2 : LibC::Int, x3 : Flags, x4 : Color)
  fun text_wrap = nk_text_wrap(x0 : Pointer(Context), x1 : Pointer(LibC::Char), x2 : LibC::Int)
  fun text_wrap_colored = nk_text_wrap_colored(x0 : Pointer(Context), x1 : Pointer(LibC::Char), x2 : LibC::Int, x3 : Color)
  fun label = nk_label(x0 : Pointer(Context), x1 : Pointer(LibC::Char), align : Flags)
  fun label_colored = nk_label_colored(x0 : Pointer(Context), x1 : Pointer(LibC::Char), align : Flags, x3 : Color)
  fun label_wrap = nk_label_wrap(x0 : Pointer(Context), x1 : Pointer(LibC::Char))
  fun label_colored_wrap = nk_label_colored_wrap(x0 : Pointer(Context), x1 : Pointer(LibC::Char), x2 : Color)
  fun image = nk_image(x0 : Pointer(Context), x1 : Image)
  fun image_color = nk_image_color(x0 : Pointer(Context), x1 : Image, x2 : Color)
  fun button_text = nk_button_text(x0 : Pointer(Context), title : Pointer(LibC::Char), len : LibC::Int)
  fun button_label = nk_button_label(x0 : Pointer(Context), title : Pointer(LibC::Char)) : Bool
  fun button_color = nk_button_color(x0 : Pointer(Context), x1 : Color)
  fun button_symbol = nk_button_symbol(x0 : Pointer(Context), x1 : SymbolType)
  fun button_image = nk_button_image(x0 : Pointer(Context), img : Image)
  fun button_symbol_label = nk_button_symbol_label(x0 : Pointer(Context), x1 : SymbolType, x2 : Pointer(LibC::Char), text_alignment : Flags)
  fun button_symbol_text = nk_button_symbol_text(x0 : Pointer(Context), x1 : SymbolType, x2 : Pointer(LibC::Char), x3 : LibC::Int, alignment : Flags)
  fun button_image_label = nk_button_image_label(x0 : Pointer(Context), img : Image, x2 : Pointer(LibC::Char), text_alignment : Flags)
  fun button_image_text = nk_button_image_text(x0 : Pointer(Context), img : Image, x2 : Pointer(LibC::Char), x3 : LibC::Int, alignment : Flags)
  fun button_text_styled = nk_button_text_styled(x0 : Pointer(Context), x1 : Pointer(StyleButton), title : Pointer(LibC::Char), len : LibC::Int)
  fun button_label_styled = nk_button_label_styled(x0 : Pointer(Context), x1 : Pointer(StyleButton), title : Pointer(LibC::Char))
  fun button_symbol_styled = nk_button_symbol_styled(x0 : Pointer(Context), x1 : Pointer(StyleButton), x2 : SymbolType)
  fun button_image_styled = nk_button_image_styled(x0 : Pointer(Context), x1 : Pointer(StyleButton), img : Image)
  fun button_symbol_text_styled = nk_button_symbol_text_styled(x0 : Pointer(Context), x1 : Pointer(StyleButton), x2 : SymbolType, x3 : Pointer(LibC::Char), x4 : LibC::Int, alignment : Flags)
  fun button_symbol_label_styled = nk_button_symbol_label_styled(ctx : Pointer(Context), style : Pointer(StyleButton), symbol : SymbolType, title : Pointer(LibC::Char), align : Flags)
  fun button_image_label_styled = nk_button_image_label_styled(x0 : Pointer(Context), x1 : Pointer(StyleButton), img : Image, x3 : Pointer(LibC::Char), text_alignment : Flags)
  fun button_image_text_styled = nk_button_image_text_styled(x0 : Pointer(Context), x1 : Pointer(StyleButton), img : Image, x3 : Pointer(LibC::Char), x4 : LibC::Int, alignment : Flags)
  fun button_set_behavior = nk_button_set_behavior(x0 : Pointer(Context), x1 : ButtonBehavior)
  fun button_push_behavior = nk_button_push_behavior(x0 : Pointer(Context), x1 : ButtonBehavior)
  fun button_pop_behavior = nk_button_pop_behavior(x0 : Pointer(Context))
  fun check_label = nk_check_label(x0 : Pointer(Context), x1 : Pointer(LibC::Char), active : Bool)
  fun check_text = nk_check_text(x0 : Pointer(Context), x1 : Pointer(LibC::Char), x2 : LibC::Int, active : Bool)
  fun check_text_align = nk_check_text_align(x0 : Pointer(Context), x1 : Pointer(LibC::Char), x2 : LibC::Int, active : Bool, widget_alignment : Flags, text_alignment : Flags)
  fun check_flags_label = nk_check_flags_label(x0 : Pointer(Context), x1 : Pointer(LibC::Char), flags : LibC::UInt, value : LibC::UInt) : LibC::UInt
  fun check_flags_text = nk_check_flags_text(x0 : Pointer(Context), x1 : Pointer(LibC::Char), x2 : LibC::Int, flags : LibC::UInt, value : LibC::UInt) : LibC::UInt
  fun checkbox_label = nk_checkbox_label(x0 : Pointer(Context), x1 : Pointer(LibC::Char), active : Pointer(Void))
  fun checkbox_label_align = nk_checkbox_label_align(ctx : Pointer(Context), label : Pointer(LibC::Char), active : Pointer(Void), widget_alignment : Flags, text_alignment : Flags)
  fun checkbox_text = nk_checkbox_text(x0 : Pointer(Context), x1 : Pointer(LibC::Char), x2 : LibC::Int, active : Pointer(Void))
  fun checkbox_text_align = nk_checkbox_text_align(ctx : Pointer(Context), text : Pointer(LibC::Char), len : LibC::Int, active : Pointer(Void), widget_alignment : Flags, text_alignment : Flags)
  fun checkbox_flags_label = nk_checkbox_flags_label(x0 : Pointer(Context), x1 : Pointer(LibC::Char), flags : Pointer(LibC::UInt), value : LibC::UInt)
  fun checkbox_flags_text = nk_checkbox_flags_text(x0 : Pointer(Context), x1 : Pointer(LibC::Char), x2 : LibC::Int, flags : Pointer(LibC::UInt), value : LibC::UInt)
  fun radio_label = nk_radio_label(x0 : Pointer(Context), x1 : Pointer(LibC::Char), active : Pointer(Void))
  fun radio_label_align = nk_radio_label_align(ctx : Pointer(Context), label : Pointer(LibC::Char), active : Pointer(Void), widget_alignment : Flags, text_alignment : Flags)
  fun radio_text = nk_radio_text(x0 : Pointer(Context), x1 : Pointer(LibC::Char), x2 : LibC::Int, active : Pointer(Void))
  fun radio_text_align = nk_radio_text_align(ctx : Pointer(Context), text : Pointer(LibC::Char), len : LibC::Int, active : Pointer(Void), widget_alignment : Flags, text_alignment : Flags)
  fun option_label = nk_option_label(x0 : Pointer(Context), x1 : Pointer(LibC::Char), active : Bool)
  fun option_label_align = nk_option_label_align(ctx : Pointer(Context), label : Pointer(LibC::Char), active : Bool, widget_alignment : Flags, text_alignment : Flags)
  fun option_text = nk_option_text(x0 : Pointer(Context), x1 : Pointer(LibC::Char), x2 : LibC::Int, active : Bool)
  fun option_text_align = nk_option_text_align(ctx : Pointer(Context), text : Pointer(LibC::Char), len : LibC::Int, is_active : Bool, widget_alignment : Flags, text_alignment : Flags)
  fun selectable_label = nk_selectable_label(x0 : Pointer(Context), x1 : Pointer(LibC::Char), align : Flags, value : Pointer(Void))
  fun selectable_text = nk_selectable_text(x0 : Pointer(Context), x1 : Pointer(LibC::Char), x2 : LibC::Int, align : Flags, value : Pointer(Void))
  fun selectable_image_label = nk_selectable_image_label(x0 : Pointer(Context), x1 : Image, x2 : Pointer(LibC::Char), align : Flags, value : Pointer(Void))
  fun selectable_image_text = nk_selectable_image_text(x0 : Pointer(Context), x1 : Image, x2 : Pointer(LibC::Char), x3 : LibC::Int, align : Flags, value : Pointer(Void))
  fun selectable_symbol_label = nk_selectable_symbol_label(x0 : Pointer(Context), x1 : SymbolType, x2 : Pointer(LibC::Char), align : Flags, value : Pointer(Void))
  fun selectable_symbol_text = nk_selectable_symbol_text(x0 : Pointer(Context), x1 : SymbolType, x2 : Pointer(LibC::Char), x3 : LibC::Int, align : Flags, value : Pointer(Void))
  fun select_label = nk_select_label(x0 : Pointer(Context), x1 : Pointer(LibC::Char), align : Flags, value : Bool)
  fun select_text = nk_select_text(x0 : Pointer(Context), x1 : Pointer(LibC::Char), x2 : LibC::Int, align : Flags, value : Bool)
  fun select_image_label = nk_select_image_label(x0 : Pointer(Context), x1 : Image, x2 : Pointer(LibC::Char), align : Flags, value : Bool)
  fun select_image_text = nk_select_image_text(x0 : Pointer(Context), x1 : Image, x2 : Pointer(LibC::Char), x3 : LibC::Int, align : Flags, value : Bool)
  fun select_symbol_label = nk_select_symbol_label(x0 : Pointer(Context), x1 : SymbolType, x2 : Pointer(LibC::Char), align : Flags, value : Bool)
  fun select_symbol_text = nk_select_symbol_text(x0 : Pointer(Context), x1 : SymbolType, x2 : Pointer(LibC::Char), x3 : LibC::Int, align : Flags, value : Bool)
  fun slide_float = nk_slide_float(x0 : Pointer(Context), min : LibC::Float, val : LibC::Float, max : LibC::Float, step : LibC::Float) : LibC::Float
  fun slide_int = nk_slide_int(x0 : Pointer(Context), min : LibC::Int, val : LibC::Int, max : LibC::Int, step : LibC::Int) : LibC::Int
  fun slider_float = nk_slider_float(x0 : Pointer(Context), min : LibC::Float, val : Pointer(LibC::Float), max : LibC::Float, step : LibC::Float)
  fun slider_int = nk_slider_int(x0 : Pointer(Context), min : LibC::Int, val : Pointer(LibC::Int), max : LibC::Int, step : LibC::Int)
  fun knob_float = nk_knob_float(x0 : Pointer(Context), min : LibC::Float, val : Pointer(LibC::Float), max : LibC::Float, step : LibC::Float, zero_direction : Heading, dead_zone_degrees : LibC::Float)
  enum Heading
    NkUp = 0
    NkRight = 1
    NkDown = 2
    NkLeft = 3
  end
  fun knob_int = nk_knob_int(x0 : Pointer(Context), min : LibC::Int, val : Pointer(LibC::Int), max : LibC::Int, step : LibC::Int, zero_direction : Heading, dead_zone_degrees : LibC::Float)
  fun progress = nk_progress(x0 : Pointer(Context), cur : Pointer(Void), max : Size, modifyable : Bool)
  fun prog = nk_prog(x0 : Pointer(Context), cur : Size, max : Size, modifyable : Bool)
  fun color_picker = nk_color_picker(x0 : Pointer(Context), x1 : Colorf, x2 : ColorFormat) : Colorf
  enum ColorFormat
    NkRgb = 0
    NkRgba = 1
  end
  fun color_pick = nk_color_pick(x0 : Pointer(Context), x1 : Pointer(Colorf), x2 : ColorFormat)
  fun property_int = nk_property_int(x0 : Pointer(Context), name : Pointer(LibC::Char), min : LibC::Int, val : Pointer(LibC::Int), max : LibC::Int, step : LibC::Int, inc_per_pixel : LibC::Float)
  fun property_float = nk_property_float(x0 : Pointer(Context), name : Pointer(LibC::Char), min : LibC::Float, val : Pointer(LibC::Float), max : LibC::Float, step : LibC::Float, inc_per_pixel : LibC::Float)
  fun property_double = nk_property_double(x0 : Pointer(Context), name : Pointer(LibC::Char), min : LibC::Double, val : Pointer(LibC::Double), max : LibC::Double, step : LibC::Double, inc_per_pixel : LibC::Float)
  fun propertyi = nk_propertyi(x0 : Pointer(Context), name : Pointer(LibC::Char), min : LibC::Int, val : LibC::Int, max : LibC::Int, step : LibC::Int, inc_per_pixel : LibC::Float) : LibC::Int
  fun propertyf = nk_propertyf(x0 : Pointer(Context), name : Pointer(LibC::Char), min : LibC::Float, val : LibC::Float, max : LibC::Float, step : LibC::Float, inc_per_pixel : LibC::Float) : LibC::Float
  fun propertyd = nk_propertyd(x0 : Pointer(Context), name : Pointer(LibC::Char), min : LibC::Double, val : LibC::Double, max : LibC::Double, step : LibC::Double, inc_per_pixel : LibC::Float) : LibC::Double
  enum EditFlags : UInt32
    DEFAULT                 = 0
    READ_ONLY               = 1 << 0
    AUTO_SELECT             = 1 << 1
    SIG_ENTER               = 1 << 2
    ALLOW_TAB               = 1 << 3
    NO_CURSOR               = 1 << 4
    SELECTABLE              = 1 << 5
    CLIPBOARD               = 1 << 6
    CTRL_ENTER_NEWLINE      = 1 << 7
    NO_HORIZONTAL_SCROLL    = 1 << 8
    ALWAYS_INSERT_MODE      = 1 << 9
    MULTILINE               = 1 << 10
    GOTO_END_ON_ACTIVATE    = 1 << 11

  end

  enum EditTypes : UInt32
    SIMPLE = EditFlags::ALWAYS_INSERT_MODE
    FIELD  = SIMPLE | EditFlags::SELECTABLE | EditFlags::CLIPBOARD
    BOX    = EditFlags::ALWAYS_INSERT_MODE | EditFlags::SELECTABLE | EditFlags::MULTILINE | EditFlags::ALLOW_TAB | EditFlags::CLIPBOARD
    EDITOR = EditFlags::SELECTABLE | EditFlags::MULTILINE | EditFlags::ALLOW_TAB | EditFlags::CLIPBOARD
  end

  enum EditEvents : UInt32
    ACTIVE      = 1 << 0
    INACTIVE    = 1 << 1
    ACTIVATED   = 1 << 2
    DEACTIVATED = 1 << 3
    COMMITTED   = 1 << 4
  end

  fun edit_string = nk_edit_string(x0 : Pointer(Context), x1 : Flags, buffer : Pointer(LibC::Char), len : Pointer(LibC::Int), max : LibC::Int, x5 : PluginFilter)
  fun edit_string_zero_terminated = nk_edit_string_zero_terminated(x0 : Pointer(Context), x1 : Flags, buffer : Pointer(LibC::Char), max : LibC::Int, x4 : PluginFilter)
  fun edit_buffer = nk_edit_buffer(x0 : Pointer(Context), x1 : Flags, x2 : Pointer(TextEdit), x3 : PluginFilter)
  fun edit_focus = nk_edit_focus(x0 : Pointer(Context), flags : Flags)
  fun edit_unfocus = nk_edit_unfocus(x0 : Pointer(Context))
  fun chart_begin = nk_chart_begin(x0 : Pointer(Context), x1 : ChartType, num : LibC::Int, min : LibC::Float, max : LibC::Float)
  fun chart_begin_colored = nk_chart_begin_colored(x0 : Pointer(Context), x1 : ChartType, x2 : Color, active : Color, num : LibC::Int, min : LibC::Float, max : LibC::Float)
  fun chart_add_slot = nk_chart_add_slot(ctx : Pointer(Context), x1 : ChartType, count : LibC::Int, min_value : LibC::Float, max_value : LibC::Float)
  fun chart_add_slot_colored = nk_chart_add_slot_colored(ctx : Pointer(Context), x1 : ChartType, x2 : Color, active : Color, count : LibC::Int, min_value : LibC::Float, max_value : LibC::Float)
  fun chart_push = nk_chart_push(x0 : Pointer(Context), x1 : LibC::Float)
  fun chart_push_slot = nk_chart_push_slot(x0 : Pointer(Context), x1 : LibC::Float, x2 : LibC::Int)
  fun chart_end = nk_chart_end(x0 : Pointer(Context))
  fun plot = nk_plot(x0 : Pointer(Context), x1 : ChartType, values : Pointer(LibC::Float), count : LibC::Int, offset : LibC::Int)
  fun plot_function = nk_plot_function(x0 : Pointer(Context), x1 : ChartType, userdata : Pointer(Void), value_getter : Pointer(Void), LibC::Int -> LibC::Float, count : LibC::Int, offset : LibC::Int)
  fun popup_begin = nk_popup_begin(x0 : Pointer(Context), x1 : PopupType, x2 : Pointer(LibC::Char), x3 : Flags, bounds : Rect)
  enum PopupType
    NkPopupStatic = 0
    NkPopupDynamic = 1
  end
  fun popup_close = nk_popup_close(x0 : Pointer(Context))
  fun popup_end = nk_popup_end(x0 : Pointer(Context))
  fun popup_get_scroll = nk_popup_get_scroll(x0 : Pointer(Context), offset_x : Pointer(Void), offset_y : Pointer(Void))
  fun popup_set_scroll = nk_popup_set_scroll(x0 : Pointer(Context), offset_x : UInt32, offset_y : UInt32)
  fun combo = nk_combo(x0 : Pointer(Context), items : Pointer(Pointer(LibC::Char)), count : LibC::Int, selected : LibC::Int, item_height : LibC::Int, size : Vec2) : LibC::Int
  fun combo_separator = nk_combo_separator(x0 : Pointer(Context), items_separated_by_separator : Pointer(LibC::Char), separator : LibC::Int, selected : LibC::Int, count : LibC::Int, item_height : LibC::Int, size : Vec2) : LibC::Int
  fun combo_string = nk_combo_string(x0 : Pointer(Context), items_separated_by_zeros : Pointer(LibC::Char), selected : LibC::Int, count : LibC::Int, item_height : LibC::Int, size : Vec2) : LibC::Int
  fun combo_callback = nk_combo_callback(x0 : Pointer(Context), item_getter : Pointer(Void), LibC::Int, Pointer(Pointer(LibC::Char)) -> Void, userdata : Pointer(Void), selected : LibC::Int, count : LibC::Int, item_height : LibC::Int, size : Vec2) : LibC::Int
  fun combobox = nk_combobox(x0 : Pointer(Context), items : Pointer(Pointer(LibC::Char)), count : LibC::Int, selected : Pointer(LibC::Int), item_height : LibC::Int, size : Vec2)
  fun combobox_string = nk_combobox_string(x0 : Pointer(Context), items_separated_by_zeros : Pointer(LibC::Char), selected : Pointer(LibC::Int), count : LibC::Int, item_height : LibC::Int, size : Vec2)
  fun combobox_separator = nk_combobox_separator(x0 : Pointer(Context), items_separated_by_separator : Pointer(LibC::Char), separator : LibC::Int, selected : Pointer(LibC::Int), count : LibC::Int, item_height : LibC::Int, size : Vec2)
  fun combobox_callback = nk_combobox_callback(x0 : Pointer(Context), item_getter : Pointer(Void), LibC::Int, Pointer(Pointer(LibC::Char)) -> Void, x2 : Pointer(Void), selected : Pointer(LibC::Int), count : LibC::Int, item_height : LibC::Int, size : Vec2)
  fun combo_begin_text = nk_combo_begin_text(x0 : Pointer(Context), selected : Pointer(LibC::Char), x2 : LibC::Int, size : Vec2)
  fun combo_begin_label = nk_combo_begin_label(x0 : Pointer(Context), selected : Pointer(LibC::Char), size : Vec2)
  fun combo_begin_color = nk_combo_begin_color(x0 : Pointer(Context), color : Color, size : Vec2)
  fun combo_begin_symbol = nk_combo_begin_symbol(x0 : Pointer(Context), x1 : SymbolType, size : Vec2)
  fun combo_begin_symbol_label = nk_combo_begin_symbol_label(x0 : Pointer(Context), selected : Pointer(LibC::Char), x2 : SymbolType, size : Vec2)
  fun combo_begin_symbol_text = nk_combo_begin_symbol_text(x0 : Pointer(Context), selected : Pointer(LibC::Char), x2 : LibC::Int, x3 : SymbolType, size : Vec2)
  fun combo_begin_image = nk_combo_begin_image(x0 : Pointer(Context), img : Image, size : Vec2)
  fun combo_begin_image_label = nk_combo_begin_image_label(x0 : Pointer(Context), selected : Pointer(LibC::Char), x2 : Image, size : Vec2)
  fun combo_begin_image_text = nk_combo_begin_image_text(x0 : Pointer(Context), selected : Pointer(LibC::Char), x2 : LibC::Int, x3 : Image, size : Vec2)
  fun combo_item_label = nk_combo_item_label(x0 : Pointer(Context), x1 : Pointer(LibC::Char), alignment : Flags)
  fun combo_item_text = nk_combo_item_text(x0 : Pointer(Context), x1 : Pointer(LibC::Char), x2 : LibC::Int, alignment : Flags)
  fun combo_item_image_label = nk_combo_item_image_label(x0 : Pointer(Context), x1 : Image, x2 : Pointer(LibC::Char), alignment : Flags)
  fun combo_item_image_text = nk_combo_item_image_text(x0 : Pointer(Context), x1 : Image, x2 : Pointer(LibC::Char), x3 : LibC::Int, alignment : Flags)
  fun combo_item_symbol_label = nk_combo_item_symbol_label(x0 : Pointer(Context), x1 : SymbolType, x2 : Pointer(LibC::Char), alignment : Flags)
  fun combo_item_symbol_text = nk_combo_item_symbol_text(x0 : Pointer(Context), x1 : SymbolType, x2 : Pointer(LibC::Char), x3 : LibC::Int, alignment : Flags)
  fun combo_close = nk_combo_close(x0 : Pointer(Context))
  fun combo_end = nk_combo_end(x0 : Pointer(Context))
  fun contextual_begin = nk_contextual_begin(x0 : Pointer(Context), x1 : Flags, x2 : Vec2, trigger_bounds : Rect)
  fun contextual_item_text = nk_contextual_item_text(x0 : Pointer(Context), x1 : Pointer(LibC::Char), x2 : LibC::Int, align : Flags)
  fun contextual_item_label = nk_contextual_item_label(x0 : Pointer(Context), x1 : Pointer(LibC::Char), align : Flags)
  fun contextual_item_image_label = nk_contextual_item_image_label(x0 : Pointer(Context), x1 : Image, x2 : Pointer(LibC::Char), alignment : Flags)
  fun contextual_item_image_text = nk_contextual_item_image_text(x0 : Pointer(Context), x1 : Image, x2 : Pointer(LibC::Char), len : LibC::Int, alignment : Flags)
  fun contextual_item_symbol_label = nk_contextual_item_symbol_label(x0 : Pointer(Context), x1 : SymbolType, x2 : Pointer(LibC::Char), alignment : Flags)
  fun contextual_item_symbol_text = nk_contextual_item_symbol_text(x0 : Pointer(Context), x1 : SymbolType, x2 : Pointer(LibC::Char), x3 : LibC::Int, alignment : Flags)
  fun contextual_close = nk_contextual_close(x0 : Pointer(Context))
  fun contextual_end = nk_contextual_end(x0 : Pointer(Context))
  fun tooltip = nk_tooltip(x0 : Pointer(Context), x1 : Pointer(LibC::Char))
  fun tooltip_offset = nk_tooltip_offset(ctx : Pointer(Context), text : Pointer(LibC::Char), position : TooltipPos, offset : Vec2)
  fun do_tooltip = nk_do_tooltip(x0 : Pointer(Context), x1 : Pointer(LibC::Char), x2 : Rect)
  fun do_tooltip_delay = nk_do_tooltip_delay(x0 : Pointer(Context), x1 : Pointer(LibC::Char), x2 : Rect, x3 : Pointer(LibC::Float))
  fun do_tooltip_delay_clicked = nk_do_tooltip_delay_clicked(x0 : Pointer(Context), x1 : Pointer(LibC::Char), x2 : Rect, timer : Pointer(LibC::Float), x4 : Pointer(Void))
  fun tooltip_begin = nk_tooltip_begin(x0 : Pointer(Context), width : LibC::Float)
  fun tooltip_begin_offset = nk_tooltip_begin_offset(x0 : Pointer(Context), x1 : LibC::Float, x2 : TooltipPos, x3 : Vec2)
  fun tooltip_end = nk_tooltip_end(x0 : Pointer(Context))
  fun menubar_begin = nk_menubar_begin(x0 : Pointer(Context))
  fun menubar_end = nk_menubar_end(x0 : Pointer(Context))
  fun menu_begin_text = nk_menu_begin_text(x0 : Pointer(Context), title : Pointer(LibC::Char), title_len : LibC::Int, align : Flags, size : Vec2)
  fun menu_begin_label = nk_menu_begin_label(x0 : Pointer(Context), x1 : Pointer(LibC::Char), align : Flags, size : Vec2)
  fun menu_begin_image = nk_menu_begin_image(x0 : Pointer(Context), x1 : Pointer(LibC::Char), x2 : Image, size : Vec2)
  fun menu_begin_image_text = nk_menu_begin_image_text(x0 : Pointer(Context), x1 : Pointer(LibC::Char), x2 : LibC::Int, align : Flags, x4 : Image, size : Vec2)
  fun menu_begin_image_label = nk_menu_begin_image_label(x0 : Pointer(Context), x1 : Pointer(LibC::Char), align : Flags, x3 : Image, size : Vec2)
  fun menu_begin_symbol = nk_menu_begin_symbol(x0 : Pointer(Context), x1 : Pointer(LibC::Char), x2 : SymbolType, size : Vec2)
  fun menu_begin_symbol_text = nk_menu_begin_symbol_text(x0 : Pointer(Context), x1 : Pointer(LibC::Char), x2 : LibC::Int, align : Flags, x4 : SymbolType, size : Vec2)
  fun menu_begin_symbol_label = nk_menu_begin_symbol_label(x0 : Pointer(Context), x1 : Pointer(LibC::Char), align : Flags, x3 : SymbolType, size : Vec2)
  fun menu_item_text = nk_menu_item_text(x0 : Pointer(Context), x1 : Pointer(LibC::Char), x2 : LibC::Int, align : Flags)
  fun menu_item_label = nk_menu_item_label(x0 : Pointer(Context), x1 : Pointer(LibC::Char), alignment : Flags)
  fun menu_item_image_label = nk_menu_item_image_label(x0 : Pointer(Context), x1 : Image, x2 : Pointer(LibC::Char), alignment : Flags)
  fun menu_item_image_text = nk_menu_item_image_text(x0 : Pointer(Context), x1 : Image, x2 : Pointer(LibC::Char), len : LibC::Int, alignment : Flags)
  fun menu_item_symbol_text = nk_menu_item_symbol_text(x0 : Pointer(Context), x1 : SymbolType, x2 : Pointer(LibC::Char), x3 : LibC::Int, alignment : Flags)
  fun menu_item_symbol_label = nk_menu_item_symbol_label(x0 : Pointer(Context), x1 : SymbolType, x2 : Pointer(LibC::Char), alignment : Flags)
  fun menu_close = nk_menu_close(x0 : Pointer(Context))
  fun menu_end = nk_menu_end(x0 : Pointer(Context))
  fun style_default = nk_style_default(x0 : Pointer(Context))
  fun style_from_table = nk_style_from_table(x0 : Pointer(Context), x1 : Pointer(Color))
  fun style_load_cursor = nk_style_load_cursor(x0 : Pointer(Context), x1 : StyleCursor, x2 : Pointer(Cursor))
  enum StyleCursor
    NkCursorArrow = 0
    NkCursorText = 1
    NkCursorMove = 2
    NkCursorResizeVertical = 3
    NkCursorResizeHorizontal = 4
    NkCursorResizeTopLeftDownRight = 5
    NkCursorResizeTopRightDownLeft = 6
    NkCursorCount = 7
  end
  fun style_load_all_cursors = nk_style_load_all_cursors(x0 : Pointer(Context), x1 : Pointer(Cursor))
  fun style_get_color_by_name = nk_style_get_color_by_name(x0 : StyleColors) : Pointer(LibC::Char)
  enum StyleColors
    NkColorText = 0
    NkColorWindow = 1
    NkColorHeader = 2
    NkColorBorder = 3
    NkColorButton = 4
    NkColorButtonHover = 5
    NkColorButtonActive = 6
    NkColorToggle = 7
    NkColorToggleHover = 8
    NkColorToggleCursor = 9
    NkColorSelect = 10
    NkColorSelectActive = 11
    NkColorSlider = 12
    NkColorSliderCursor = 13
    NkColorSliderCursorHover = 14
    NkColorSliderCursorActive = 15
    NkColorProperty = 16
    NkColorEdit = 17
    NkColorEditCursor = 18
    NkColorCombo = 19
    NkColorChart = 20
    NkColorChartColor = 21
    NkColorChartColorHighlight = 22
    NkColorScrollbar = 23
    NkColorScrollbarCursor = 24
    NkColorScrollbarCursorHover = 25
    NkColorScrollbarCursorActive = 26
    NkColorTabHeader = 27
    NkColorKnob = 28
    NkColorKnobCursor = 29
    NkColorKnobCursorHover = 30
    NkColorKnobCursorActive = 31
    NkColorCount = 32
  end
  fun style_set_font = nk_style_set_font(x0 : Pointer(Context), x1 : Pointer(UserFont))
  fun style_set_cursor = nk_style_set_cursor(x0 : Pointer(Context), x1 : StyleCursor)
  fun style_show_cursor = nk_style_show_cursor(x0 : Pointer(Context))
  fun style_hide_cursor = nk_style_hide_cursor(x0 : Pointer(Context))
  fun style_push_font = nk_style_push_font(x0 : Pointer(Context), x1 : Pointer(UserFont))
  fun style_push_float = nk_style_push_float(x0 : Pointer(Context), x1 : Pointer(LibC::Float), x2 : LibC::Float)
  fun style_push_vec2 = nk_style_push_vec2(x0 : Pointer(Context), x1 : Pointer(Vec2), x2 : Vec2)
  fun style_push_style_item = nk_style_push_style_item(x0 : Pointer(Context), x1 : Pointer(StyleItem), x2 : StyleItem)
  fun style_push_flags = nk_style_push_flags(x0 : Pointer(Context), x1 : Pointer(Void), x2 : Flags)
  fun style_push_color = nk_style_push_color(x0 : Pointer(Context), x1 : Pointer(Color), x2 : Color)
  fun style_pop_font = nk_style_pop_font(x0 : Pointer(Context))
  fun style_pop_float = nk_style_pop_float(x0 : Pointer(Context))
  fun style_pop_vec2 = nk_style_pop_vec2(x0 : Pointer(Context))
  fun style_pop_style_item = nk_style_pop_style_item(x0 : Pointer(Context))
  fun style_pop_flags = nk_style_pop_flags(x0 : Pointer(Context))
  fun style_pop_color = nk_style_pop_color(x0 : Pointer(Context))
  fun rgb = nk_rgb(r : LibC::Int, g : LibC::Int, b : LibC::Int) : Color
  fun rgb_iv = nk_rgb_iv(rgb : Pointer(LibC::Int)) : Color
  fun rgb_bv = nk_rgb_bv(rgb : Pointer(Void)) : Color
  fun rgb_f = nk_rgb_f(r : LibC::Float, g : LibC::Float, b : LibC::Float) : Color
  fun rgb_fv = nk_rgb_fv(rgb : Pointer(LibC::Float)) : Color
  fun rgb_cf = nk_rgb_cf(c : Colorf) : Color
  fun rgb_hex = nk_rgb_hex(rgb : Pointer(LibC::Char)) : Color
  fun rgb_factor = nk_rgb_factor(col : Color, factor : LibC::Float) : Color
  fun rgba = nk_rgba(r : LibC::Int, g : LibC::Int, b : LibC::Int, a : LibC::Int) : Color
  fun rgba_u32 = nk_rgba_u32(x0 : UInt32) : Color
  fun rgba_iv = nk_rgba_iv(rgba : Pointer(LibC::Int)) : Color
  fun rgba_bv = nk_rgba_bv(rgba : Pointer(Void)) : Color
  fun rgba_f = nk_rgba_f(r : LibC::Float, g : LibC::Float, b : LibC::Float, a : LibC::Float) : Color
  fun rgba_fv = nk_rgba_fv(rgba : Pointer(LibC::Float)) : Color
  fun rgba_cf = nk_rgba_cf(c : Colorf) : Color
  fun rgba_hex = nk_rgba_hex(rgb : Pointer(LibC::Char)) : Color
  fun hsva_colorf = nk_hsva_colorf(h : LibC::Float, s : LibC::Float, v : LibC::Float, a : LibC::Float) : Colorf
  fun hsva_colorfv = nk_hsva_colorfv(c : Pointer(LibC::Float)) : Colorf
  fun colorf_hsva_f = nk_colorf_hsva_f(out_h : Pointer(LibC::Float), out_s : Pointer(LibC::Float), out_v : Pointer(LibC::Float), out_a : Pointer(LibC::Float), in : Colorf)
  fun colorf_hsva_fv = nk_colorf_hsva_fv(hsva : Pointer(LibC::Float), in : Colorf)
  fun hsv = nk_hsv(h : LibC::Int, s : LibC::Int, v : LibC::Int) : Color
  fun hsv_iv = nk_hsv_iv(hsv : Pointer(LibC::Int)) : Color
  fun hsv_bv = nk_hsv_bv(hsv : Pointer(Void)) : Color
  fun hsv_f = nk_hsv_f(h : LibC::Float, s : LibC::Float, v : LibC::Float) : Color
  fun hsv_fv = nk_hsv_fv(hsv : Pointer(LibC::Float)) : Color
  fun hsva = nk_hsva(h : LibC::Int, s : LibC::Int, v : LibC::Int, a : LibC::Int) : Color
  fun hsva_iv = nk_hsva_iv(hsva : Pointer(LibC::Int)) : Color
  fun hsva_bv = nk_hsva_bv(hsva : Pointer(Void)) : Color
  fun hsva_f = nk_hsva_f(h : LibC::Float, s : LibC::Float, v : LibC::Float, a : LibC::Float) : Color
  fun hsva_fv = nk_hsva_fv(hsva : Pointer(LibC::Float)) : Color
  fun color_f = nk_color_f(r : Pointer(LibC::Float), g : Pointer(LibC::Float), b : Pointer(LibC::Float), a : Pointer(LibC::Float), x4 : Color)
  fun color_fv = nk_color_fv(rgba_out : Pointer(LibC::Float), x1 : Color)
  fun color_cf = nk_color_cf(x0 : Color) : Colorf
  fun color_d = nk_color_d(r : Pointer(LibC::Double), g : Pointer(LibC::Double), b : Pointer(LibC::Double), a : Pointer(LibC::Double), x4 : Color)
  fun color_dv = nk_color_dv(rgba_out : Pointer(LibC::Double), x1 : Color)
  fun color_u32 = nk_color_u32(x0 : Color)
  fun color_hex_rgba = nk_color_hex_rgba(output : Pointer(LibC::Char), x1 : Color)
  fun color_hex_rgb = nk_color_hex_rgb(output : Pointer(LibC::Char), x1 : Color)
  fun color_hsv_i = nk_color_hsv_i(out_h : Pointer(LibC::Int), out_s : Pointer(LibC::Int), out_v : Pointer(LibC::Int), x3 : Color)
  fun color_hsv_b = nk_color_hsv_b(out_h : Pointer(Void), out_s : Pointer(Void), out_v : Pointer(Void), x3 : Color)
  fun color_hsv_iv = nk_color_hsv_iv(hsv_out : Pointer(LibC::Int), x1 : Color)
  fun color_hsv_bv = nk_color_hsv_bv(hsv_out : Pointer(Void), x1 : Color)
  fun color_hsv_f = nk_color_hsv_f(out_h : Pointer(LibC::Float), out_s : Pointer(LibC::Float), out_v : Pointer(LibC::Float), x3 : Color)
  fun color_hsv_fv = nk_color_hsv_fv(hsv_out : Pointer(LibC::Float), x1 : Color)
  fun color_hsva_i = nk_color_hsva_i(h : Pointer(LibC::Int), s : Pointer(LibC::Int), v : Pointer(LibC::Int), a : Pointer(LibC::Int), x4 : Color)
  fun color_hsva_b = nk_color_hsva_b(h : Pointer(Void), s : Pointer(Void), v : Pointer(Void), a : Pointer(Void), x4 : Color)
  fun color_hsva_iv = nk_color_hsva_iv(hsva_out : Pointer(LibC::Int), x1 : Color)
  fun color_hsva_bv = nk_color_hsva_bv(hsva_out : Pointer(Void), x1 : Color)
  fun color_hsva_f = nk_color_hsva_f(out_h : Pointer(LibC::Float), out_s : Pointer(LibC::Float), out_v : Pointer(LibC::Float), out_a : Pointer(LibC::Float), x4 : Color)
  fun color_hsva_fv = nk_color_hsva_fv(hsva_out : Pointer(LibC::Float), x1 : Color)
  fun handle_ptr = nk_handle_ptr(x0 : Pointer(Void))
  fun handle_id = nk_handle_id(x0 : LibC::Int)
  fun image_handle = nk_image_handle(x0 : Handle) : Image
  fun image_ptr = nk_image_ptr(x0 : Pointer(Void)) : Image
  fun image_id = nk_image_id(x0 : LibC::Int) : Image
  fun image_is_subimage = nk_image_is_subimage(img : Pointer(Image))
  fun subimage_ptr = nk_subimage_ptr(x0 : Pointer(Void), w : UInt16, h : UInt16, sub_region : Rect) : Image
  fun subimage_id = nk_subimage_id(x0 : LibC::Int, w : UInt16, h : UInt16, sub_region : Rect) : Image
  fun subimage_handle = nk_subimage_handle(x0 : Handle, w : UInt16, h : UInt16, sub_region : Rect) : Image
  fun nine_slice_handle = nk_nine_slice_handle(x0 : Handle, l : UInt16, t : UInt16, r : UInt16, b : UInt16) : NineSlice
  fun nine_slice_ptr = nk_nine_slice_ptr(x0 : Pointer(Void), l : UInt16, t : UInt16, r : UInt16, b : UInt16) : NineSlice
  fun nine_slice_id = nk_nine_slice_id(x0 : LibC::Int, l : UInt16, t : UInt16, r : UInt16, b : UInt16) : NineSlice
  fun nine_slice_is_sub9slice = nk_nine_slice_is_sub9slice(img : Pointer(NineSlice)) : LibC::Int
  fun sub9slice_ptr = nk_sub9slice_ptr(x0 : Pointer(Void), w : UInt16, h : UInt16, sub_region : Rect, l : UInt16, t : UInt16, r : UInt16, b : UInt16) : NineSlice
  fun sub9slice_id = nk_sub9slice_id(x0 : LibC::Int, w : UInt16, h : UInt16, sub_region : Rect, l : UInt16, t : UInt16, r : UInt16, b : UInt16) : NineSlice
  fun sub9slice_handle = nk_sub9slice_handle(x0 : Handle, w : UInt16, h : UInt16, sub_region : Rect, l : UInt16, t : UInt16, r : UInt16, b : UInt16) : NineSlice
  fun murmur_hash = nk_murmur_hash(key : Pointer(Void), len : LibC::Int, seed : UInt32)
  fun triangle_from_direction = nk_triangle_from_direction(result : Pointer(Vec2), r : Rect, pad_x : LibC::Float, pad_y : LibC::Float, x4 : Heading)
  fun vec2 = nk_vec2(x : LibC::Float, y : LibC::Float) : Vec2
  fun vec2i = nk_vec2i(x : LibC::Int, y : LibC::Int) : Vec2
  fun vec2v = nk_vec2v(xy : Pointer(LibC::Float)) : Vec2
  fun vec2iv = nk_vec2iv(xy : Pointer(LibC::Int)) : Vec2
  fun get_null_rect = nk_get_null_rect : Rect
  fun rect = nk_rect(x : LibC::Float, y : LibC::Float, w : LibC::Float, h : LibC::Float) : Rect
  fun recti = nk_recti(x : LibC::Int, y : LibC::Int, w : LibC::Int, h : LibC::Int) : Rect
  fun recta = nk_recta(pos : Vec2, size : Vec2) : Rect
  fun rectv = nk_rectv(xywh : Pointer(LibC::Float)) : Rect
  fun rectiv = nk_rectiv(xywh : Pointer(LibC::Int)) : Rect
  fun rect_pos = nk_rect_pos(x0 : Rect) : Vec2
  fun rect_size = nk_rect_size(x0 : Rect) : Vec2
  fun strlen = nk_strlen(str : Pointer(LibC::Char)) : LibC::Int
  fun stricmp = nk_stricmp(s1 : Pointer(LibC::Char), s2 : Pointer(LibC::Char)) : LibC::Int
  fun stricmpn = nk_stricmpn(s1 : Pointer(LibC::Char), s2 : Pointer(LibC::Char), n : LibC::Int) : LibC::Int
  fun strtoi = nk_strtoi(str : Pointer(LibC::Char), endptr : Pointer(Pointer(LibC::Char))) : LibC::Int
  fun strtof = nk_strtof(str : Pointer(LibC::Char), endptr : Pointer(Pointer(LibC::Char))) : LibC::Float
  fun strtod = nk_strtod(str : Pointer(LibC::Char), endptr : Pointer(Pointer(LibC::Char))) : LibC::Double
  fun strfilter = nk_strfilter(text : Pointer(LibC::Char), regexp : Pointer(LibC::Char)) : LibC::Int
  fun strmatch_fuzzy_string = nk_strmatch_fuzzy_string(str : Pointer(LibC::Char), pattern : Pointer(LibC::Char), out_score : Pointer(LibC::Int)) : LibC::Int
  fun strmatch_fuzzy_text = nk_strmatch_fuzzy_text(txt : Pointer(LibC::Char), txt_len : LibC::Int, pattern : Pointer(LibC::Char), out_score : Pointer(LibC::Int)) : LibC::Int
  fun utf_decode = nk_utf_decode(x0 : Pointer(LibC::Char), x1 : Pointer(Void), x2 : LibC::Int) : LibC::Int
  fun utf_encode = nk_utf_encode(x0 : UInt32, x1 : Pointer(LibC::Char), x2 : LibC::Int) : LibC::Int
  fun utf_len = nk_utf_len(x0 : Pointer(LibC::Char), byte_len : LibC::Int) : LibC::Int
  fun utf_at = nk_utf_at(buffer : Pointer(LibC::Char), length : LibC::Int, index : LibC::Int, unicode : Pointer(Void), len : Pointer(LibC::Int)) : Pointer(LibC::Char)
  alias UserFontGlyph = Void
  struct MemoryStatus
    memory : Pointer(Void)
    type : LibC::UInt
    size : Size
    allocated : Size
    needed : Size
    calls : Size
  end
  fun buffer_init = nk_buffer_init(x0 : Pointer(Buffer), x1 : Pointer(Allocator), size : Size)
  fun buffer_init_fixed = nk_buffer_init_fixed(x0 : Pointer(Buffer), memory : Pointer(Void), size : Size)
  fun buffer_info = nk_buffer_info(x0 : Pointer(MemoryStatus), x1 : Pointer(Buffer))
  fun buffer_push = nk_buffer_push(x0 : Pointer(Buffer), type : BufferAllocationType, memory : Pointer(Void), size : Size, align : Flags)
  enum BufferAllocationType
    NkBufferFront = 0
    NkBufferBack = 1
    NkBufferMax = 2
  end
  fun buffer_mark = nk_buffer_mark(x0 : Pointer(Buffer), type : BufferAllocationType)
  fun buffer_reset = nk_buffer_reset(x0 : Pointer(Buffer), type : BufferAllocationType)
  fun buffer_clear = nk_buffer_clear(x0 : Pointer(Buffer))
  fun buffer_free = nk_buffer_free(x0 : Pointer(Buffer))
  fun buffer_memory = nk_buffer_memory(x0 : Pointer(Buffer)) : Pointer(Void)
  fun buffer_memory_const = nk_buffer_memory_const(x0 : Pointer(Buffer)) : Pointer(Void)
  fun buffer_total = nk_buffer_total(x0 : Pointer(Buffer))
  fun str_init = nk_str_init(x0 : Pointer(Str), x1 : Pointer(Allocator), size : Size)
  fun str_init_fixed = nk_str_init_fixed(x0 : Pointer(Str), memory : Pointer(Void), size : Size)
  fun str_clear = nk_str_clear(x0 : Pointer(Str))
  fun str_free = nk_str_free(x0 : Pointer(Str))
  fun str_append_text_char = nk_str_append_text_char(x0 : Pointer(Str), x1 : Pointer(LibC::Char), x2 : LibC::Int) : LibC::Int
  fun str_append_str_char = nk_str_append_str_char(x0 : Pointer(Str), x1 : Pointer(LibC::Char)) : LibC::Int
  fun str_append_text_utf8 = nk_str_append_text_utf8(x0 : Pointer(Str), x1 : Pointer(LibC::Char), x2 : LibC::Int) : LibC::Int
  fun str_append_str_utf8 = nk_str_append_str_utf8(x0 : Pointer(Str), x1 : Pointer(LibC::Char)) : LibC::Int
  fun str_append_text_runes = nk_str_append_text_runes(x0 : Pointer(Str), x1 : Pointer(Void), x2 : LibC::Int) : LibC::Int
  fun str_append_str_runes = nk_str_append_str_runes(x0 : Pointer(Str), x1 : Pointer(Void)) : LibC::Int
  fun str_insert_at_char = nk_str_insert_at_char(x0 : Pointer(Str), pos : LibC::Int, x2 : Pointer(LibC::Char), x3 : LibC::Int) : LibC::Int
  fun str_insert_at_rune = nk_str_insert_at_rune(x0 : Pointer(Str), pos : LibC::Int, x2 : Pointer(LibC::Char), x3 : LibC::Int) : LibC::Int
  fun str_insert_text_char = nk_str_insert_text_char(x0 : Pointer(Str), pos : LibC::Int, x2 : Pointer(LibC::Char), x3 : LibC::Int) : LibC::Int
  fun str_insert_str_char = nk_str_insert_str_char(x0 : Pointer(Str), pos : LibC::Int, x2 : Pointer(LibC::Char)) : LibC::Int
  fun str_insert_text_utf8 = nk_str_insert_text_utf8(x0 : Pointer(Str), pos : LibC::Int, x2 : Pointer(LibC::Char), x3 : LibC::Int) : LibC::Int
  fun str_insert_str_utf8 = nk_str_insert_str_utf8(x0 : Pointer(Str), pos : LibC::Int, x2 : Pointer(LibC::Char)) : LibC::Int
  fun str_insert_text_runes = nk_str_insert_text_runes(x0 : Pointer(Str), pos : LibC::Int, x2 : Pointer(Void), x3 : LibC::Int) : LibC::Int
  fun str_insert_str_runes = nk_str_insert_str_runes(x0 : Pointer(Str), pos : LibC::Int, x2 : Pointer(Void)) : LibC::Int
  fun str_remove_chars = nk_str_remove_chars(x0 : Pointer(Str), len : LibC::Int)
  fun str_remove_runes = nk_str_remove_runes(str : Pointer(Str), len : LibC::Int)
  fun str_delete_chars = nk_str_delete_chars(x0 : Pointer(Str), pos : LibC::Int, len : LibC::Int)
  fun str_delete_runes = nk_str_delete_runes(x0 : Pointer(Str), pos : LibC::Int, len : LibC::Int)
  fun str_at_char = nk_str_at_char(x0 : Pointer(Str), pos : LibC::Int) : Pointer(LibC::Char)
  fun str_at_rune = nk_str_at_rune(x0 : Pointer(Str), pos : LibC::Int, unicode : Pointer(Void), len : Pointer(LibC::Int)) : Pointer(LibC::Char)
  fun str_rune_at = nk_str_rune_at(x0 : Pointer(Str), pos : LibC::Int)
  fun str_at_char_const = nk_str_at_char_const(x0 : Pointer(Str), pos : LibC::Int) : Pointer(LibC::Char)
  fun str_at_const = nk_str_at_const(x0 : Pointer(Str), pos : LibC::Int, unicode : Pointer(Void), len : Pointer(LibC::Int)) : Pointer(LibC::Char)
  fun str_get = nk_str_get(x0 : Pointer(Str)) : Pointer(LibC::Char)
  fun str_get_const = nk_str_get_const(x0 : Pointer(Str)) : Pointer(LibC::Char)
  fun str_len = nk_str_len(x0 : Pointer(Str)) : LibC::Int
  fun str_len_char = nk_str_len_char(x0 : Pointer(Str)) : LibC::Int
  fun filter_default = nk_filter_default(x0 : Pointer(TextEdit), unicode : UInt32) : Bool
  fun filter_ascii = nk_filter_ascii(x0 : Pointer(TextEdit), unicode : UInt32) : Bool
  fun filter_float = nk_filter_float(x0 : Pointer(TextEdit), unicode : UInt32) : Bool
  fun filter_decimal = nk_filter_decimal(x0 : Pointer(TextEdit), unicode : UInt32) : Bool
  fun filter_hex = nk_filter_hex(x0 : Pointer(TextEdit), unicode : UInt32) : Bool
  fun filter_oct = nk_filter_oct(x0 : Pointer(TextEdit), unicode : UInt32) : Bool
  fun filter_binary = nk_filter_binary(x0 : Pointer(TextEdit), unicode : UInt32) : Bool
  fun textedit_init = nk_textedit_init(x0 : Pointer(TextEdit), x1 : Pointer(Allocator), size : Size)
  fun textedit_init_fixed = nk_textedit_init_fixed(x0 : Pointer(TextEdit), memory : Pointer(Void), size : Size)
  fun textedit_free = nk_textedit_free(x0 : Pointer(TextEdit))
  fun textedit_text = nk_textedit_text(x0 : Pointer(TextEdit), x1 : Pointer(LibC::Char), total_len : LibC::Int)
  fun textedit_delete = nk_textedit_delete(x0 : Pointer(TextEdit), where : LibC::Int, len : LibC::Int)
  fun textedit_delete_selection = nk_textedit_delete_selection(x0 : Pointer(TextEdit))
  fun textedit_select_all = nk_textedit_select_all(x0 : Pointer(TextEdit))
  fun textedit_cut = nk_textedit_cut(x0 : Pointer(TextEdit))
  fun textedit_paste = nk_textedit_paste(x0 : Pointer(TextEdit), x1 : Pointer(LibC::Char), len : LibC::Int)
  fun textedit_undo = nk_textedit_undo(x0 : Pointer(TextEdit))
  fun textedit_redo = nk_textedit_redo(x0 : Pointer(TextEdit))
  struct CommandScissor
    header : Command
    x : LibC::Short
    y : LibC::Short
    w : LibC::UShort
    h : LibC::UShort
  end
  struct CommandLine
    header : Command
    line_thickness : LibC::UShort
    begin : Vec2i
    _end : Vec2i
    color : Color
  end
  struct CommandCurve
    header : Command
    line_thickness : LibC::UShort
    begin : Vec2i
    _end : Vec2i
    ctrl : StaticArray(Vec2i, 2)
    color : Color
  end
  struct CommandRect
    header : Command
    rounding : LibC::UShort
    line_thickness : LibC::UShort
    x : LibC::Short
    y : LibC::Short
    w : LibC::UShort
    h : LibC::UShort
    color : Color
  end
  struct CommandRectFilled
    header : Command
    rounding : LibC::UShort
    x : LibC::Short
    y : LibC::Short
    w : LibC::UShort
    h : LibC::UShort
    color : Color
  end
  struct CommandRectMultiColor
    header : Command
    x : LibC::Short
    y : LibC::Short
    w : LibC::UShort
    h : LibC::UShort
    left : Color
    top : Color
    bottom : Color
    right : Color
  end
  struct CommandTriangle
    header : Command
    line_thickness : LibC::UShort
    a : Vec2i
    b : Vec2i
    c : Vec2i
    color : Color
  end
  struct CommandTriangleFilled
    header : Command
    a : Vec2i
    b : Vec2i
    c : Vec2i
    color : Color
  end
  struct CommandCircle
    header : Command
    x : LibC::Short
    y : LibC::Short
    line_thickness : LibC::UShort
    w : LibC::UShort
    h : LibC::UShort
    color : Color
  end
  struct CommandCircleFilled
    header : Command
    x : LibC::Short
    y : LibC::Short
    w : LibC::UShort
    h : LibC::UShort
    color : Color
  end
  struct CommandArc
    header : Command
    cx : LibC::Short
    cy : LibC::Short
    r : LibC::UShort
    line_thickness : LibC::UShort
    a : StaticArray(LibC::Float, 2)
    color : Color
  end
  struct CommandArcFilled
    header : Command
    cx : LibC::Short
    cy : LibC::Short
    r : LibC::UShort
    a : StaticArray(LibC::Float, 2)
    color : Color
  end
  struct CommandPolygon
    header : Command
    color : Color
    line_thickness : LibC::UShort
    point_count : LibC::UShort
    points : StaticArray(Vec2i, 1)
  end
  struct CommandPolygonFilled
    header : Command
    color : Color
    point_count : LibC::UShort
    points : StaticArray(Vec2i, 1)
  end
  struct CommandPolyline
    header : Command
    color : Color
    line_thickness : LibC::UShort
    point_count : LibC::UShort
    points : StaticArray(Vec2i, 1)
  end
  struct CommandImage
    header : Command
    x : LibC::Short
    y : LibC::Short
    w : LibC::UShort
    h : LibC::UShort
    img : Image
    col : Color
  end
  alias CommandCustomCallback = Proc(
    Void*,        # canvas
    Int16,        # x
    Int16,        # y
    UInt16,       # w
    UInt16,       # h
    Pointer(Void) # nk_handle
  )
  struct CommandCustom
    header : Command
    x : LibC::Short
    y : LibC::Short
    w : LibC::UShort
    h : LibC::UShort
    callback_data : Handle
    callback : CommandCustomCallback
  end
  struct CommandText
    header : Command
    font : Pointer(UserFont)
    background : Color
    foreground : Color
    x : LibC::Short
    y : LibC::Short
    w : LibC::UShort
    h : LibC::UShort
    height : LibC::Float
    length : LibC::Int
    string : StaticArray(LibC::Char, 2)
  end
  fun stroke_line = nk_stroke_line(b : Pointer(CommandBuffer), x0 : LibC::Float, y0 : LibC::Float, x1 : LibC::Float, y1 : LibC::Float, line_thickness : LibC::Float, x6 : Color)
  fun stroke_curve = nk_stroke_curve(x0 : Pointer(CommandBuffer), x1 : LibC::Float, x2 : LibC::Float, x3 : LibC::Float, x4 : LibC::Float, x5 : LibC::Float, x6 : LibC::Float, x7 : LibC::Float, x8 : LibC::Float, line_thickness : LibC::Float, x10 : Color)
  fun stroke_rect = nk_stroke_rect(x0 : Pointer(CommandBuffer), x1 : Rect, rounding : LibC::Float, line_thickness : LibC::Float, x4 : Color)
  fun stroke_circle = nk_stroke_circle(x0 : Pointer(CommandBuffer), x1 : Rect, line_thickness : LibC::Float, x3 : Color)
  fun stroke_arc = nk_stroke_arc(x0 : Pointer(CommandBuffer), cx : LibC::Float, cy : LibC::Float, radius : LibC::Float, a_min : LibC::Float, a_max : LibC::Float, line_thickness : LibC::Float, x7 : Color)
  fun stroke_triangle = nk_stroke_triangle(x0 : Pointer(CommandBuffer), x1 : LibC::Float, x2 : LibC::Float, x3 : LibC::Float, x4 : LibC::Float, x5 : LibC::Float, x6 : LibC::Float, line_thichness : LibC::Float, x8 : Color)
  fun stroke_polyline = nk_stroke_polyline(x0 : Pointer(CommandBuffer), points : Pointer(LibC::Float), point_count : LibC::Int, line_thickness : LibC::Float, col : Color)
  fun stroke_polygon = nk_stroke_polygon(x0 : Pointer(CommandBuffer), points : Pointer(LibC::Float), point_count : LibC::Int, line_thickness : LibC::Float, x4 : Color)
  fun fill_rect = nk_fill_rect(x0 : Pointer(CommandBuffer), x1 : Rect, rounding : LibC::Float, x3 : Color)
  fun fill_rect_multi_color = nk_fill_rect_multi_color(x0 : Pointer(CommandBuffer), x1 : Rect, left : Color, top : Color, right : Color, bottom : Color)
  fun fill_circle = nk_fill_circle(x0 : Pointer(CommandBuffer), x1 : Rect, x2 : Color)
  fun fill_arc = nk_fill_arc(x0 : Pointer(CommandBuffer), cx : LibC::Float, cy : LibC::Float, radius : LibC::Float, a_min : LibC::Float, a_max : LibC::Float, x6 : Color)
  fun fill_triangle = nk_fill_triangle(buffer : Pointer(CommandBuffer), x0 : LibC::Float, y0 : LibC::Float, x1 : LibC::Float, y1 : LibC::Float, x2 : LibC::Float, y2 : LibC::Float, x7 : Color)
  fun fill_polygon = nk_fill_polygon(x0 : Pointer(CommandBuffer), points : Pointer(LibC::Float), point_count : LibC::Int, x3 : Color)
  fun draw_image = nk_draw_image(x0 : Pointer(CommandBuffer), x1 : Rect, x2 : Pointer(Image), x3 : Color)
  fun draw_nine_slice = nk_draw_nine_slice(x0 : Pointer(CommandBuffer), x1 : Rect, x2 : Pointer(NineSlice), x3 : Color)
  fun draw_text = nk_draw_text(x0 : Pointer(CommandBuffer), x1 : Rect, text : Pointer(LibC::Char), len : LibC::Int, x4 : Pointer(UserFont), x5 : Color, x6 : Color)
  fun push_scissor = nk_push_scissor(x0 : Pointer(CommandBuffer), x1 : Rect)
  fun push_custom = nk_push_custom(x0 : Pointer(CommandBuffer), x1 : Rect, x2 : CommandCustomCallback, usr : Handle)
  fun input_has_mouse_click = nk_input_has_mouse_click(x0 : Pointer(Input), x1 : Buttons)
  fun input_has_mouse_click_in_rect = nk_input_has_mouse_click_in_rect(x0 : Pointer(Input), x1 : Buttons, x2 : Rect)
  fun input_has_mouse_click_in_button_rect = nk_input_has_mouse_click_in_button_rect(x0 : Pointer(Input), x1 : Buttons, x2 : Rect)
  fun input_has_mouse_click_down_in_rect = nk_input_has_mouse_click_down_in_rect(x0 : Pointer(Input), x1 : Buttons, x2 : Rect, down : Bool)
  fun input_is_mouse_click_in_rect = nk_input_is_mouse_click_in_rect(x0 : Pointer(Input), x1 : Buttons, x2 : Rect)
  fun input_is_mouse_click_down_in_rect = nk_input_is_mouse_click_down_in_rect(i : Pointer(Input), id : Buttons, b : Rect, down : Bool)
  fun input_any_mouse_click_in_rect = nk_input_any_mouse_click_in_rect(x0 : Pointer(Input), x1 : Rect)
  fun input_is_mouse_prev_hovering_rect = nk_input_is_mouse_prev_hovering_rect(x0 : Pointer(Input), x1 : Rect)
  fun input_is_mouse_hovering_rect = nk_input_is_mouse_hovering_rect(x0 : Pointer(Input), x1 : Rect)
  fun input_is_mouse_hovering_still_rect = nk_input_is_mouse_hovering_still_rect(x0 : Pointer(Input), x1 : Rect)
  fun input_is_mouse_hovering_delay_rect = nk_input_is_mouse_hovering_delay_rect(x0 : Pointer(Context), x1 : Rect, x2 : Pointer(LibC::Float), x3 : LibC::Float)
  fun input_is_mouse_hovering_still_delay_rect = nk_input_is_mouse_hovering_still_delay_rect(x0 : Pointer(Context), x1 : Rect, x2 : Pointer(LibC::Float), x3 : LibC::Float)
  fun input_is_mouse_hovering_still_delay_clicked_rect = nk_input_is_mouse_hovering_still_delay_clicked_rect(x0 : Pointer(Context), x1 : Rect, x2 : Pointer(LibC::Float), x3 : LibC::Float, x4 : Pointer(Void))
  fun input_is_mouse_moved = nk_input_is_mouse_moved(x0 : Pointer(Input))
  fun input_mouse_clicked = nk_input_mouse_clicked(x0 : Pointer(Input), x1 : Buttons, x2 : Rect)
  fun input_is_mouse_down = nk_input_is_mouse_down(x0 : Pointer(Input), x1 : Buttons)
  fun input_is_mouse_pressed = nk_input_is_mouse_pressed(x0 : Pointer(Input), x1 : Buttons)
  fun input_is_mouse_released = nk_input_is_mouse_released(x0 : Pointer(Input), x1 : Buttons)
  fun input_is_key_pressed = nk_input_is_key_pressed(x0 : Pointer(Input), x1 : Keys)
  fun input_is_key_released = nk_input_is_key_released(x0 : Pointer(Input), x1 : Keys)
  fun input_is_key_down = nk_input_is_key_down(x0 : Pointer(Input), x1 : Keys)
  fun style_item_color = nk_style_item_color(x0 : Color) : StyleItem
  fun style_item_image = nk_style_item_image(img : Image) : StyleItem
  fun style_item_nine_slice = nk_style_item_nine_slice(slice : NineSlice) : StyleItem
  fun style_item_hide = nk_style_item_hide : StyleItem


  struct FontGlyph
    codepoint : UInt32
    xadvance, x0, y0, x1, y1, w, h, u0, v0, u1, v1 : LibC::Float
  end

  enum FontCoordType
      COORD_UV   #< texture coordinates inside font glyphs are clamped between 0-1 */
      COORD_PIXEL # texture coordinates inside font glyphs are in absolute pixel */
  end

  struct BakedFont
    height, ascent, descent : LibC::Float
    glyph_offset, glyph_count : UInt32
  end

  struct FontConfig
    next : Pointer(FontConfig)
    ttf_blob : Pointer(Void)
    ttf_size : Size
    ttf_data_owned_by_atlas : LibC::UChar
    merge_mode : LibC::UChar
    pixel_snap : LibC::UChar
    oversample_v, oversample_h : LibC::UChar
    padding : StaticArray(LibC::UChar, 3)

    size : LibC::Float
    coord_type : FontCoordType
    spacing : Vec2
    range : Pointer(UInt32)
    font : Pointer(BakedFont)
    fallback_glyph : UInt32
    n : Pointer(FontConfig)
    p : Pointer(FontConfig)
  end
  struct Font
    next : Pointer(Font)
    handle : UserFont
    info : BakedFont
    scale : LibC::Float
    glyphs : Pointer(FontGlyph)
    fallback : Pointer(FontGlyph)
    fallback_codepoint : UInt32
    texture : Handle
    config : Pointer(FontConfig)
  end

  enum FontAtlasFormat
    FONT_ATLAS_ALPHA8
    FONT_ATLAS_RGBA32
  end

  struct FontAtlas
    pixel : Pointer(Void)
    tex_width : LibC::Int
    tex_height : LibC::Int
    permanent : Allocator
    temporary : Allocator
    custom : Recti
    cursors : StaticArray(Pointer(Cursor), 7)

    glyph_count : LibC::Int
    nk_font_glyph : Pointer(FontGlyph)
    nk_font : Pointer(Glyph)
  end

  fun font_atlas_init_default = nk_font_atlas_init_default(Pointer(FontAtlas)) : Void
  # fun font_atlas_init(Pointer(FontAtlas), ) TODO
  fun font_atlas_begin = nk_font_atlas_begin(atlas : Pointer(FontAtlas)) : Void
  fun font_atlas_add_default = nk_font_atlas_add_default(atlas : FontAtlas*, pixel_height : LibC::Float, font_config : FontConfig*) : Font*
  fun font_atlas_add_from_file = nk_font_atlas_add_from_file(atlas : Pointer(FontAtlas), file_path : LibC::Char*, height : LibC::Float, x0: FontConfig*) : Font*
  fun font_atlas_bake = nk_font_atlas_bake(x0: FontAtlas*, width : LibC::Int*, height : LibC::Int*, x1: FontAtlasFormat) : Pointer(Void)
  fun font_atlas_end = nk_font_atlas_end(x0: FontAtlas*, tex: Handle, x1: DrawNullTexture*)

  fun font_config = nk_font_config(pixel_height : LibC::Float) : FontConfig


  # SDL3 Renderer
  fun sdl_init = nk_sdl_init(win: LibSdl3::Window*, renderer : LibSdl3::Renderer*, allocator : Allocator) : Context*
  fun sdl_allocator = nk_sdl_allocator() : Allocator
  fun sdl_font_stash_begin = nk_sdl_font_stash_begin(ctx : Context*) : FontAtlas*
  fun sdl_font_stash_end = nk_sdl_font_stash_end(ctx : Context*)
  fun sdl_render = nk_sdl_render(ctx : Context*, aa : AntiAliasing)

  fun sdl_handle_event = nk_sdl_handle_event(ctx : Context*, event : LibSdl3::Event*);
  fun sdl_update_TextInput = nk_sdl_update_TextInput(ctx : Context*)
end
