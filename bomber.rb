class Bomber
  attr_accessor :field, :won, :lost

  def initialize(field_size, bombs_quantity)
    @field_size = field_size
    @bombs_quantity = bombs_quantity
    @won = false
    @lost = false
  end

  def play
    @field = Field.new(@field_size, @bombs_quantity)
    @field.draw_field

    until @won || @lost
      puts 'enter coordinates separated by comma'
      coordinates = gets.chomp.split(',').map { |i| i.to_i - 1 }
      self.open_spot_and_adjacent_empty_fields(coordinates)

      @field.draw_field
    end

    puts "The end."
  end

  # todo...
  def open_spot_and_adjacent_empty_fields(coordinates)
    field.spots.each do |spot|
      if spot.coordinates == coordinates
        spot.status = 'opened' 
      end
    end
  end
end

class Field
  attr_reader :spots

  def initialize(field_size, bombs_quantity)
    @field_size = field_size
    @bombs_quantity = bombs_quantity
    @spots = self.generate_field
  end

  def generate_field
    field = []

    @field_size.times do |i|
      0.upto(@field_size - 1) do |j|
        field << Spot.new([i, j])
      end
    end

    # generate bombs
    have_bombs = []

    while have_bombs.length < @bombs_quantity
      r = rand(@field_size * @field_size - 1)
      have_bombs << r unless have_bombs.include?(r)
    end

    have_bombs.each do |bomb|
      field[bomb].has_bomb = true
    end

    # count quantity of adjacent bombs
    field.each do |spot|
      objects_for_count = []

      (-1..1).each do |i|
        (-1..1).each do |j|
          field.each do |cell|
            if (spot.coordinates == [cell.coordinates.first + i, cell.coordinates.last + j])
              objects_for_count << cell if cell.has_bomb
            end
          end
        end
      end

      spot.quantity_of_adjacent_bombs = objects_for_count.length
    end

    field
  end

  def draw_field
    result = ''
    
    @spots.each do |s|
      result << s.translate_spot
      result << "\n" if (s.coordinates.last == @field_size - 1)
    end

    puts result
  end
end

class Spot
  attr_accessor :status, :has_bomb, :coordinates, :quantity_of_adjacent_bombs

  def initialize(coordinates)
    @coordinates = coordinates
    @status = 'closed'
    @has_bomb = false
    @quantity_of_adjacent_bombs = 0
  end

  def translate_spot
    closed_field    = '[O]'
    empty_field     = '[ ]'
    field_with_bomb = '[*]'
    clicked_bomb    = '[X]'
    marked_as_bomb  = '[!]'
    bombs_quantity  = "[#{self.quantity_of_adjacent_bombs}]"

    result = ''

    if self.status == 'closed'
      result << closed_field
    end

    if self.status == 'opened'
      if self.has_bomb
        result << field_with_bomb
      else
        self.quantity_of_adjacent_bombs > 0 ? result << bombs_quantity : result << empty_field
      end
    end

    result
  end
end

b = Bomber.new(10, 5).play
