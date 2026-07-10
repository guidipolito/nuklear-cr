class Nuklear::Text
  getter capacity : Int32
  getter size : Int32

  @buffer : Bytes
  @size : Int32

  def initialize(capacity : Int = 256)
    @capacity = capacity
    @buffer = Bytes.new(@capacity, 0)
    @size = 0
  end

  def initialize(text : String, capacity : Int)
    @capacity = Math.max(capacity.to_i, text.bytesize + 1)
    @buffer = Bytes.new(@capacity, 0)
    @size = 0
    self.text = text
  end

  def text : String
    String.new(@buffer.to_unsafe, @size)
  end

  def text=(value : String)
    raise ArgumentError.new("text exceeds capacity") if value.bytesize >= @capacity

    value.to_slice.copy_to(@buffer)
    @size = value.bytesize
    @buffer[@size] = 0
  end

  def clear
    @size = 0
    @buffer[0] = 0
  end

  def to_s(io : IO)
    io << text
  end

  # Ponteiro para o início do buffer
  def to_unsafe : Pointer(UInt8)
    @buffer.to_unsafe
  end

  # Ponteiro para o tamanho (nk_edit_string precisa disso)
  def size_pointer : Pointer(Int32)
    pointerof(@size)
  end
end
