require_relative "../piece.rb"

class Knight < Piece
  def initialize(position, color = WHITE)
    super(position, color)
  end
end