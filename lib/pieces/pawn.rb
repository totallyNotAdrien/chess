require_relative "../piece.rb"

class Pawn < Piece
  def initialize(position, color = WHITE)
    super(position, color)
  end
end