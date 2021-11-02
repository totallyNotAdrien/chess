require_relative "../piece.rb"

class Bishop < Piece
  def initialize(position, color = WHITE)
    super(position, color)
  end
end