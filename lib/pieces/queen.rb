require_relative "../piece.rb"

class Queen < Piece
  def initialize(board, position, color = WHITE)
    super(board, position, color)
  end

  def piece_symbol
    "\u265b"
  end
end