require_relative "../lib/board.rb"

describe Rook do
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
        @piece = @grid[7][7] #white's right rook
        #@board.display      #uncomment to show setup
      end

      it "has no moves" do
        expect(@piece.moves).to be_empty
      end
    end

    context "when a direction is clear of pieces" do
      before(:each) do
        @board = newly_set_up_board
        @grid = @board.grid
        @piece = @grid[7][7] #white's right rook
        pieces = @grid[0] + @grid[1] + @grid[6] + @grid[7]
        pieces.each {|piece| allow(piece).to receive(:valid_move?).and_return(true)}
      end

      it "can go to edge of board" do
        @board.move_piece("h1", "d4")
        #@board.display      #uncomment to show setup
        expect(@piece.moves).to include("a4","b4","c4","e4","f4","g4","h4")
      end

      it "can go to edge of board" do
        @board.move_piece("h1", "h4")
        @board.move_piece("h2", "e3")
        @board.move_piece("h8", "d6")
        @board.move_piece("h7", "e6")
        #@board.display      #uncomment to show setup
        expect(@piece.moves).to include("h1","h2","h3","h5","h6","h7","h8")
      end
    end

    context "when a direction is blocked by enemy piece" do
      before(:each) do
        @board = newly_set_up_board
        @grid = @board.grid
        pawn_h7 = @grid[1][7]
        allow(pawn_h7).to receive(:valid_move?).and_return(true)
        pawn_h2 = @grid[6][7]
        allow(pawn_h2).to receive(:valid_move?).and_return(true)

        @board.move_piece("h2","g3")
        @board.move_piece("h7","h4")
        @piece = @grid[7][7]
        #@board.display      #uncomment to show setup
      end

      it "can move to, but not beyond, enemy piece position" do
        expect(@piece.moves).to contain_exactly("h2", "h3", "h4")
      end
    end

    context "when a direction is blocked by ally piece" do
      before(:each) do
        @board = newly_set_up_board
        @grid = @board.grid
        pawn_h2 = @grid[6][7]
        allow(pawn_h2).to receive(:valid_move?).and_return(true)

        @board.move_piece("h2","h6")
        @piece = @grid[7][7]
        #@board.display      #uncomment to show setup
      end

      it "can move no further than space closest to ally, between ally and piece" do
        expect(@piece.moves).to contain_exactly("h2", "h3", "h4","h5")
      end
    end
  end
end