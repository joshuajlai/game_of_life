# /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ..... G A M E O F L I F E
# .#... http://en.wikipedia.org/wiki/Conway%27s_Game_of_Life
# ..##.
# .##.. Write a simple implementation of Conway's Game of Life.
# .....

# ..#.. T H E R U L E S
# .##..
# ..#.. A cell has two possible states, _alive_ or _dead_. Its
# ..#.. next state is determined by comparing its current state
# .###. to the number of living cells in its _neighborhood_
#       using the e rules:

# 1. If a living cell has 2 or 3 living neighbors, it lives
# 2. If a dead cell has exactly 3 living neighbors, it is reborn
# 3. In all other cases, the cell dies (or remains dead).

# ..#.. T H E G A M E
# .#.#.
# ...#. The game board is a 2d orthaganol grid of square cells.
# ..#.. The game proceeds in a series of successive turns. On
# .###. each turn, the _rules_ are applied to each cell on the
#       board _simultaneously_

# 1. A cell's neighborhood consists of the eight cells orthagonally and diagonally adjacent.
# 2. Any cell falling outside of the bounds of the board can be considered dead.

# .###. T H E P R O G R A M
# ...#.
# ..#.. Our program should take a string representing the initial
# ...#. stato of the board and a number of turns to run the game.
# .##.. It should output a string representing the board state after each turn

# 1. The program should accept a board of any size.
# 2. It should accept square or rectangular boards.
# 3. You can assume that any input will be well-formed and you don't need to worry about crazy edge cases like 1x1 boards or infinite boards or non-euclidean boards or boards made of cheese. The test cases below are the ones we're going to use

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

glider = [".#......",
          "..#.....",
          "###.....",
          "........",
          "........",
          "........",
          "........",
          "........"]

boat = [".....",
        ".##..",
        ".#.#.",
        "..#..",
        "....."]

toad = ["......",
        "..###.",
        ".###..",
        "......"]

pulsar = ["...............",
          "...###...###...",
          "...............",
          ".#....#.#....#.",
          ".#....#.#....#.",
          ".#....#.#....#.",
          "...###...###...",
          "...............",
          "...###...###...",
          ".#....#.#....#.",
          ".#....#.#....#.",
          ".#....#.#....#.",
          "...............",
          "...###...###...",
          "..............."]

class Cell
  attr_reader :number_of_live_neighbors, :state

  def initialize(state:)
    @state = state
  end

  def update_number_of_live_neighbors(number_of_live_neighbors:)
    @number_of_live_neighbors = number_of_live_neighbors
  end

  def compute
    if state == :alive && [2, 3].include?(number_of_live_neighbors)
      @state = :alive
    elsif state == :dead && number_of_live_neighbors == 3
      @state = :alive
    else
      @state = :dead
    end
  end

  def to_string
    if state == :alive
      '#'
    elsif state == :dead
      '.'
    end
  end
end

def build_cell_board(board)
  board.map do |line|
    line.split('').map do |string_cell|
      state = begin
        if string_cell == '.'
          :dead
        elsif string_cell == '#'
          :alive
        end
      end
      Cell.new(state: state)
    end
  end
end

def cell_board_to_string(cell_board)
  cell_board.map do |row|
    row_string_array = row.map do |cell|
      cell.to_string
    end
    row_string_array.join
  end
end

def update_cell_alive_counters(cell_board)
  # when looking at cell:
  #   need to go back 1 row for top 3 cells,
  #   need to look at position before and after for neighbors on same row
  #   need to look at next row for bottom 3 cells
  cell_board.each_with_index do |row, index|
    row.each_with_index do |cell, row_index|
      alive_counter = 0
      for i in [-1, 1]
        next if (index + i < 0) || cell_board[index + i].nil?

        alt_row = cell_board[index + i]
        for j in [-1, 0, 1] do
          next if (row_index + j < 0) || alt_row[row_index + j].nil?

          state = alt_row[row_index + j].state
          alive_counter += 1 if state == :alive
        end
      end
      for k in [-1, 1]
        next if (row_index + k < 0) || row[row_index + k].nil?

        state = row[row_index + k].state
        alive_counter += 1 if state == :alive
      end
      cell.update_number_of_live_neighbors(number_of_live_neighbors: alive_counter)
    end
  end
end

def update_cell_states(cell_board)
  cell_board.each do |row|
    row.each do |cell|
      cell.compute
    end
  end
end

def game_of_life_with_objects(board, turns)
  # turns is number of interations to compute
  # board is array of strings (positional arrays)

  # 1. take board input and convert into array of arrays of cells
  # 2. cells keep track of neighboring states without computing new self state
  # 3. run through all cells to compute new state
  cell_board = build_cell_board(board)
  cell_board_to_string(cell_board).each {|row| print "#{row}\n" }
  for i in 1..turns
    print "\n"
    update_cell_alive_counters(cell_board)
    update_cell_states(cell_board)
    cell_board_to_string(cell_board).each {|row| print "#{row}\n" }
  end
  print "\n"
end


# Simplified version below
ALIVE = '#'
DEAD = '.'
def alive_or_dead?(state, number_of_live_neighbors)
  if state == ALIVE && [2, 3].include?(number_of_live_neighbors)
    ALIVE
  elsif state == DEAD && number_of_live_neighbors == 3
    ALIVE
  else
    DEAD
  end
end

def process_board(board)
  board.each_with_index.map do |row, index|
    row.split('').each_with_index.map do |cell, row_index|
      alive_counter = 0
      for i in [-1, 1]
        next if (index + i < 0) || board[index + i].nil?
        alt_row = board[index + i]
        for j in [-1, 0, 1] do
          next if(row_index + j < 0) || alt_row[row_index + j].nil?
          state = alt_row[row_index + j]
          alive_counter += 1 if state == ALIVE
        end
      end
      for k in [-1, 1]
        next if (row_index + k < 0) || row[row_index + k].nil?
        state = row[row_index + k]
        alive_counter += 1 if state == ALIVE
      end
      alive_or_dead?(cell, alive_counter)
    end.join
  end
end

def game_of_life(board, turns)
  # using objects, we found out that the you need to keep track of before and after states of the board
  # for determining live/dead status. An easier way is to create the next iteration's board as we
  # traverse the given board and feed it into the next loop. This gives us 'state' but uses twice as
  # much memory. But, since we're using an array of strings, it's still less memory than a ton of objects.
  board.each {|row| print "#{row}\n" }
  for i in 1..turns
    print "\n"
    board = process_board(board)
    board.each {|row| print "#{row}\n" }
  end
  print "\n"
end

print "glider\n"
game_of_life(glider, 15)
game_of_life_with_objects(glider, 15)

print "boat\n"
game_of_life(boat, 15)
game_of_life_with_objects(boat, 15)

print "toad\n"
game_of_life(toad, 15)
game_of_life_with_objects(toad, 15)

print "pulsar\n"
game_of_life(pulsar, 15)
game_of_life_with_objects(pulsar, 15)
