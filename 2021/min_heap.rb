# frozen_string_literal: true

# Minimal binary min-heap of [priority, value] pairs.
class MinHeap
  def initialize
    @items = []
  end

  def empty?
    @items.empty?
  end

  def push(item)
    @items << item
    i = @items.size - 1
    while i.positive?
      parent = (i - 1) / 2
      break if (@items[parent] <=> @items[i]) <= 0

      @items[parent], @items[i] = @items[i], @items[parent]
      i = parent
    end
  end

  def pop
    top = @items.first
    last = @items.pop
    return top if @items.empty?

    @items[0] = last
    i = 0
    loop do
      smallest = i
      [(2 * i) + 1, (2 * i) + 2].each do |child|
        smallest = child if child < @items.size && (@items[child] <=> @items[smallest]).negative?
      end
      break if smallest == i

      @items[smallest], @items[i] = @items[i], @items[smallest]
      i = smallest
    end
    top
  end
end
