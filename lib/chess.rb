require_relative "board.rb"
require_relative "piece.rb"
require "pry-byebug"

class Chess
  include ChessHelper

  def initialize(moves = nil)
    @board = nil
    @player_index = nil
    if moves && moves.is_a?(String)
      move_arr = moves.split(" ")
      if move_arr.empty?
        puts "Aborting load: no moves to load"
      elsif !move_arr.all? { |move| valid_move_format?(move) }
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
      player_turn
    end
    display_board
    winner_msg
  end

  def player_turn
    loop do
      display_turn
      input = player_input
      break if handle_input(input)
    end
    switch_player
  end

  def handle_input(input)
    if valid_move_format?(input)
      start_pos, end_pos = formatted_move_string_to_array(input)
      if @board[start_pos] == nil
        puts "There is no piece there"
        return false
      elsif @board[start_pos].color != @player_index
        puts "That's not your piece"
        return false
      else
        return @board.move_piece(start_pos, end_pos)
      end
    end
  end

  def player_input
    print "Enter your move: "
    gets.chomp.strip.remove_spaces
  end

  def checkmate?(player = @player_index)
    @board.in_checkmate?(player)
  end

  def display_board
    @board.display
  end

  def display_turn
    player_name = @player_index == WHITE ? "WHITE" : "BLACK"
    puts
    puts "#{player_name}'s Turn"
    puts "Your King is in check" if @board.in_check?(@player_index)
  end

  def switch_player
    @player_index = (@player_index + 1) % 2
  end

  private

  def winner_msg
    name = if checkmate?(WHITE)
        "Black"
      elsif checkmate?(BLACK)
        "White"
      else
        "No one"
      end
    puts
    puts "#{name} Wins!"
  end
end
