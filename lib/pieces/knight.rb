require_relative "../piece.rb"

class Knight < Piece
  def initialize(board, position, color = WHITE)
    super(board, position, color)
  end

  def piece_symbol
    "\u265e"
  end
end