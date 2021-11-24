require_relative "../lib/board.rb"

describe Pawn do
  describe "#moves" do
    let(:newly_set_up_board) do
      board = Board.new
      board.set_up_new_board
      board
    end

    before(:each) do
      @board = newly_set_up_board
      grid = @board.grid
      @piece = grid[6][4] #e2
    end

    context "when piece (e2) has not moved" do
      context "if there are no pieces blocking its path" do
        it "can only move one or two spaces forward" do
          #@board.display  #uncomment to show setup
          expect(@piece.moves).to contain_exactly("e3", "e4")
        end
      end

      before(:each) do
        b_queen = @board.grid[0][3]
        allow(b_queen).to receive(:valid_move?).and_return(true)
      end

      context "if there is a piece two spaces in front of it" do
        it "can only move one space forward" do
          @board.move_piece("d8", "e4")
          #@board.display  #uncomment to show setup
          expect(@piece.moves).to contain_exactly("e3")
        end
      end

      context "if there is an enemy piece on one forward diagonal" do
        it "can move forward one or two spaces or to one diagonal" do
          @board.move_piece("d8", "d3")
          #@board.display  #uncomment to show setup
          expect(@piece.moves).to contain_exactly("d3", "e3", "e4")
        end

        it "can move forward one or two spaces or to one diagonal" do
          @board.move_piece("d8", "f3")
          #@board.display  #uncomment to show setup
          expect(@piece.moves).to contain_exactly("f3", "e3", "e4")
        end
      end
    end

    context "when piece (e2) has moved" do
      before(:each) do
        @board = newly_set_up_board
        grid = @board.grid
        @piece = grid[6][4] #e2
      end

      context "if path is not blocked and there are no pieces around" do
        it "can only move forward one space" do
          @board.move_piece("e2", "e3")
          expect(@piece.moves).to contain_exactly("e4")
        end
      end
    end

    context "when there is a piece one space in front of it and nowhere else in range" do
      before(:each) do
        b_queen = @board.grid[0][3]
        allow(b_queen).to receive(:valid_move?).and_return(true)
      end
      
      it "cannot move" do
        @board.move_piece("d8", "e3")
        #@board.display  #uncomment to show setup
        expect(@piece.moves).to be_empty
      end
    end

    context "when there is an ally piece on a diagonal" do
      it "cannot take ally" do
        @board.move_piece("f2", "f3")
        #@board.display  #uncomment to show setup
        expect(@piece.moves).not_to include("f3")
      end
    end

    context "when enemy pawn's first move places it next to pawn (2 space move)" do
      before(:each) do
        pawn_e2 = @board.grid[6][4]
        allow(pawn_e2).to receive(:valid_move?).and_return(true)
      end

      it "can perform en passant" do
        @board.move_piece("e2", "e5")
        @board.move_piece("d7", "d5")
        #@board.display  #uncomment to show setup
        expect(@piece.moves).to include("d6")
      end
    end
  end
end