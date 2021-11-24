require_relative "../piece.rb"

class Knight < Piece
  def initialize(board, position, color = WHITE)
    super(board, position, color)
  end

  def piece_symbol
    "\u265e"
  end

  def moves
    out = []
    pos = chess_to_grid_coordinates(@position) || @position

    row_index, col_index = pos
    
    nne_grid = [row_index + @forward * 2, col_index + @right]
    ene_grid = [row_index + @forward, col_index + @right * 2]

    ese_grid = [row_index + @backward, col_index + @right * 2]
    sse_grid = [row_index + @backward * 2, col_index + @right]

    ssw_grid = [row_index + @backward * 2, col_index + @left]
    wsw_grid = [row_index + @backward, col_index + @left * 2]

    wnw_grid = [row_index + @forward, col_index + @left * 2]
    nnw_grid = [row_index + @forward * 2, col_index + @left]

    out.push(nne_grid) if in_grid_coords?(nne_grid)
    out.push(ene_grid) if in_grid_coords?(ene_grid)
    out.push(ese_grid) if in_grid_coords?(ese_grid)
    out.push(sse_grid) if in_grid_coords?(sse_grid)
    out.push(ssw_grid) if in_grid_coords?(ssw_grid)
    out.push(wsw_grid) if in_grid_coords?(wsw_grid)
    out.push(wnw_grid) if in_grid_coords?(wnw_grid)
    out.push(nnw_grid) if in_grid_coords?(nnw_grid)

    out.reject! do |row, col|
      piece_at_pos = @board.grid[row][col]
      piece_at_pos &&
        (piece_at_pos.color == @color || @board.en_passant[piece_at_pos.position])
    end

    out.map!{|coords| grid_to_chess_coordinates(coords)}
  end
end