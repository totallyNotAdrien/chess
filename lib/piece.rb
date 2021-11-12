require_relative "chess_helper.rb"

class Piece
  include ChessHelper

  attr_reader :color, :position

  def initialize(board, position, color = WHITE)
    if in_grid_coords?(position)
      position = grid_to_chess_coordinates(position) 
    elsif !in_chess_coords?(position)
      puts "Invalid position error: Piece: #{self}, Pos: #{position}"
      position = nil
    end
    @board = board
    @position = position
    @prev_position = nil
    @color = color
    @forward = color == WHITE ? -1 : 1
    @backward = -@forward
    @left = @forward
    @right = -@left
    @moved = false
  end

  def moves
    puts "'moves' method not defined for #{self.class}"
    []
  end

  def piece_symbol
    "\u262e"
  end

  def valid_move?(pos)
    implemented = [Pawn, Bishop, Knight]
    
    unless implemented.include?(self.class)
      return true #temporary
    end

    pos = grid_to_chess_coordinates(pos) || pos
    moves.include?(pos)
  end

  def set_pos(pos)
    @prev_position = @position
    @position = grid_to_chess_coordinates(pos) || pos
    @moved = true
  end

  def self.subs
    ObjectSpace.each_object(Class).select{|sub| sub < self}
  end

  protected

  def add_to_arr_if_valid_grid_pos(arr, row_index, col_index)
    new_chess_pos = grid_to_chess_coordinates([row_index, col_index])
    out.push(new_chess_pos) if new_chess_pos
  end

  def long_directional_moves(move_arr, row_dir, col_dir)
    pos = chess_to_grid_coordinates(@position) || @position
    row_dir /= row_dir.abs
    col_dir /= col_dir.abs

    row_index, col_index = pos
    dist = 1
    loop do
      new_row_index = row_index + (row_dir * dist)
      new_col_index = col_index + (col_dir * dist)

      break unless new_pos = grid_to_chess_coordinates([new_row_index, new_col_index])
      piece_at_new_pos = @board.grid[new_row_index][new_col_index]
      
      return if piece_at_new_pos.is_a?(GhostPawn)

      if piece_at_new_pos
        if piece_at_new_pos.color == @color
          return
        else
          move_arr.push(new_pos)
          return
        end
      end
      
      move_arr.push(new_pos) 
      dist += 1
    end
  end
end