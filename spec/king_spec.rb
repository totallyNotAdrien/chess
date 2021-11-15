require_relative "../lib/board.rb"

describe King do
  describe "#moves" do
    let(:newly_set_up_board) do
      board = Board.new
      board.set_up_new_board
      board
    end

    before(:each) do
      @board = newly_set_up_board
      @grid = @board.grid
      @piece = @grid[7][4] #white's king
      allow(@piece).to receive(:valid_move?).and_return(true)
    end

    it "can take enemy pieces 1 space away" do
      @board.move_piece("e1", "e6")
      #@board.display      #uncomment to show setup
      expect(@piece.moves).to include("d7", "e7", "f7")
    end

    it "cannot take allied pieces" do
      @board.move_piece("e1", "e3")
      #@board.display      #uncomment to show setup
      expect(@piece.moves).not_to include("d2", "e2", "f2")
    end

    it "cannot take ghost pawns" do
      @board.move_piece("e1", "e6")
      @board.move_piece("f7", "f5")
      #@board.display      #uncomment to show setup
      expect(@piece.moves).not_to include("f6")
    end


    context "when all spaces around it are empty" do
      it "can move to 8 spaces" do
        @board.move_piece("e1","d5")
        #@board.display      #uncomment to show setup
        expect_thing = expect(@piece.moves)
        expect_thing.to include('d6','e6','e5','e4','d4','c4','c5','c6')
      end
    end 
  end
end