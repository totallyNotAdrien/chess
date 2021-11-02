require_relative "../piece.rb"

class King < Piece
  def initialize(position, color = WHITE)
    super(position, color)
  end

  def piece_symbol
    "\u265a"
  end
end