RSpec.describe Inker::Color do
  let(:color_str){ "#1b5e2099" }
  let(:red){ 27 }
  let(:green){ 94 }
  let(:blue){ 32 }
  let(:alpha){ 0.6 }
  let(:brightness){ 74 }
  let(:dark){ brightness < 128 }
  let(:lightness){ 0.2372549019607843 }
  let(:saturation){ 0.5537190082644627 }
  let(:hue){ 124 }
  subject(:color){ Inker::Color.new(color_str) }

  it { is_expected.to respond_to :red }
  it { is_expected.to respond_to :green }
  it { is_expected.to respond_to :blue }
  it { is_expected.to respond_to :alpha }
  it { is_expected.to respond_to :brightness }
  it { is_expected.to respond_to :lightness }
  it { is_expected.to respond_to :saturation }
  it { is_expected.to respond_to :hue }
  it { is_expected.to respond_to :dark? }
  it { is_expected.to respond_to :light? }
  it { is_expected.to respond_to :to_s }
  it { is_expected.to respond_to :hex }
  it { is_expected.to respond_to :hex6 }
  it { is_expected.to respond_to :rgb }
  it { is_expected.to respond_to :rgba }
  it { is_expected.to respond_to :hsl }
  it { is_expected.to respond_to :hsla }

  it "has a correct #red value" do
    expect(color.red).to eq(red)
  end

  it "has a correct #green value" do
    expect(color.green).to eq(green)
  end

  it "has a correct #blue value" do
    expect(color.blue).to eq(blue)
  end

  it "has a correct #blue value" do
    expect(color.blue).to eq(blue)
  end

  it "has a correct #brightness value" do
    expect(color.brightness).to eq(brightness)
  end

  it "has a correct #dark? value" do
    expect(color.dark?).to eq(dark)
  end

  it "has a correct #light? value" do
    expect(color.light?).to eq(!dark)
  end

  it "has a correct #lightness value" do
    expect(color.lightness).to eq(lightness)
  end

  it "has a correct #saturation value" do
    expect(color.saturation).to eq(saturation)
  end

  it "has a correct #hue value" do
    expect(color.hue).to eq(hue)
  end
end
