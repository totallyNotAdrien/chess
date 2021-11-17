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
      new_pos = [row_index + row_dir, col_index + col_dir]
      out.push(new_pos) if in_grid_coords?(new_pos)
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
    queenside_others = @board.grid[row_index][(col_index - 3)..(col_index-1)]

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
    row_index, col_index = chess_to_grid_coordinates(@position) || @position

    new_row_index, new_col_index = chess_to_grid_coordinates(pos) || pos

    #castling
    if !moved && new_row_index == row_index && 
      (new_col_index - col_index).abs == 2
      rook_col = nil
      new_rook_col = nil

      rook = if new_col_index > col_index
        rook_col = 7
        new_rook_col = col_index + 1
        @board.grid[row_index][rook_col]
      else
        rook_col = 0
        new_rook_col = col_index - 1
        @board.grid[row_index][rook_col]
      end

      if rook
        @prev_position = @position
        @position = grid_to_chess_coordinates(pos) || pos
        @moved = true
        @board.grid[row_index][rook_col] = nil
        @board.grid[row_index][new_rook_col] = rook
        rook.set_pos([row_index, new_rook_col])
      end
    else
      super(pos)
    end
  end
end