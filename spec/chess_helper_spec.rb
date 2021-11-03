require_relative "../lib/chess_helper.rb"

describe ChessHelper do
  describe "#grid_to_chess_coordinates" do
    let(:helper_class){ Class.new { extend ChessHelper }}

    context "when position = [1,2]" do
      it "returns 'c7'" do
        expect(helper_class.grid_to_chess_coordinates([1,2])).to eql("c7")
      end
    end

    context "when position = [5,7]" do
      it "returns 'h3'" do
        expect(helper_class.grid_to_chess_coordinates([5,7])).to eql("h3")
      end
    end

    context "when position = [3,5]" do
      it "returns 'f5'" do
        expect(helper_class.grid_to_chess_coordinates([3,5])).to eql("f5")
      end
    end

    context "when position = 'a5' (is not an array)" do
      it "returns nil" do
        expect(helper_class.grid_to_chess_coordinates('a5')).to be_nil
      end
    end

    context "when position = [3,5,4,6] (has too many values)" do
      it "returns nil" do
        expect(helper_class.grid_to_chess_coordinates([3,5,4,6])).to be_nil
      end
    end

    context "when position = [1,8] (value out of bounds)" do
      it "returns nil" do
        expect(helper_class.grid_to_chess_coordinates([1,8])).to be_nil
      end
    end
  end


  describe "#chess_to_grid_coordinates" do
    let(:helper_class){ Class.new { extend ChessHelper }}

    context "when position = 'c7'" do
      it "returns [1,2]" do
        expect(helper_class.chess_to_grid_coordinates("c7")).to eql([1,2])
      end
    end

    context "when position = 'c 7'" do
      it "returns [1,2]" do
        expect(helper_class.chess_to_grid_coordinates("c 7")).to eql([1,2])
      end
    end

    context "when position = 'h3'" do
      it "returns [5,7]" do
        expect(helper_class.chess_to_grid_coordinates("h3")).to eql([5,7])
      end
    end

    context "when position = 'f5'" do
      it "returns [3,5]" do
        expect(helper_class.chess_to_grid_coordinates("f5")).to eql([3,5])
      end
    end

    context "when position = [3,4]" do
      it "returns nil" do
        expect(helper_class.chess_to_grid_coordinates([3,4])).to be_nil
      end
    end

    context "when position = 'a9'" do
      it "returns nil" do
        expect(helper_class.chess_to_grid_coordinates('a9')).to be_nil
      end
    end

    context "when position = 'j7'" do
      it "returns nil" do
        expect(helper_class.chess_to_grid_coordinates('j7')).to be_nil
      end
    end

    context "when position = 'a13'" do
      it "returns nil" do
        expect(helper_class.chess_to_grid_coordinates('a13')).to be_nil
      end
    end
  end

  describe "#in_grid_coords?" do
    let(:helper_class){ Class.new { extend ChessHelper }}

    context "when pos = [2,4]" do
      it "returns true" do
        expect(helper_class).to be_in_grid_coords([2,4])
      end
    end

    context "when pos = 'e6'" do
      it "returns false" do
        expect(helper_class).not_to be_in_grid_coords('e6')
      end
    end

    context "when pos = [2,4,3,3]" do
      it "returns false" do
        expect(helper_class).not_to be_in_grid_coords([2,4,3,3])
      end
    end

    context "when pos = ['2',4]" do
      it "returns false" do
        expect(helper_class).not_to be_in_grid_coords(['2',4])
      end
    end

    context "when pos = [2,8]" do
      it "returns false" do
        expect(helper_class).not_to be_in_grid_coords([2,8])
      end
    end
  end

  describe "#in_chess_coords?" do
    let(:helper_class){ Class.new { extend ChessHelper }}

    context "when pos = 'b6'" do
      it "returns true" do
        expect(helper_class).to be_in_chess_coords("b6")
      end
    end

    context "when pos = ['b',6]" do
      it "returns false" do
        expect(helper_class).not_to be_in_chess_coords(['b',6])
      end
    end

    context "when pos = 'b16'" do
      it "returns false" do
        expect(helper_class).not_to be_in_chess_coords("b16")
      end
    end

    context "when pos = 'i4'" do
      it "returns false" do
        expect(helper_class).not_to be_in_chess_coords("i4")
      end
    end

    context "when pos = 'c9'" do
      it "returns false" do
        expect(helper_class).not_to be_in_chess_coords("c9")
      end
    end
  end

end