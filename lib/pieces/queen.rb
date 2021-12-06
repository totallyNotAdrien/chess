require_relative "../piece.rb"

class Queen < Piece
  def initialize(board, position, color, moved = false)
    super(board, position, color, moved)
  end

  def piece_symbol
    "\u265b"
  end

  def moves
    out = []

    #diagonal
    long_directional_moves(out, @forward, @left)
    long_directional_moves(out, @forward, @right)
    long_directional_moves(out, @backward, @left)
    long_directional_moves(out, @backward, @right)

    #horizontal & vertical
    long_directional_moves(out, @forward, 0)
    long_directional_moves(out, 0, @right)
    long_directional_moves(out, @backward, 0)
    long_directional_moves(out, 0, @left)

    out
  end
end