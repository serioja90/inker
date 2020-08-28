RSpec.describe String do
  it { is_expected.to respond_to :to_color }

  describe "#to_color" do
    let(:color_str){ "#4a148c" }
    subject(:color){ color_str.to_color }

    it { is_expected.to be_a Inker::Color }
    it { is_expected.to eq(Inker.color(color_str)) }
  end
end
