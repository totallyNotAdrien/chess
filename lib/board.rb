require_relative "chess_helper.rb"
Dir["./lib/pieces/*.rb"].each {|file| require file}

class Board
  include ChessHelper

  attr_reader :grid

  def initialize(moves = [])
    #grid 8x8 array
    @rows = 8
    @cols = 8
    @grid = Array.new(@rows){Array.new(@cols)}
  end

  def setup_new_board
    first_rank_classes = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

    #black's first rank
    row_index = 0
    col_index = 0
    for piece in first_rank_classes
      @grid[row_index][col_index] = piece.new([row_index, col_index], BLACK)
      col_index += 1
    end

    #black's pawns
    row_index = 1
    for col_index in 0...@cols
      @grid[row_index][col_index] = Pawn.new([row_index,col_index], BLACK)
    end

    #white's first rank
    row_index = @rows - 1
    col_index = 0
    for piece in first_rank_classes
      @grid[row_index][col_index] = piece.new([row_index, col_index], WHITE)
      col_index += 1
    end

    #white's pawns
    row_index = @rows - 2
    for col_index in 0...@cols
      @grid[row_index][col_index] = Pawn.new([row_index,col_index], WHITE)
    end
  end

  def move_piece(start_pos, end_pos)
    #check for piece at start_pos
      #check that end_pos is valid for piece
        #move piece
        #side effects
          #pawn that moved 2 spaces is made en passantable to now-adjacent pawns
  end

  def display
    puts

    output = ""
    #build output row by row
    for row_index in 0...@rows
      row_number = @rows-row_index
      row_out = " #{row_number}" + (" " * 1)

      bg_color = row_index % 2

      for col_index in 0...@cols
        piece = @grid[row_index][col_index]
        piece_symbol = piece ? piece.piece_symbol : " "
        space_str = " #{piece_symbol} "

        if piece
          space_str = piece.color == BLACK ? space_str.black : space_str.white
        end
        grid_space = color_space(space_str, bg_color)
        last_col = col_index == @cols - 1
        row_out += "#{grid_space}#{last_col ? " " : ""}"
        bg_color = (bg_color + 1) % 2
      end
      output += "#{row_out}\n"
      #output += (" " * 3) + "#{grid_row_separator}\n" unless row_index == @rows - 1
    end

    puts output

    #column indicators
    col_num_output = " " * 4
    for letter in "a".."h"
      col_num_output += "#{letter}" + (" " * 2)
    end
    puts col_num_output
  end

  def color_space(contents, color_index)
    return contents.on_cyan if color_index == 0
    contents.on_blue
  end

  def colored_piece(thing)
    "m"
  end

  def em
    "\u2014"
  end

  def grid_row_separator
    thing = "+ #{em * 2} "
    " #{em * 2} #{thing * (@cols - 1)}"
  end
end

