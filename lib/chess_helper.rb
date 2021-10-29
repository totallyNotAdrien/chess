module ChessHelper
  WHITE = 0
  BLACK = 1
end

class String
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
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