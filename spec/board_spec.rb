require_relative "../lib/board.rb"
describe Board do

  let(:newly_set_up_board) do
    board = Board.new
    board.set_up_new_board
    board
  end

  def board_with_moves(moves_str, show_each_step = false)
    board = newly_set_up_board
    moves = moves_str.split(" ")
    moves.each do |move_str|
      start_pos, end_pos = move_str.insert(2,":").split(":")
      board.move_piece(start_pos, end_pos)
      board.display if show_each_step
    end
    board
  end
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
    before(:each) do
      @board = newly_set_up_board
    end

    context "when start_pos and end_pos are in valid formats" do
      context "if there is no piece at end_pos" do
        before(:each) do
          @start_pos = "g2"
          @end_pos = "g4"
          start_pos_grid = @board.chess_to_grid_coordinates(@start_pos)
          end_pos_grid = @board.chess_to_grid_coordinates(@end_pos)
          @row_index_start, @col_index_start = start_pos_grid
          @row_index_end, @col_index_end = end_pos_grid
          @piece_to_move = @board[@start_pos]
        end

        it "sets grid space at piece's old position to nil" do
          expect_stuff = expect { @board.move_piece(@start_pos, @end_pos) }
          expect_stuff.to change { @board[@start_pos] }.to(nil)
        end

        it "sets grid space at end position to piece" do
          expect_stuff = expect { @board.move_piece(@start_pos, @end_pos) }
          expect_stuff.to change { @board[@end_pos] }.to(@piece_to_move)
        end

        it "does not capture any pieces" do
          expect(@board).not_to receive(:capture_piece)
          @board.move_piece(@start_pos, @end_pos)
        end

        it "returns true" do
          expect(@board.move_piece(@start_pos, @end_pos)).to be(true)
        end

        it "resets @en_passant" do
          allow(@board).to receive(:reset_en_passant)
          expect(@board).to receive(:reset_en_passant)
          @board.move_piece(@start_pos, @end_pos)
        end
      end

      context "if moving piece is a pawn" do
        before(:each) do
          @black_pawn = @board["d7"]
          @white_pawn = @board["e2"]
        end

        context "if opposing piece has just moved into en passant position" do
          before(:each) do
            @board.move_piece("e2", "e4")
            #@board.display      #uncomment to show step
            @board.move_piece("e4", "e5")
            #@board.display      #uncomment to show step
            @board.move_piece("d7", "d5")
            #@board.display      #uncomment to show setup
          end

          it "resets @en_passant" do
            allow(@board).to receive(:reset_en_passant)
            expect(@board).to receive(:reset_en_passant)
            @board.move_piece("e5", "d6")
            #@board.display      #uncomment to show result
          end

          it "captures just-moved opposing piece" do
            expect(@board).to receive(:capture_piece).with(@black_pawn)
            @board.move_piece("e5", "d6")
          end

          it "sets opposing piece's space to nil" do
            expect { @board.move_piece("e5", "d6") }.to change {@board[@black_pawn.position]}.to(nil)
            #@board.display      #uncomment to show result
          end
        end

        context "if opposing piece was already in en passant position" do
          before(:each) do
            @board.move_piece("e2", "e4")
            #@board.display      #uncomment to show step
            @board.move_piece("d7", "d5")
            #@board.display      #uncomment to show step
            @board.move_piece("e4", "e5")
            #@board.display      #uncomment to show setup
          end

          it "cannot perform en passant" do
            expect(@board.move_piece("e5", "d6")).to be(false)
          end
        end
      end

      context "if there is an opposing piece at end_pos" do
        before(:each) do
          @start_pos = "e4"
          @end_pos = "d5"
          @board["d7"] = nil
          @board["e2"] = nil
          white_pawn = Pawn.new(@board, @start_pos, Board::WHITE)
          black_pawn = Pawn.new(@board, @end_pos, Board::BLACK)
          # allow(white_pawn).to receive(:valid_move?).and_return(true)
          # allow(black_pawn).to receive(:valid_move?).and_return(true)
          @board[@start_pos] = white_pawn
          @board[@end_pos] = black_pawn

          start_pos_grid = @board.chess_to_grid_coordinates(@start_pos)
          end_pos_grid = @board.chess_to_grid_coordinates(@end_pos)
          @row_index_start, @col_index_start = start_pos_grid
          @row_index_end, @col_index_end = end_pos_grid
          @piece_to_move = @board[@start_pos]
          #@board.display      #uncomment to show setup
        end

        it "sets grid space at piece's old position to nil" do
          expect_stuff = expect { @board.move_piece(@start_pos, @end_pos) }
          expect_stuff.to change { @board[@start_pos] }.to(nil)
        end

        it "captures piece at end_pos" do
          piece_to_capture = @board[@end_pos]
          expect(@board).to receive(:capture_piece).with(piece_to_capture)
          @board.move_piece(@start_pos, @end_pos)
        end

        it "sets grid space at end position to piece" do
          expect_stuff = expect { @board.move_piece(@start_pos, @end_pos) }
          expect_stuff.to change { @board[@end_pos] }.to(@piece_to_move)
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
          pieces = @board[0] + @board[1] + @board[6] + @board[7]
          pieces.each {|piece| allow(piece).to receive(:valid_move?).and_return(false)}
        end
        it "returns false" do
          expect(@board.move_piece("a2", "g7")).to be(false)
        end
      end

      context "if move places current color in check" do
        before(:each) do
          allow(@board).to receive(:king_in_check_msg)
        end

        context "when the king is not already in check" do
          it "returns false" do
            #true/false = show/not show each step
            @board = board_with_moves("e2e4 d7d5 e4d5 d8d5 f1e2 d5e4", false)
            #@board.display      #uncomment to show setup
            expect(@board.move_piece("e2","b5")).to be(false)
          end
        end

        context "when the king is already in check" do
          it "returns false" do
            #true/false = show/not show each step
            @board = board_with_moves("g8h6 h6f5 f5h4 h4f3", false)
            #@board.display      #uncomment to show setup
            expect(@board.move_piece("e2","e3")).to be(false)
          end
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

  describe "#under_attack_from_color?" do
    before(:each) do
      @board = newly_set_up_board
    end
    
    context "when pos(e3) is empty space in the attack path of only white pieces" do
      before(:each) do
        #@board.display      #uncomment to show setup
      end
      it "is under attack from white" do
        expect(@board).to be_under_attack_from_color(ChessHelper::WHITE, "e3")
      end

      it "is not under attack from black" do
        expect(@board).not_to be_under_attack_from_color(ChessHelper::BLACK, "e3")
      end
    end
    
    context "when pos(e6) is empty space in the attack path of only black pieces" do
      before(:each) do
        #@board.display      #uncomment to show setup
      end

      it "is under attack from black" do
        expect(@board).to be_under_attack_from_color(ChessHelper::BLACK, "e6")
      end

      it "is not under attack from white" do
        expect(@board).not_to be_under_attack_from_color(ChessHelper::WHITE, "e6")
      end
    end
    
    context "when pos(f2) refers to white piece in the attack path of white and black pieces" do
      before(:each) do
        b_queen = @board["d8"]
        allow(b_queen).to receive(:valid_move?).and_return(true)
        @board.move_piece("d8", "f3")
        #@board.display      #uncomment to show setup
      end

      it "is under attack from black" do
        expect(@board).to be_under_attack_from_color(ChessHelper::BLACK, "f2")
      end

      it "is not under attack from white" do
        expect(@board).not_to be_under_attack_from_color(ChessHelper::WHITE, "f2")
      end
    end
    
    context "when pos(f7) refers to black piece in the attack path of white and black pieces" do
      before(:each) do
        w_queen = @board["d1"]
        allow(w_queen).to receive(:valid_move?).and_return(true)
        @board.move_piece("d1", "f6")
        #@board.display      #uncomment to show setup
      end

      it "is under attack from white" do
        expect(@board).to be_under_attack_from_color(ChessHelper::WHITE, "f7")
      end

      it "is not under attack from black" do
        expect(@board).not_to be_under_attack_from_color(ChessHelper::BLACK, "f7")
      end
    end
  end

  describe "#in_checkmate?" do
    context "when white has been checkmated" do
      it "returns true (Fool's mate)" do
        @board = board_with_moves("f2f3 e7e6 g2g4 d8h4", false)
        #@board.display
        expect(@board).to be_in_checkmate(ChessHelper::WHITE)
      end
    end

    context "when only in check" do
      it "returns false" do
        @board = board_with_moves("f2f3 e7e6 a2a4 d8h4", false)
        #@board.display
        expect(@board).not_to be_in_checkmate(ChessHelper::WHITE)
      end
    end
  end

  describe "#in_stalemate?" do
    before(:each) do
      @board = Board.new
    end

    context "when not in stalemate" do
      it "returns false" do
        @board.set_up_new_board
        expect(@board).not_to be_in_stalemate(ChessHelper::WHITE)
      end

      it "returns false" do
        @board.set_up_new_board
        expect(@board).not_to be_in_stalemate(ChessHelper::BLACK)
      end

      context "if in check" do
        it "returns false" do
          @board = board_with_moves("f2f3 e7e6 a2a4 d8h4")
          #@board.display
          expect(@board).not_to be_in_stalemate(ChessHelper::WHITE)
        end
      end

      context "if in checkmate" do
        it "returns false (Fool's mate)" do
          @board = board_with_moves("f2f3 e7e6 g2g4 d8h4")
          #@board.display
          expect(@board).not_to be_in_stalemate(ChessHelper::WHITE)
        end
      end
    end

    before(:each) do
      @board = Board.new
    end

    context "when in stalemate" do
      it "returns true" do
        @board.add_new_piece(King, "f8", ChessHelper::BLACK)
        @board.add_new_piece(Pawn, "f7", ChessHelper::WHITE)
        @board.add_new_piece(King, "f6", ChessHelper::WHITE)
        #@board.display    #uncomment to show setup
        expect(@board).to be_in_stalemate(ChessHelper::BLACK)
      end

      it "returns true" do
        @board.add_new_piece(King, "a8", ChessHelper::BLACK)
        @board.add_new_piece(Bishop, "b8", ChessHelper::BLACK)
        @board.add_new_piece(King, "b6", ChessHelper::WHITE)
        @board.add_new_piece(Rook, "h8", ChessHelper::WHITE)
        #@board.display    #uncomment to show setup
        expect(@board).to be_in_stalemate(ChessHelper::BLACK)
      end

      it "returns true" do
        @board.add_new_piece(King, "a1", ChessHelper::BLACK)
        @board.add_new_piece(Rook, "b2", ChessHelper::WHITE)
        @board.add_new_piece(King, "c3", ChessHelper::WHITE)
        #@board.display    #uncomment to show setup
        expect(@board).to be_in_stalemate(ChessHelper::BLACK)
      end
    end
  end
end
