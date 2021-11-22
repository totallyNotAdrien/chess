require_relative "../piece.rb"

class King < Piece
  def initialize(board, position, color = WHITE)
    super(board, position, color)
  end

  def piece_symbol
    "\u265a"
  end

  def moves
    out = basic_valid_moves_in_grid_coords
    add_possible_castling(out)

    out.map! { |coords| grid_to_chess_coordinates(coords) }
    out
  end

  def positions_around_in_grid_coords
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
    out
  end

  def basic_valid_moves_in_grid_coords
    out = positions_around_in_grid_coords

    out.reject! do |row_index, col_index|
      piece_at_pos = @board.grid[row_index][col_index]
      piece_at_pos && (piece_at_pos.color == color || piece_at_pos.is_a?(GhostPawn))
    end
    out
  end

  def basic_valid_moves_in_chess_coords
    basic_valid_moves_in_grid_coords.map{|coords| grid_to_chess_coordinates(coords)}
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
        @board.grid[row_index][rook_col] = nil
        @board.grid[row_index][new_rook_col] = rook
        rook.set_pos([row_index, new_rook_col])
      end
    end

    super(pos)
  end

  private

  def add_possible_castling(out)
    #castling stuff
    row_index, col_index = chess_to_grid_coordinates(@position) || @position

    #kingside_castle
    kingside_rook = @board.grid[row_index][7]
    kingside_others = @board.grid[row_index][(col_index + 1)..(col_index + 2)]
    kingside_positions = (0..2).map { |offset| [row_index, col_index + offset] }

    kingside_under_attack = kingside_positions.any? do |pos|
      @board.under_attack_from_color?((@color + 1) % 2, pos)
    end

    if !moved && kingside_others.all? { |piece| piece == nil } &&
      kingside_rook && !kingside_rook.moved && !kingside_under_attack
      out.push([row_index, col_index + 2])
    end

    #queenside castle
    queenside_rook = @board.grid[row_index][0]
    queenside_others = @board.grid[row_index][(col_index - 3)..(col_index - 1)]
    queenside_positions = (-2..0).map { |offset| [row_index, col_index + offset] }

    queenside_under_attack = queenside_positions.any? do |pos|
      @board.under_attack_from_color?((@color + 1) % 2, pos)
    end

    if !moved && queenside_others.all? { |piece| piece == nil } &&
      queenside_rook && !queenside_rook.moved && !queenside_under_attack
      out.push([row_index, col_index - 2])
    end
  end
end
