require_relative "../piece.rb"

class King < Piece
  def initialize(board, position, color = WHITE)
    super(board, position, color)
  end

  def piece_symbol
    "\u265a"
  end

  def moves
    directions = [
      [@forward, 0],
      [@forward, @right],
      [0, @right],
      [@backward, @right],
      [@backward, 0],
      [@backward, @left],
      [0, @left],
      [@forward, @left]
    ]

    row_index, col_index = chess_to_grid_coordinates(@position) || @position

    out = []
    directions.each do |row_dir, col_dir|
      out.push([row_index + row_dir, col_index + col_dir])
    end

    out.reject! do |row_index, col_index|
      piece_at_pos = @board.grid[row_index][col_index]
      piece_at_pos && (piece_at_pos.color == color || piece_at_pos.is_a?(GhostPawn))
    end


    #castling stuff
    #goes here
    row_index, col_index = chess_to_grid_coordinates(@position) || @position

    kingside_rook = @board.grid[row_index][7]
    kingside_others = @board.grid[row_index][(col_index + 1)..(col_index+2)]

    queenside_rook = @board.grid[row_index][0]
    queenside_others = @board.grid[row_index][(col_index - 1)..(col_index-3)]

    if !moved && kingside_others.all?{|piece| piece == nil} && 
      kingside_rook && !kingside_rook.moved
      out.push([row_index, col_index + 2])
    end

    if !moved && queenside_others.all?{|piece| piece == nil} && 
      queenside_rook && !queenside_rook.moved
      out.push([row_index, col_index - 2])
    end

    out.map!{|coords| grid_to_chess_coordinates(coords)}
    out
  end

  #custom set_pos to do castling side effects
  def set_pos(pos)
    @prev_position = @position
    @position = grid_to_chess_coordinates(pos) || pos
    @moved = true
  end
end