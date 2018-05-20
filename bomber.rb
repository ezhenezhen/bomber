class Bomber
  attr_accessor :field

  def initialize(field_size, bombs_quantity)
    @field = Field.new(field_size, bombs_quantity)
    @field.draw_field
  end
end

class Field
  attr_reader :spots

  def initialize(field_size, bombs_quantity)
    @field_size = field_size
    @bombs_quantity = bombs_quantity
    @spots = self.generateField
  end

  def generateField
    field = []

    @field_size.times do |i|
      0.upto(@field_size - 1) do |j|
        field << Spot.new([i, j])
      end
    end

    have_bombs = []

    while have_bombs.length < @bombs_quantity
      r = rand(@field_size * @field_size - 1)
      have_bombs << r unless have_bombs.include?(r)
    end

    have_bombs.each do |bomb|
      field[bomb].has_bomb = true
    end

    field
  end

  def draw_field
    result = ''
    
    @spots.each do |s|
      (s.coordinates.last == @field_size - 1) ? (result << "[ ]\n") : (result << "[ ]")
    end

    puts result
  end
end

class Spot
  attr_accessor :status, :has_bomb, :coordinates

  def initialize(coordinates)
    @coordinates = coordinates
    @status = 'closed'
    @has_bomb = false
  end
end


b = Bomber.new 10, 5
