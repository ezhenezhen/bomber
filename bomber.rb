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
      candidates_for_count = []

      (-1..1).each do |i|
        (-1..1).each do |j|
          candidates_for_count << [] spot.coordinates.first 
        end
      end

    end

    field


  var list = [];
  for (var i = -1; i <= 1; i++) {
    for (var j = -1; j <= 1; j++) {
      var pos = [this.position[0] + i, this.position[1] + j];
      if (isPositionValid(pos))
        list.push(pos);
    }
  }





    private

    def have_valid_coordinates?(coordinates)
      coordinates[0] >= 0 && coordinates[0] < @field_size && coordinates[1] >= 0 && coordinates[1] < @field_size
    end
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
    empty_field = '[ ]'
    field_with_bomb = '[*]'
    clicked_bomb = '[X]'
    bombs_quantity = "[#{self.quantity_of_adjacent_bombs}]"

    result = ''

    if self.has_bomb
      result << field_with_bomb
    else
      self.quantity_of_adjacent_bombs > 0 ? result << bombs_quantity : result << empty_field
    end

    result
  end
end


b = Bomber.new 10, 5
