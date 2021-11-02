require_relative "../piece.rb"

class Bishop < Piece
  def initialize(position, color = WHITE)
    super(position, color)
  end

  def piece_symbol
    "\u265d"
  end
end