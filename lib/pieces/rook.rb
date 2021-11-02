require_relative "../piece.rb"

class Rook < Piece
  def initialize(position, color = WHITE)
    super(position, color)
  end
end