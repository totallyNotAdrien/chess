require_relative "../piece.rb"

class Queen < Piece
  def initialize(position, color = WHITE)
    super(position, color)
  end
end