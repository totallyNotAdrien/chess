require_relative "../lib/chess.rb"

describe Chess do
  describe "#handle_input" do
    context "when Pawn reaches eighth rank" do
      before(:each) do
        moves = "h2h3 g7g5 h3h4 f8g7 h1h3 g7d4 e2e4 g8f6 f2f3 h8g8 a2a4 f6h5 g2g4 h5f4 c2c4 g8g6
        d1b3 g6a6 h4g5 h7h5 g5h6 a6h6 h3h6 b8c6 b3b5 f4g2 e1d1 e7e5 g4g5 d4g1 h6f6 a7a5
        g5g6 g1a7 g6g7 d8f6"
        @game = Chess.new(moves)
      end
      it "promotes pawn" do
        #@game.display_board    #uncomment to show setup
        allow(@game).to receive(:promote_pawn)
        expect(@game).to receive(:promote_pawn)
        @game.handle_input("g7g8")
      end

      context "if player promotes to Knight" do
        before(:each) do
          allow(@game).to receive(:gets).and_return("knight")
        end

        it "changes Pawn to a Knight" do
          board = @game.board
          allow(@game).to receive(:puts)
          allow(@game).to receive(:print)
          expect {@game.handle_input("g7g8")}.to change {board["g8"].class}.to(Knight)
        end
      end
    end
  end
end