$(document).ready(function () {
  disable right click on page
  $(this).bind("contextmenu", function (e) {
    e.preventDefault();
  });
  field = new Field();
  field.generateField();
  field.generateBombs();
  field.updateNeighboursAdjacentBombs();
  field.render();

  $('.spot').mousedown(function (event) {
    var x = $(this)[0].classList[1].charAt(0);
    var y = $(this)[0].classList[1].charAt(2);
    var spot = field.grid[x][y];
    
    switch (event.which) {
      case 1:
        clicked(1, spot); break;
      case 3:
        clicked(2, spot); break;
      default: 
        break;
    }
  });
});

var STATES = { blank: 1, opened: 2, flagged: 3, question: 4 };
var IMAGES = { blank: 'images/blank_spot.gif', flagged: 'images/flagged.gif', question: 'images/question.gif',
  mine_death: 'images/mine_death.gif', mine_wrong: 'images/mine_wrong.gif', mine_opened: 'images/mine_opened.gif',
  facedead: 'images/face/face_dead.gif', face_smile: 'images/face/face_smile.gif', face_win: 'images/face/face_win.gif', 
  number_zero: 'images/number_zero.gif', number_one: 'images/number_one.gif', number_two: 'images/number_two.gif',
  number_three: 'images/number_three.gif', number_four: 'images/number_four.gif', number_five: 'images/number_five.gif',
  number_six: 'images/number_six.gif', number_seven: 'images/number_seven.gif', number_eight: 'images/number_eight.gif',
  number_nine: 'images/number_nine.gif', open_zero: 'images/open_zero.gif', open_one: 'images/open_one.gif',
  open_two: 'images/open_two.gif', open_three: 'images/open_three.gif', open_four: 'images/open_four.gif',
  open_five: 'images/open_five.gif', open_six: 'images/open_six.gif', open_seven: 'images/open_seven.gif',
  open_eight: 'images/open_eight.gif', 'number-': 'images/number/number-.gif'
};
var field;
var gameOver = false;
var spotsOpened = 0;

function Field () {
  this.grid = [[Spot]];
  this.rows = 9; 
  this.columns = 9; 
  this.minesPositions = [];
}

Field.prototype.generateField = function () {
  for (var i = 0 ; i < this.rows; i++) {
    this.grid.push([]);
    for (var j = 0 ; j < this.columns; j++) {
      var spot = new Spot([i,j]);
      spot.addSpotToMarkup();
      this.grid[i][j] = spot;
    }
  }
  $('.grid').width(this.rows * 16);
  $('.grid').height(this.columns * 16);
}

Field.prototype.generateBombs = function () {
  for (var i = 0; i < 9; i++){
    var mine = getRandomSpot(9, 9);
    if (this.grid[mine[0]][mine[1]].isBomb)
      i -= 1;
    else {
      this.grid[mine[0]][mine[1]].isBomb = true;
      this.minesPositions.push(mine);
    }
  }
}

Field.prototype.updateNeighboursAdjacentBombs = function () {
  var grid = this.grid;
  $.each(this.minesPositions, function (index,position) {
    var neighbourPositions = grid[position[0]][position[1]].listNeighbourPositions();

    $.each(neighbourPositions, function (index,neighbour) {
      grid[neighbour[0]][neighbour[1]].adjacentBombs += 1;
    });
  });
}

Field.prototype.render = function () {
  for (var i = 0 ; i < this.rows; i++){
    for (var j = 0 ; j< this.columns; j++) {
      $('.' + i + '-' + j).attr('src', IMAGES.blank_spot);
    }
  }
}

Field.prototype.revealBombs = function () {
  for (var i = 0 ; i < this.rows; i++) {
    for (var j = 0 ; j < this.columns; j++){
      if (this.grid[i][j].isBomb && this.grid[i][j].state == 1) {
        this.grid[i][j].updateSpot(IMAGES.mine_opened);
      }
    }
  }
}

function Spot (position) {
  this.position = position;
  this.state = STATES.blank;
  this.isBomb = false;
  this.adjacentBombs = 0;
}

Spot.prototype.addSpotToMarkup = function () {
  var $div = $('<img src=' + IMAGES.blank + '>')
  $div.addClass('spot');
  $div.addClass(this.position[0] + '-' + this.position[1]);

  $('.grid').append($div);
}
 
Spot.prototype.listNeighbourPositions = function () {
  var list = [];
  for (var i = -1; i <= 1; i++) {
    for (var j = -1; j <= 1; j++) {
      var pos = [this.position[0] + i, this.position[1] + j];
      if (isPositionValid(pos))
        list.push(pos);
    }
  }

  return list;
}

Spot.prototype.reveal = function () {
  this.state = 2;
  if (this.isBomb) {
    this.updateSpot(IMAGES.mine_death);
    lose();
  }
  else {
    switch (this.adjacentBombs) {
      case 0:
        this.updateSpot(IMAGES.open_zero);
        revealNeighbours(this);
        break;
      case 1:
        this.updateSpot(IMAGES.open_one);
        break;
      case 2:
        this.updateSpot(IMAGES.open_two);
        break;
      case 3:
        this.updateSpot(IMAGES.open_three);
        break;
      case 4:
        this.updateSpot(IMAGES.open_four);
        break;
      case 5:
        this.updateSpot(IMAGES.open_five);
        break;
      case 6:
        this.updateSpot(IMAGES.open_six);
        break;
      case 7:
        this.updateSpot(IMAGES.open_seven);
        break;
      case 8:
        this.updateSpot(IMAGES.open_eight);
        break;
    }
  }

  this.updateSpotsOpened();
}

Spot.prototype.putFlag = function () {
  if (this.state == 3) {
    this.state = 1;
    this.updateSpot(IMAGES.blank);
  }
  else if (this.state == 1) {
    this.state = 3;
    this.updateSpot(IMAGES.flagged);
  }
}

Spot.prototype.updateSpot = function (img) {
  $('.' + this.position[0] + '-' + this.position[1]).attr('src', img);
}

Spot.prototype.updateSpotsOpened = function () {
  spotsOpened++;
  if (spotsOpened === 9 * 9 - 9)
    win();
}

revealNeighbours = function (spot) {
  var spotsToCheck = []; 
  spotsToCheck.push(spot)

  while (spotsToCheck.length > 0) {
    var neighbourPositions = spotsToCheck[0].listNeighbourPositions();
    $.each(neighbourPositions, function(index,neighbour) {
      var c = field.grid[neighbour[0]][neighbour[1]];
      if (!c.isBomb && c.state != 2 && c.state != 3) {
        c.reveal();
        if (c.adjacentBombs == 0)
          spotsToCheck.push(c)
      }
    });

    spotsToCheck.shift();
  }
}

function clicked (type, spot) {
  if (gameOver)
    return;
  switch (type) {
    case 1:
      spot.reveal();
      break;
    case 2:
      spot.putFlag();
      break;
  }
}

function win () {

}

function lose () {
  field.revealBombs();
  gameOver = true;
}

function getRandomInt (min, max) {
  return Math.floor(Math.random() * (max - min)) + min;
}

function getRandomSpot (maxWidth, maxHeight) {
  return [getRandomInt(0,maxWidth),getRandomInt(0,maxHeight)];
}

function isPositionValid (position) {
  return position[0] >= 0 && position[0] < 9 && position[1] >= 0 && position[1] < 9;
}
