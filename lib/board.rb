require_relative "chess_helper.rb"
Dir["./lib/pieces/*.rb"].each {|file| require file}

class Board
  include ChessHelper

  attr_reader :grid, :black_pieces, :white_pieces, :en_passant

  def initialize(moves = [])
    #grid 8x8 array
    @rows = 8
    @cols = 8
    @grid = Array.new(@rows){Array.new(@cols)}
    @black_pieces = []
    @white_pieces = []
    @en_passant = {}
  end

  def set_up_new_board
    first_rank_classes = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

    #black's first rank
    row_index = 0
    col_index = 0
    for piece_class in first_rank_classes
      piece = piece_class.new(self, [row_index, col_index], BLACK)
      @black_king = piece if piece.is_a?(King)
      @grid[row_index][col_index] = piece
      @black_pieces.push(piece)
      col_index += 1
    end

    #black's pawns
    row_index = 1
    for col_index in 0...@cols
      piece = Pawn.new(self, [row_index, col_index], BLACK)
      @grid[row_index][col_index] = piece
      @black_pieces.push(piece)
    end

    #white's first rank
    row_index = @rows - 1
    col_index = 0
    for piece_class in first_rank_classes
      piece = piece_class.new(self, [row_index, col_index], WHITE)
      @white_king = piece if piece.is_a?(King)
      @grid[row_index][col_index] = piece
      @white_pieces.push(piece)
      col_index += 1
    end

    #white's pawns
    row_index = @rows - 2
    for col_index in 0...@cols
      piece = Pawn.new(self, [row_index, col_index], WHITE)
      @grid[row_index][col_index] = piece
      @white_pieces.push(piece)
    end
  end

  def move_piece(start_pos, end_pos)
    both_in_valid_format = (in_chess_coords?(start_pos) || in_grid_coords?(start_pos)) &&
      (in_chess_coords?(end_pos) || in_grid_coords?(end_pos))
    return false unless both_in_valid_format

    start_pos = grid_to_chess_coordinates(start_pos) || start_pos
    end_pos = grid_to_chess_coordinates(end_pos) || end_pos

    piece = self[start_pos]

    return false unless piece

    return false unless piece.valid_move?(end_pos)
    #move is pseudo-legal at this point

    if in_check_after_move?(start_pos, end_pos)
      king_in_check_msg
      return false
    end
    #move is legal at this point

    piece_to_be_captured = self[end_pos]

    if piece_to_be_captured 
      capture_piece(piece_to_be_captured)
    elsif @en_passant[end_pos] && piece.is_a?(Pawn)
      piece_to_be_captured = @en_passant[end_pos]
      capture_piece(piece_to_be_captured)
      reset_en_passant
    end

    self[start_pos] = nil
    self[end_pos] = piece

    reset_en_passant unless @en_passant.empty?

    piece.set_pos(end_pos)  #side effects happen here
    true
  end

  def capture_piece(piece_to_be_captured)
    if piece_to_be_captured && piece_to_be_captured.is_a?(Piece)
      if @black_pieces.include?(piece_to_be_captured)
        @black_pieces.delete(piece_to_be_captured)
      elsif @white_pieces.include?(piece_to_be_captured)
        @white_pieces.delete(piece_to_be_captured)
      end
      self[piece_to_be_captured.position] = nil
    end
  end

  def set_en_passant(position, piece)
    reset_en_passant
    @en_passant[position] = piece
  end

  def color_space(contents, color_index)
    return contents.on_cyan if color_index == 0
    contents.on_blue
  end

  def under_attack_from_color?(color, position)
    position = grid_to_chess_coordinates(position) || position

    piece = nil
    piece_is_temp = false
    if self[position]
      piece = self[position]
    else
      piece = Piece.new(self, position, (color + 1) % 2)
      piece_is_temp = true
      self[position] = piece
    end
    pieces_to_check_moves = color == BLACK ? @black_pieces : @white_pieces
    
    under_attack = pieces_to_check_moves.any? do |piece| 
      if piece.is_a?(King)
        positions_around = piece.basic_valid_moves_in_chess_coords
        positions_around.include?(position)
      else
        piece.moves.include?(position)
      end
    end
    self[position] = nil if piece_is_temp

    under_attack
  end

  def in_check?(color)
    position = (color == WHITE) ? @white_king.position : @black_king.position
    under_attack_from_color?((color + 1) % 2, position)
  end

  def [](index)
    if index.is_a?(Integer)
      return @grid[index]
    elsif index.is_a?(String)
      row, col = chess_to_grid_coordinates(index)
      if row && col
        return @grid[row][col]
      end
    end
    nil
  end

  def []=(key, val)
    if key.is_a?(String)
      row, col = chess_to_grid_coordinates(key)
      if row && col
        @grid[row][col] = val
        return val
      end
    end
    nil
  end

  def display
    puts

    output = ""
    #build output row by row
    for row_index in 0...@rows
      row_number = @rows-row_index
      row_out = " #{row_number}" + (" " * 1)

      bg_color = row_index % 2

      for col_index in 0...@cols
        piece = @grid[row_index][col_index]
        piece_symbol = piece ? piece.piece_symbol : " "
        space_str = " #{piece_symbol} "

        if piece
          space_str = piece.color == BLACK ? space_str.black : space_str.white
        end
        
        grid_space = color_space(space_str, bg_color)
        last_col = col_index == @cols - 1
        row_out += "#{grid_space}#{last_col ? " " : ""}"
        bg_color = (bg_color + 1) % 2
      end
      output += "#{row_out}\n"
    end

    puts output

    #column indicators
    col_num_output = " " * 4
    for letter in "a".."h"
      col_num_output += "#{letter}" + (" " * 2)
    end
    puts col_num_output
  end

  private

  def reset_en_passant
    @en_passant = {}
  end

  #assumes that start_pos and end_pos have been validated
  def in_check_after_move?(start_pos, end_pos)
    raise ArgumentError.new("No Piece at start_pos") unless self[start_pos]
    
    piece_to_move = self[start_pos]
    other_piece = self[end_pos]
    force_move(start_pos, end_pos)
    check = in_check?(piece_to_move.color)
    force_move(end_pos, start_pos)
    self[end_pos] = other_piece
    check
  end

  #assumes that start_pos and end_pos have been validated
  def force_move(start_pos, end_pos)
    self[end_pos] = self[start_pos]
    self[start_pos] = nil
  end

  def king_in_check_msg
    puts "You cannot place your King in check"
  end
end

