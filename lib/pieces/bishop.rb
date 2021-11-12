require_relative "../piece.rb"

class Bishop < Piece
  def initialize(board, position, color = WHITE)
    super(board, position, color)
  end

  def piece_symbol
    "\u265d"
  end

  def moves
    out = []

    long_directional_moves(out, @forward, @left)
    long_directional_moves(out, @forward, @right)
    long_directional_moves(out, @backward, @left)
    long_directional_moves(out, @backward, @right)

    out
  end
end