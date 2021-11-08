require_relative "../piece.rb"

class Bishop < Piece
  def initialize(board, position, color = WHITE)
    super(board, position, color)
  end

  def piece_symbol
    "\u265d"
  end

  def moves
    out = []

    diagonal_moves(out, @forward, @left)
    diagonal_moves(out, @forward, @right)
    diagonal_moves(out, @backward, @left)
    diagonal_moves(out, @backward, @right)

    out
  end

  private

  def diagonal_moves(move_arr, row_dir, col_dir)
    pos = chess_to_grid_coordinates(@position) || @position
    
    row_index, col_index = pos
    dist = 1
    loop do
      new_row_index = row_index + (row_dir * dist)
      new_col_index = col_index + (col_dir * dist)

      break unless new_pos = grid_to_chess_coordinates([new_row_index, new_col_index])
      piece_at_new_pos = @board.grid[new_row_index][new_col_index]

      if piece_at_new_pos
        if piece_at_new_pos.color == @color
          return
        else
          move_arr.push(new_pos)
          return
        end
      end
      
      move_arr.push(new_pos) 
      dist += 1
    end
  end
end