require_relative "../piece.rb"

class King < Piece
  def initialize(board, position, color = WHITE)
    super(board, position, color)
  end

  def piece_symbol
    "\u265a"
  end
end