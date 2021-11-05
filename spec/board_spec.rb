require_relative "../lib/board.rb"
describe Board do
  describe "#set_up_new_board" do
    matcher :have_correct_first_rank_classes do
      match do |actual|
        actual.is_a?(Array) && actual.length == 8 && classes_match(actual)
      end

      def classes_match(actual)
        first_rank_classes = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
        matches = 0
        for index in 0...(actual.length)
          matches += 1 if actual[index].class == first_rank_classes[index]
        end
        matches == 8
      end
    end

    matcher :be_all_pawns do
      match do |actual|
        actual.all? { |piece| piece.class == Pawn }
      end
    end

    matcher :all_be_of_color do |expected_color|
      match do |pieces|
        pieces.all? { |piece| piece.color == expected_color }
      end
    end

    let(:newly_set_up_board) do
      board = Board.new
      board.set_up_new_board
      board
    end

    context "when dealing with black's pieces" do
      let(:board_black_pieces) { newly_set_up_board }
      it "is all black pieces" do
        pieces = board_black_pieces.grid[0] + board_black_pieces.grid[1]
        expect(pieces).to all_be_of_color(Board::BLACK)
      end

      context "when rank is black's first rank" do
        let(:board_black_first_rank) { newly_set_up_board }

        it "has correct first rank classes" do
          expect(board_black_first_rank.grid[0]).to have_correct_first_rank_classes
        end
      end

      context "when rank is black's second rank" do
        let(:board_black_first_rank) { newly_set_up_board }

        it "is all pawns" do
          expect(board_black_first_rank.grid[1]).to be_all_pawns
        end
      end
    end

    context "when dealing with white's pieces" do
      let(:board_white_pieces) { newly_set_up_board }
      it "is all white pieces" do
        pieces = board_white_pieces.grid[6] + board_white_pieces.grid[7]
        expect(pieces).to all_be_of_color(Board::WHITE)
      end

      context "when rank is white's first rank" do
        let(:board_white_first_rank) { newly_set_up_board }

        it "has correct first rank classes" do
          expect(board_white_first_rank.grid[7]).to have_correct_first_rank_classes
        end
      end

      context "when rank is white's second rank" do
        let(:board_white_first_rank) { newly_set_up_board }

        it "is all pawns" do
          expect(board_white_first_rank.grid[6]).to be_all_pawns
        end
      end
    end
  end

  describe "#move_piece" do
    let(:newly_set_up_board) do
      board = Board.new
      board.set_up_new_board
      board
    end

    before(:each) do
      Piece.subs.each { |sub| allow_any_instance_of(sub).to receive(:valid_move?).and_return(true) }
    end

    context "when start_pos and end_pos are in valid formats" do
      context "if there is no piece at end_pos" do
        before(:each) do
          @board = newly_set_up_board
          @start_pos = "g2"
          @end_pos = "g4"
          @grid = @board.grid
          start_pos_grid = @board.chess_to_grid_coordinates(@start_pos)
          end_pos_grid = @board.chess_to_grid_coordinates(@end_pos)
          @row_index_start, @col_index_start = start_pos_grid
          @row_index_end, @col_index_end = end_pos_grid
          @piece_to_move = @grid[@row_index_start][@col_index_start]
          Piece.subs.each { |sub| allow_any_instance_of(sub).to receive(:valid_move?).and_return(true) }
        end

        it "sets grid space at piece's old position to nil" do
          expect_stuff = expect { @board.move_piece(@start_pos, @end_pos) }
          expect_stuff.to change { @grid[@row_index_start][@col_index_start] }.to(nil)
        end

        it "sets grid space at end position to piece" do
          expect_stuff = expect { @board.move_piece(@start_pos, @end_pos) }
          expect_stuff.to change { @grid[@row_index_end][@col_index_end] }.to(@piece_to_move)
        end

        it "does not capture any pieces" do
          expect(@board).to receive(:capture_piece).with(nil)
          @board.move_piece(@start_pos, @end_pos)
        end

        it "returns true" do
          expect(@board.move_piece(@start_pos, @end_pos)).to be(true)
        end
      end

      context "if there is an opposing piece at end_pos" do
        before(:each) do
          @board = newly_set_up_board
          @start_pos = "e4"
          @end_pos = "d5"
          @grid = @board.grid
          @grid[4][7] = nil
          @grid[3][1] = nil
          @grid[4][4] = Pawn.new(@board, "e4", Board::WHITE)
          @grid[3][3] = Pawn.new(@board, "d5", Board::BLACK)

          start_pos_grid = @board.chess_to_grid_coordinates(@start_pos)
          end_pos_grid = @board.chess_to_grid_coordinates(@end_pos)
          @row_index_start, @col_index_start = start_pos_grid
          @row_index_end, @col_index_end = end_pos_grid
          @piece_to_move = @grid[@row_index_start][@col_index_start]
        end

        it "sets grid space at piece's old position to nil" do
          expect_stuff = expect { @board.move_piece(@start_pos, @end_pos) }
          expect_stuff.to change { @grid[@row_index_start][@col_index_start] }.to(nil)
        end

        it "captures piece at end_pos" do
          piece_to_capture = @grid[@row_index_end][@col_index_end]
          expect(@board).to receive(:capture_piece).with(piece_to_capture)
          @board.move_piece(@start_pos, @end_pos)
        end

        it "sets grid space at end position to piece" do
          expect_stuff = expect { @board.move_piece(@start_pos, @end_pos) }
          expect_stuff.to change { @grid[@row_index_end][@col_index_end] }.to(@piece_to_move)
        end

        it "returns true" do
          expect(@board.move_piece(@start_pos, @end_pos)).to be(true)
        end
      end

      context "if there is no piece at start_pos" do
        before(:each) do
          @board = newly_set_up_board
        end

        it "returns false" do
          expect(@board.move_piece("a3","a4")).to be(false)
        end

        it "returns false" do
          expect(@board.move_piece([5,0], [4,0])).to be(false)
        end
      end

      context "if move is not valid" do
        before(:each) do
          Piece.subs.each { |sub| allow_any_instance_of(sub).to receive(:valid_move?).and_return(false) }
          @board = newly_set_up_board
        end
        it "returns false" do
          expect(@board.move_piece("a2", "g7")).to be(false)
        end
      end
    end

    context "when either start_pos or end_pos are in an invalid format" do
      before(:each) do
        @board = newly_set_up_board
      end
      context "if start_pos is invalid" do
        it "returns false" do
          expect(@board.move_piece("a31", "a5")).to be(false)
        end
        it "returns false" do
          expect(@board.move_piece([1,2,1,4], [1,4])).to be(false)
        end
      end

      context "if end_pos is invalid" do
        it "returns false" do
          expect(@board.move_piece("a2", "h57")).to be(false)
        end
        it "returns false" do
          expect(@board.move_piece([2,3], [2,3,2,5])).to be(false)
        end
      end
    end
  end
end
