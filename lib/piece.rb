require_relative "chess_helper.rb"

class Piece
  include ChessHelper

  attr_reader :color

  def initialize(board, position, color = WHITE)
    if in_grid_coords?(position)
      position = grid_to_chess_coordinates(position) 
    elsif !in_chess_coords?(position)
      puts "Invalid position error: Piece: #{self}, Pos: #{position}"
      position = nil
    end
    @board = board
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

  def valid_move?(pos)
    puts "Yo! I got called!"
    false  #temporary
  end

  def set_pos(pos)
    @prev_position = @position
    @position = grid_to_chess_coordinates(pos) || pos
  end

  def self.subs
    ObjectSpace.each_object(Class).select{|sub| sub < self}
  end
end