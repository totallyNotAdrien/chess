require_relative "../lib/board.rb"

describe Queen do
  describe "#moves" do
    let(:newly_set_up_board) do
      board = Board.new
      board.set_up_new_board
      board
    end

    before(:each) do
      @board = newly_set_up_board
      @grid = @board.grid
      @piece = @grid[7][3] #white's queen
      allow(@piece).to receive(:valid_move?).and_return(true)
      @board.move_piece("d1","d5")
      #@board.display      #uncomment to show setup
    end

    it "can move in 8 directions" do
      expect_thing = expect(@piece.moves)
      expect_thing.to include('d6','d7','e6','f7','e5','f5','e4','f3','d4','d3','c4','b3','c5','b5','c6','b7')
    end
    #do not need more #moves tests because it uses #moves code from Rook and Bishop which have been tested
  end
end