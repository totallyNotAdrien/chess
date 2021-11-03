require_relative "../lib/chess_helper.rb"

describe ChessHelper do
  describe "#grid_to_chess_coordinates" do
    let(:helper_class){ Class.new { extend ChessHelper }}

    context "when receiving [1,2]" do
      it "returns 'c7'" do
        expect(helper_class.grid_to_chess_coordinates([1,2])).to eql("c7")
      end
    end

    context "when receiving [5,7]" do
      it "returns 'h3'" do
        expect(helper_class.grid_to_chess_coordinates([5,7])).to eql("h3")
      end
    end

    context "when receiving [3,5]" do
      it "returns 'f5'" do
        expect(helper_class.grid_to_chess_coordinates([3,5])).to eql("f5")
      end
    end
  end


  describe "#chess_to_grid_coordinates" do
    let(:helper_class){ Class.new { extend ChessHelper }}

    context "when receiving 'c7'" do
      it "returns [1,2]" do
        expect(helper_class.chess_to_grid_coordinates("c7")).to eql([1,2])
      end
    end

    context "when receiving 'h3'" do
      it "returns [5,7]" do
        expect(helper_class.chess_to_grid_coordinates("h3")).to eql([5,7])
      end
    end

    context "when receiving 'f5'" do
      it "returns [3,5]" do
        expect(helper_class.chess_to_grid_coordinates("f5")).to eql([3,5])
      end
    end
  end

  describe "#in_grid_coords?" do
    context "when pos = [2,4]" do
      let(:helper_class){ Class.new { extend ChessHelper }}
      it "returns true" do
        expect(helper_class).to be_in_grid_coords([2,4])
      end
    end

    context "when pos = 'e6'" do
      let(:helper_class){ Class.new { extend ChessHelper }}
      it "returns false" do
        expect(helper_class).not_to be_in_grid_coords('e6')
      end
    end

    context "when pos = [2,4,3,3]" do
      let(:helper_class){ Class.new { extend ChessHelper }}
      it "returns false" do
        expect(helper_class).not_to be_in_grid_coords([2,4,3,3])
      end
    end

    context "when pos = ['2',4]" do
      let(:helper_class){ Class.new { extend ChessHelper }}
      it "returns false" do
        expect(helper_class).not_to be_in_grid_coords(['2',4])
      end
    end

    context "when pos = [2,8]" do
      let(:helper_class){ Class.new { extend ChessHelper }}
      it "returns false" do
        expect(helper_class).not_to be_in_grid_coords([2,8])
      end
    end
  end

end