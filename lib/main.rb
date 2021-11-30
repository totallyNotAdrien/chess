require_relative "chess.rb"

@board = Board.new
@board.set_up_new_board
@board.display
@knight = @board.grid[7][6]
@king = @board.grid[7][4]

def d
  @board.display
end

def m(start_pos, end_pos)
  moved = @board.move_piece(start_pos, end_pos)
  d
  moved
end

def board_with_moves(moves_str, show_each_step)
  board = Board.new
  board.set_up_new_board
  moves = moves_str.split(" ")
  moves.each do |move_str|
    start_pos, end_pos = move_str.insert(2,":").split(":")
    board.move_piece(start_pos, end_pos)
    board.display if show_each_step
  end
  board
end

#@board = board_with_moves("f2f3 e7e6 g2g4 d8h4", true)
@board = board_with_moves("e2e4 d7d5 e4d5 d8d5 f1e2 d5e4", true)
@wking = @board["e1"]

# m("a2", "a4")
# m("a4", "a5")
# m("a5", "a6")