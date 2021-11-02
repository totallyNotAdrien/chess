require_relative "../lib/board.rb"
describe Board do
  describe "#setup_new_board" do
    matcher :have_correct_first_rank_classes do
      match do |actual|
        first_rank_classes = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
        row.length == 8 && 
        actual.all
      end
    end
  end
end