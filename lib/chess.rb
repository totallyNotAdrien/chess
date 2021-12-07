require_relative "board.rb"
require_relative "piece.rb"
require "yaml"
require "pry-byebug"

class Chess
  include ChessHelper

  attr_reader :board

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
        if move_success
          @moves.push(start_pos + end_pos)
          check_pawn_promotion(piece)
        end
        return move_success
      end
    elsif input.downcase == "save"
      save
      @end_game = true
      true
    elsif input.downcase == "quit" || input.downcase == "exit"
      @end_game = true
      true
    elsif input.downcase == "help"
      Chess.show_help_screen
      false
    else
      puts
      puts "Invalid move format '#{input}'".red
    end
  end

  def player_input
    print "Enter 'help' for how to play or enter your move: "
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

  def self.show_help_screen
    puts <<~HELPSCREEN



    #{"How To Move".yellow}
    This game uses a form of algebraic notation to input moves.
    It uses the letters and numbers displayed along the sides
    of the board to represent any square on the board.

    For example, when a game first starts:
      "a2a4" will move the leftmost white pawn 2 spaces forward
      "g1f3" will move the right white knight 2 forward and 1 left


    #{"Commands".yellow}
    help: displays this screen
    save: allows you to name and save your game, then quits the game
    exit/quit: quits the game without saving


    HELPSCREEN
    print "Press ENTER to continue..."
    gets
    puts "\n\n\n\n"
  end

  private

  def save
    path = save_path
    File.open(path, "w") do |file|
      YAML.dump(moves, file)
    end
  end

  def save_name_to_path(save_name)
    "saves/#{save_name}.yaml"
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

  def moves
    @moves.join(" ")
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

  def check_pawn_promotion(piece)
    if piece.is_a?(Pawn)
      row_index = chess_to_grid_coordinates(piece.position)[0]
      if row_index == 0 || row_index == 7
        promote_pawn(piece)
      end
    end
  end

  def promote_pawn(piece)
    input = nil
    loop do
      puts "Enter the name or first letter of the piece"
      puts "you want to promote you pawn to"
      print "[k] knight, [b] bishop, [r] rook, [q] queen: "
      input = gets.chomp.strip.downcase[0]
      valid = ["k", "b", "r", "q"]
      if valid.include?(input)
        break 
      else
        puts
        puts "Invalid input"
        puts
      end
    end

    piece_class = case input[0]
      when "k"
        Knight
      when "b"
        Bishop
      when "r"
        Rook
      else
        Queen
      end

    @board.promote_pawn(piece, piece_class)
  end
end
