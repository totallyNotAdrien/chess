require_relative "chess.rb"

def d
  @board.display
end

def m(start_pos, end_pos)
  moved = @board.move_piece(start_pos, end_pos)
  d
  moved
end

def load_game
  paths = Dir.glob("saves/*.yaml").sort
  if paths.length > 0
    file_number = 1
    paths.each do |path|
      if File.exist?(path)
        puts "[#{file_number}] #{path_to_save_name(path)}"
      end
      puts "\n\n"
      file_number += 1
    end
    print "Select the number [x] of the file you want to load (ex: '1'): "
    input = gets.chomp.strip
    until load_file_number_valid?(input, paths)
      print "Selection must be a number listed: "
      input = gets.chomp.strip
    end

    path = paths[input.to_i - 1]
    if File.exist?(path)
      moves_str = YAML.load_file(path)
      return moves_str
    else
      puts "Could not find '#{path}'"
    end
  else
    puts "No games to load\n\n"
  end
end

def load_file_number_valid?(input, paths)
  input && input.length != 0 && input.to_i > 0 && input.to_i < paths.length + 1
end

def path_to_save_name(path)
  path.gsub("saves/", "").gsub(".yaml", "")
end

puts "Welcome to Chess."
puts "Would you like to start a new game, or continue an old one?"
puts "\t[1]   New Game"
puts "\t[2]   Load Game"
puts "\t[ANY] Quit"
puts
print "Selection: "
input = gets.chomp.strip

case input
when '1'
  Chess.new.play
when '2'
  Chess.new(load_game).play
else
  puts "Goodbye"
end