require_relative "chess_helper.rb"

class Piece
  include ChessHelper

  attr_reader :color

  def initialize(position, color = WHITE)
    if in_grid_coords?(position)
      position = grid_to_chess_coordinates(position) 
    elsif !in_chess_coords?(position)
      puts "Invalid position error: Piece: #{self}, Pos: #{position}"
      position = nil
    end
    @position = position
    @prev_position = []
    @color = color
  end

  def moves
    puts "'moves' method not defined for #{self.class}"
    []
  end

  def piece_symbol
    "\u262e"
  end
end