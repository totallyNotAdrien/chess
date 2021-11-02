require_relative "../piece.rb"

class Rook < Piece
  def initialize(board, position, color = WHITE)
    super(board, position, color)
  end

  def piece_symbol
    "\u265c"
  end
end