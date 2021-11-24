require_relative "../lib/board.rb"

describe Knight do
  describe "#moves" do
    let(:newly_set_up_board) do
      board = Board.new
      board.set_up_new_board
      board
    end

    before(:each) do
      @board = newly_set_up_board
      grid = @board.grid
      @piece = grid[7][6]
      allow(@piece).to receive(:valid_move?).and_return(true)
    end

    it "can move to eight positions if no allies or edges are around" do
      @board.move_piece("g1","d5")
      #@board.display  #uncomment to show setup
      expect(@piece.moves).to contain_exactly("e7","f6","f4","e3","c3","b4","b6","c7")
    end

    it "cannot take allies" do
      @board.move_piece("g1","f3")
      #@board.display  #uncomment to show setup
      expect(@piece.moves).not_to include("d2", "h2", "e1", "h1")
    end
  end
end