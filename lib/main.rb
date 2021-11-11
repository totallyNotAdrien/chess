require_relative "chess.rb"

@board = Board.new
@board.set_up_new_board
@board.display
@knight = @board.grid[7][6]

def d
  @board.display
end

def m(start_pos, end_pos)
  moved = @board.move_piece(start_pos, end_pos)
  d
  moved
end

# m("a2", "a4")
# m("a4", "a5")
# m("a5", "a6")