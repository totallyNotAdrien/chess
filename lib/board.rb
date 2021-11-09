require_relative "chess_helper.rb"
Dir["./lib/pieces/*.rb"].each {|file| require file}

class Board
  include ChessHelper

  attr_reader :grid, :black_pieces, :white_pieces, :ghost_pawn

  def initialize(moves = [])
    #grid 8x8 array
    @rows = 8
    @cols = 8
    @grid = Array.new(@rows){Array.new(@cols)}
    @black_pieces = []
    @white_pieces = []
    @ghost_pawn = nil
  end

  def set_up_new_board
    first_rank_classes = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

    #black's first rank
    row_index = 0
    col_index = 0
    for piece_class in first_rank_classes
      piece = piece_class.new(self, [row_index, col_index], BLACK)
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
    
    start_pos = chess_to_grid_coordinates(start_pos) if in_chess_coords?(start_pos)
    row_index, col_index = start_pos
    piece = @grid[row_index][col_index]

    return false unless piece
    end_pos = chess_to_grid_coordinates(end_pos) || end_pos

    return false unless piece.valid_move?(end_pos)

    #valid move
    new_row_index, new_col_index = end_pos
    piece_to_capture = @grid[new_row_index][new_col_index]

    capture_piece(piece_to_capture)
    
    @grid[row_index][col_index] = nil
    @grid[new_row_index][new_col_index] = piece
    piece.set_pos(end_pos)  #side effects happen here
    if @ghost_pawn && @ghost_pawn.color != piece.color
      @ghost_pawn = nil
    end
    true
  end

  def capture_piece(piece_to_capture)
    if piece_to_capture && piece_to_capture.is_a?(Piece)
      if @black_pieces.include?(piece_to_capture)
        @black_pieces.delete(piece_to_capture)
      elsif @white_pieces.include?(piece_to_capture)
        @white_pieces.delete(piece_to_capture)
        #elsif piece_to_capture is ghost piece
        #capture_piece(ghost_piece.parent_piece)
      end
    end
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
          if piece.is_a?(GhostPawn)
            space_str = piece.color == BLACK ? space_str.gray : space_str.peach 
          else
            space_str = piece.color == BLACK ? space_str.black : space_str.white
          end
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

  def ghost_pawn=(ghost)
    return unless ghost

    if @ghost_pawn
      curr_pawn_pos = chess_to_grid_coordinates(@ghost_pawn.position)
      row_index, col_index = curr_pawn_pos
      @grid[row_index][col_index] = nil
    end

    pos = chess_to_grid_coordinates(ghost.position) || ghost.position
    row_index, col_index = pos
    @ghost_pawn = ghost
    @grid[row_index][col_index] = ghost
  end

  def color_space(contents, color_index)
    return contents.on_cyan if color_index == 0
    contents.on_blue
  end

  def colored_piece(thing)
    "m"
  end

  def em
    "\u2014"
  end

  def grid_row_separator
    thing = "+ #{em * 2} "
    " #{em * 2} #{thing * (@cols - 1)}"
  end
end

