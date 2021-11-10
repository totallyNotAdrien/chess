require_relative "../lib/board.rb"

describe Pawn do
  describe "#moves" do
    let(:newly_set_up_board) do
      board = Board.new
      board.set_up_new_board
      board
    end

    context "when piece has not moved" do
      before(:each) do
        @board = newly_set_up_board
        grid = @board.grid
        @piece = grid[6][4] #e2
      end

      context "if there are no pieces blocking its path" do
        it "can only move one or two spaces forward" do
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
          expect(@piece.moves).to contain_exactly("e3")
        end
      end

      context "if there is a piece one space in front of it and nowhere else in range" do
        it "cannot move" do
          @board.move_piece("d8", "e3")
          expect(@piece.moves).to be_empty
        end
      end

      context "if there is an enemy piece on one forward diagonal" do
        it "can move forward one or two spaces or to one diagonal" do
          @board.move_piece("d8", "d3")
          expect(@piece.moves).to contain_exactly("d3", "e3", "e4")
        end

        it "can move forward one or two spaces or to one diagonal" do
          @board.move_piece("d8", "f3")
          expect(@piece.moves).to contain_exactly("f3", "e3", "e4")
        end
      end
    end
  end
end