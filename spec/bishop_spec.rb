require_relative "../lib/board.rb"

describe Bishop do
  describe "#moves" do
    let(:newly_set_up_board) do
      board = Board.new
      board.set_up_new_board
      board
    end

    context "when surrounded by own color" do
      before(:each) do
        @board = newly_set_up_board
        @grid = @board.grid
        @piece = @grid[7][5] #white's right bishop
        #@board.display      #uncomment to show setup
      end

      it "has no moves" do
        expect(@piece.moves).to be_empty
      end
    end

    context "when surrounded by own color, except forward-right" do
      before(:each) do
        @board = newly_set_up_board
        @board.move_piece("g2","g3") #move away pawn in forward-right space
        @grid = @board.grid
        @piece = @grid[7][5] #white's right bishop
        #@board.display      #uncomment to show setup
      end

      it "can go to edge of board" do
        expect(@piece.moves).to contain_exactly("g2", "h3")
      end
    end

    context "when a direction is blocked by enemy piece" do

      before(:each) do
        @board = newly_set_up_board
        @grid = @board.grid
        pieces = @grid[0] + @grid[1] + @grid[6] + @grid[7]
        pieces.each {|piece| allow(piece).to receive(:valid_move?).and_return(true)}

        @board.move_piece("g2","g3")
        @board.move_piece("f7","f5")
        @board.move_piece("f1","h3")
        @piece = @grid[5][7]
        #@board.display      #uncomment to show setup
      end

      it "can move to, but not beyond, enemy piece position" do
        expect(@piece.moves).to contain_exactly("f1", "g2", "g4", "f5")
      end
    end

    context "when a direction is blocked by ally piece" do

      before(:each) do
        @board = newly_set_up_board
        @grid = @board.grid
        pieces = @grid[0] + @grid[1] + @grid[6] + @grid[7]
        pieces.each {|piece| allow(piece).to receive(:valid_move?).and_return(true)}

        @board.move_piece("d2","d5")
        @board.move_piece("g2","g3")
        @board.move_piece("f1","g2")
        @piece = @grid[6][6]
        #@board.display      #uncomment to show setup
      end

      it "can move no further than space closest to ally, between ally and piece" do
        expect(@piece.moves).to contain_exactly("f1", "f3", "e4", "h3")
      end
    end
  end
end