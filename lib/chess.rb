require_relative "board.rb"
require_relative "piece.rb"

class Chess


  def initialize(moves = [])
    #new @board
    #@players{white:[], black:[]} #{"white"=>[pieces], "black=>[pieces]"}
    #@player_index
    #do stuff with moves
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

  def checkmate?
    #check board for checkmate
  end

  def display_board
    #@board.display
  end

  def switch_player
    #@player_index = (@player_index + 1) % 2
  end
end