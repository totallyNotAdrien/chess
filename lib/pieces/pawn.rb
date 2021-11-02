require_relative "../piece.rb"

class Pawn < Piece
  def initialize(position, color = WHITE)
    super(position, color)
  end

  def piece_symbol
    "\u265f"
  end
end