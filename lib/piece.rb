require_relative "chess_helper.rb"

class Piece
  include ChessHelper

  def initialize(position, color = WHITE)
    @position = position
    @prev_position = []
    @color = color
  end

  def moves
    puts "'moves' method not defined for #{self.class}"
    []
  end
end