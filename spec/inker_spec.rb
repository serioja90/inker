RSpec.describe Inker do
  it "has a version number" do
    expect(Inker::VERSION).not_to be nil
  end

  it { is_expected.to respond_to :color }
  it { is_expected.to respond_to :named_colors }

  describe "#color" do
    let(:color_str) { "#311b92" }
    subject(:color){ Inker.color(color_str) }

    it { is_expected.to be_a Inker::Color }

    it "should be equal to input color" do
      expect(color.to_s).to eq(color_str)
    end
  end

  describe "#named_colors" do
    let(:example_colors){
      {
        "red"    => "#FF0000",
        "green"  => "#00FF00",
        "blue"   => "#0000FF",
        "white"  => "#FFFFFF",
        "black" => "#000000"
      }
    }
    subject(:named_colors){ Inker.named_colors }

    it { is_expected.to be_a Hash }
    it { is_expected.not_to be_empty }

    it "should contain named colors" do
      example_colors.each do |name, value|
        expect(named_colors[name]).to eq(value)
      end
    end
  end
end
