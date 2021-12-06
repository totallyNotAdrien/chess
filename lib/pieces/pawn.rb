require_relative "../piece.rb"

class Pawn < Piece
  def initialize(board, position, color, moved = false)
    super(board, position, color, moved)
  end

  def piece_symbol
    "\u265f"
  end

  def set_pos(pos)
    @prev_position = grid_to_chess_coordinates(@position) || @position
    @position = grid_to_chess_coordinates(pos) || pos

    grid_pos = chess_to_grid_coordinates(@position) || @position
    row_index, col_index = grid_pos
    
    prev_grid_pos = chess_to_grid_coordinates(@prev_position)
    prev_row_index, prev_col_index = prev_grid_pos

    if (row_index - prev_row_index).abs == 2
      row_index = row_index + @backward
      en_passant_pos = grid_to_chess_coordinates([row_index, col_index])
      @board.set_en_passant(en_passant_pos, self)
    end
    @moved = true
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
    en_passant_piece = @board.en_passant[new_chess_pos]
    en_passant = en_passant_piece && en_passant_piece.color != @color
    out.push(new_chess_pos) if new_chess_pos && (other_piece_valid || en_passant)

    #right
    diag_right = [row_index + @forward, col_index + @right]
    new_chess_pos = grid_to_chess_coordinates(diag_right)
    other_piece = @board.grid[diag_right[0]][diag_right[1]]
    other_piece_valid = other_piece && other_piece.color != @color
    en_passant_piece = @board.en_passant[new_chess_pos]
    en_passant = en_passant_piece && en_passant_piece.color != @color
    out.push(new_chess_pos) if new_chess_pos && (other_piece_valid || en_passant)
    out
  end
end