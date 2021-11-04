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
    before do
      Piece.subclasses.each { |sub| allow_any_instance_of(sub).to receive(:valid_move?).and_return(true) }
    end

    context "when start_pos and end_pos are valid" do
      it "returns true" do
      end
    end
  end
end
