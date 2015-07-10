def update_quality(items)
  items.each do |item|
    current_item = ItemFactory.klass_for(item)
    current_item.adjust_quality
    current_item.adjust_sell_in
  end
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]


class NormalItem

  def initialize(item)
    @item = item
  end

  def decrement_quality
    if @item.quality > 0
      @item.quality -= 1
    end
  end
  def increment_quality
    if @item.quality < 50
      @item.quality += 1
    end
  end
  def adjust_sell_in
    @item.sell_in -= 1
  end
  def adjust_quality()
    decrement_quality
    if @item.sell_in <= 0
      decrement_quality
    end
  end
end


class Legendary < NormalItem
  def adjust_quality
  end
  def adjust_sell_in
  end
end

class Brie < NormalItem
  def adjust_quality()
    increment_quality
    if @item.sell_in <= 0
      increment_quality
    end
  end
end

class Backstage < NormalItem
  def adjust_quality
    increment_quality
    if @item.sell_in < 11
      increment_quality
    end
    if @item.sell_in < 6
      increment_quality
    end
    if @item.sell_in <= 0
      @item.quality = 0
    end
  end
end

class Conjured < NormalItem
  def adjust_quality()
    decrement_quality
    decrement_quality
    if @item.sell_in <= 0
      decrement_quality
      decrement_quality
    end
  end

end

class ItemFactory

  CLASSMAP = { "Aged Brie" => Brie,
               "Sulfuras, Hand of Ragnaros" => Legendary,
               "Backstage passes to a TAFKAL80ETC concert" => Backstage,
               "Conjured Mana Cake" => Conjured
  }
  def self.klass_for(item)
    ( CLASSMAP[item.name] || NormalItem ).new(item)
  end
end


