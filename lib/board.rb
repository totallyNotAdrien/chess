class Board
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
        grid_space = color_space(" #{piece} ".black, bg_color)
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
      col_num_output += "#{letter}" + (" " * 4)
    end
    puts col_num_output
  end

  def color_space(contents, color_index)
    return contents.on_brown if color_index == 0
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

class String
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def black
    colorize(30)
  end

  def red
    colorize(31)
  end

  def yellow
    colorize(33)
  end

  def on_red
    colorize(41)
  end

  def on_brown
    colorize(43)
  end

  def on_blue
    colorize(44)
  end

  def on_cyan
    colorize(46)
  end

  def on_peach
    colorize(101)
  end

  def on_yellow
    colorize(103)
  end
end