require_relative "../piece.rb"

class Rook < Piece
  def initialize(board, position, color, moved = false)
    super(board, position, color, moved)
  end

  def piece_symbol
    "\u265c"
  end

  def moves
    out = []

    long_directional_moves(out, @forward, 0)
    long_directional_moves(out, 0, @right)
    long_directional_moves(out, @backward, 0)
    long_directional_moves(out, 0, @left)

    out
  end
end