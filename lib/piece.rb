require_relative "chess_helper.rb"

class Piece
  include ChessHelper

  def initialize(color = WHITE)
    @position = 0
    @prev_position = 0
    @coloe = color
  end
end