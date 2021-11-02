require_relative "../piece.rb"

class Pawn < Piece
  def initialize(board, position, color = WHITE)
    super(board, position, color)
  end

  def piece_symbol
    "\u265f"
  end
end