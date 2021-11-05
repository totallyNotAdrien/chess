require_relative "../piece.rb"

class Pawn < Piece
  def initialize(board, position, color = WHITE)
    super(board, position, color)
  end

  def piece_symbol
    "\u265f"
  end

  def moves
    out = []
    row_index, col_index = chess_to_grid_coordinates(@position) || @position

    #forward movement
    new_row_index = row_index + @forward
    new_col_index = col_index
    piece_one_forward = @board.grid[new_row_index][new_col_index]
    new_chess_pos = grid_to_chess_coordinates([new_row_index, new_col_index])
    out.push(new_chess_pos) if new_chess_pos && piece_one_forward == nil

    #double forward movement
    new_row_index = row_index + (@forward * 2)
    new_col_index = col_index
    new_chess_pos = grid_to_chess_coordinates([new_row_index, new_col_index])
    if new_chess_pos && !@board.grid[new_row_index][new_col_index] && 
      !piece_one_forward && !@moved
        out.push(new_chess_pos) 
    end

    #diagonal movement
    #left
    diag_left = [row_index + @forward, col_index + @left]
    new_chess_pos = grid_to_chess_coordinates(diag_left)
    other_piece = @board.grid[diag_left[0]][diag_left[1]]
    other_piece_valid = other_piece && other_piece.color != @color
    out.push(new_chess_pos) if new_chess_pos && other_piece_valid

    #right
    diag_right = [row_index + @forward, col_index + @right]
    new_chess_pos = grid_to_chess_coordinates(diag_right)
    other_piece = @board.grid[diag_right[0]][diag_right[1]]
    other_piece_valid = other_piece && other_piece.color != @color
    out.push(new_chess_pos) if new_chess_pos && other_piece_valid
    out
  end

  def valid_move?(pos)
    pos = grid_to_chess_coordinates(pos) || pos
    moves.include?(pos)
  end
end