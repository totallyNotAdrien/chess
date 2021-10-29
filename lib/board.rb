require_relative "chess_helper.rb"

class Board
  include ChessHelper

  def initialize(moves = [])
    #grid 8x8 array
    @rows = 8
    @cols = 8
    @grid = Array.new(@rows){Array.new(@cols)}
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
      piece = "\u265e"

      for col_index in 0...@cols
        #sym = colored_piece(@grid[row_index][col_index])
        space_str = " #{piece} "
        space_str = col_index % 2 == 0 ? space_str.black : space_str.white
        grid_space = color_space(space_str, bg_color)
        last_col = col_index == @cols - 1
        row_out += " #{grid_space}#{last_col ? " " : ""}"
        bg_color = (bg_color + 1) % 2
      end
      output += "#{row_out}\n"
      #output += (" " * 3) + "#{grid_row_separator}\n" unless row_index == @rows - 1
    end

    puts output

    #column indicators
    col_num_output = " " * 5
    for letter in "a".."h"
      col_num_output += "#{letter}" + (" " * 3)
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

