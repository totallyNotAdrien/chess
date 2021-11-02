require_relative "../piece.rb"

class Bishop < Piece
  def initialize(board, position, color = WHITE)
    super(board, position, color)
  end

  def piece_symbol
    "\u265d"
  end
end