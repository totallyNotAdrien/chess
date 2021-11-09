require_relative "../piece.rb"

class GhostPawn < Piece
  attr_reader :parent_piece
  
  def initialize(board, position, parent, color = WHITE)
    super(board, position, color)
    @parent_piece = parent
  end

  def piece_symbol
    "\u265f"
  end
end