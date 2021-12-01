require_relative "board.rb"
require_relative "piece.rb"

class Chess
  include ChessHelper

  def initialize(moves = nil)
    @board = nil
    @player_index = nil
    if moves && moves.is_a?(String)
      move_arr = moves.split(" ")
      if move_arr.empty? 
        puts "Aborting load: no moves to load"
      elsif !move_arr.all?{|move| valid_move_format?(move)}
        puts "Aborting load: invalid formatting"
      else
        @board = Board.board_with_moves(moves)
        @player_index = move_arr.length % 2
      end
    else
      @board = Board.new
      @board.set_up_new_board
      @player_index = 0
    end
  end

  def play
    until checkmate? 
      display_board
      display_turn
      player_turn
    end
    winner_msg
  end

  def player_turn
    #get input
    #handle input
  end

  def handle_input(input)
    #input valid and valid move
      #move piece
      #switch player
  end

  def player_input
    #get input
  end

  def checkmate?(player = @player_index) #player = player_color ?
    #check board for checkmate
    #checkmate = player in check and no valid moves
  end

  def display_board
    @board.display
  end

  def display_turn
    player_name = @player_index == WHITE ? "WHITE" : "BLACK"
    puts "#{player_name}'s Turn"
    puts "Your King is in check" if @board.in_check?(@player_index)
  end

  def switch_player
    @player_index = (@player_index + 1) % 2
  end

  private

end