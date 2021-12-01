module ChessHelper
  WHITE = 0
  BLACK = 1

  def grid_to_chess_coordinates(position)
    return nil unless position.is_a?(Array)

    if position.length == 2 && position.all?{|coord| coord.between?(0,7)}
      row_index = position[0]
      row = "#{8 - row_index}"

      letters = ("a".."h").to_a
      col_index = position[1]
      col = letters[col_index]
      return col + row
    end
  end

  def chess_to_grid_coordinates(position)
    return nil unless position.is_a?(String)

    position = position.downcase
    position.remove_spaces!
    if position.length == 2 && /[a-h][1-8]/.match(position)
      col = position[0].ord - "a".ord
      row = 8 - position[1].to_i
      return [row,col]
    end
  end

  def in_grid_coords?(pos)
    return pos.is_a?(Array) && pos.length == 2 &&
      pos.all? { |coord| coord.is_a?(Integer) && coord.between?(0,7)}
  end

  def in_chess_coords?(pos)
    return false unless pos.is_a?(String)

    pos.downcase.remove_spaces!
    matches_pattern = /[a-h][1-8]/.match(pos) != nil
    return pos.length == 2 && matches_pattern
  end

  def valid_move_format?(move)
    return false unless move.is_a?(String) && move.length == 4

    start_pos, end_pos = move.insert(2, ":").split(":")
    in_chess_coords?(start_pos) && in_chess_coords?(end_pos)
  end
end

class String
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def remove_spaces
    self.gsub(" ", "")
  end

  def remove_spaces!
    self.gsub!(" ", "")
  end

  def black
    colorize(30)
  end

  def white
    colorize(97)
  end

  def red
    colorize(31)
  end

  def yellow
    colorize(33)
  end

  def gray
    colorize(90)
  end

  def peach
    colorize(91)
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