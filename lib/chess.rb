require_relative "board.rb"
require_relative "piece.rb"
require "yaml"
require "pry-byebug"

class Chess
  include ChessHelper

  def initialize(moves_to_load = nil)
    @end_game = false
    @board = nil
    @player_index = nil
    @moves = []
    if moves_to_load && moves_to_load.is_a?(String)
      move_arr = moves_to_load.split(" ")
      if move_arr.empty?
        puts "Aborting load: no moves to load"
      elsif !move_arr.all? { |move| valid_move_format?(move) }
        puts "Aborting load: invalid formatting"
      else
        @board = Board.board_with_moves(moves_to_load)
        @player_index = move_arr.length % 2
        @moves = move_arr
      end
    else
      @board = Board.new
      @board.set_up_new_board
      @player_index = 0
    end
  end

  def play
    until checkmate? || @end_game
      player_turn
    end

    unless @end_game
      display_board
      winner_msg
    end
  end

  def player_turn
    loop do
      display_board
      display_turn
      input = player_input
      break if handle_input(input)
    end
    switch_player
  end

  def handle_input(input)
    if valid_move_format?(input)
      start_pos, end_pos = formatted_move_string_to_array(input)
      piece = @board[start_pos]
      if piece == nil
        puts
        puts "There is no piece there (#{start_pos})".yellow
        return false
      elsif piece.color != @player_index
        puts
        puts "That's not your piece (#{piece.class} #{start_pos})".red
        return false
      elsif !piece.valid_move?(end_pos)
        puts
        puts "#{piece.class} #{start_pos} cannot move there (#{end_pos})".red
        return false
      else
        move_success = @board.move_piece(start_pos, end_pos)
        @moves.push(start_pos + end_pos) if move_success
        return move_success
      end
    elsif input.downcase == "save"
      save
      @end_game = true
      true
    elsif input.downcase == "quit" || input.downcase == "exit"
      @end_game = true
      true
    end
  end

  def player_input
    puts "Enter 'save' to save and quit, 'quit' / 'exit' to quit without saving, or"
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

  def moves
    @moves.join(" ")
  end

  def save
    path = save_path
    File.open(path, "w") do |file|
      YAML.dump(moves, file)
    end
  end

  def save_path
    print "Enter a name to save this game as: "
    #binding.pry
    dupe_index = 1
    input = gets.chomp.strip
    if input.empty?
      save_name = "0"
    else
      save_name = input
    end

    while File.exist?(save_name_to_path(save_name))
      save_name = "#{input}#{dupe_index}"
      dupe_index += 1
    end

    save_name_to_path(save_name)
  end

  private

  def save_name_to_path(save_name)
    "saves/#{save_name}.yaml"
  end

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
