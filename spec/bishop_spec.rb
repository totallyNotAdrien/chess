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

      it "can go to g2 and h3" do
        expect(@piece.moves).to contain_exactly("g2", "h3")
      end
    end
  end
end