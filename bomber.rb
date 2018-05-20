class Bomber
  STATES = { blank: 1, opened: 2, flagged: 3, question: 4 }

  def initialize(field_size, mines_quantity)
    field = Field.new(field_size, mines_quantity);
  end

  # private

  # def update_spots_opened
  #   # spotsOpened++;
  #   # if (spotsOpened === 9 * 9 - 9)
  #   #   win();
  # end

  # def getRandomInt(min, max)
  #   # return Math.floor(Math.random() * (max - min)) + min;
  # end

  # def getRandomSpot(maxWidth, maxHeight)
  #   # return [getRandomInt(0,maxWidth),getRandomInt(0,maxHeight)];
  # end

  # def isPositionValid?(position)
  #   # return position[0] >= 0 && position[0] < 9 && position[1] >= 0 && position[1] < 9;
  # end
  
  # def win
  # end

  # def lose
  # end
end

class Field
  def initialize(field_size)
    Field.generateField(field_size, mines_quantity)
    Field.updateNeighboursAdjacentBombs();
    Field.render();
  end

  def generateField(field_size)
    field = []

    field_size()
  end

  # def self.updateNeighboursAdjacentBombs
  # end

  # def self.render
  # end

  # private

end

class Spot
  def initialize()
  end

  def self.reveal
  end

  def self.put_flag
  end

  private

end
