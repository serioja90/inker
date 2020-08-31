RSpec.describe Inker::Color do
  subject { Inker::Color }

  it { is_expected.to respond_to :brightness }
  it { is_expected.to respond_to :lightness }
  it { is_expected.to respond_to :saturation }
  it { is_expected.to respond_to :hue }
  it { is_expected.to respond_to :hsl_to_rgb }
  it { is_expected.to respond_to :is_hex? }
  it { is_expected.to respond_to :is_rgb? }
  it { is_expected.to respond_to :is_rgba? }
  it { is_expected.to respond_to :is_hsl? }
  it { is_expected.to respond_to :is_hsla? }
  it { is_expected.to respond_to :random }
  it { is_expected.to respond_to :from_rgb }
  it { is_expected.to respond_to :from_rgba }
  it { is_expected.to respond_to :from_hsl }
  it { is_expected.to respond_to :from_hsla }
  it { is_expected.to respond_to :from_custom_string }
  it { is_expected.to respond_to :parse_color }

  describe "#brightness" do
    it "is 0 for black" do
      expect(subject.brightness(0, 0, 0)).to eq(0)
    end

    it "is 139 for red" do
      expect(subject.brightness(255, 0, 0)).to eq(139)
    end

    it "is 195 for green" do
      expect(subject.brightness(0, 255, 0)).to eq(195)
    end

    it "is 86 for blue" do
      expect(subject.brightness(0, 0, 255)).to eq(86)
    end

    it "is 255 for white" do
      expect(subject.brightness(255, 255, 255)).to eq(255)
    end
  end

  describe "#lightness" do
    it "is 0 for black" do
      expect(subject.lightness(0, 0, 0)).to eq(0)
    end

    it "is 0.5 for red, green and blue" do
      expect(subject.lightness(255, 0, 0)).to eq(0.5)
      expect(subject.lightness(0, 255, 0)).to eq(0.5)
      expect(subject.lightness(0, 0, 255)).to eq(0.5)
    end

    it "is 1 for white" do
      expect(subject.lightness(255, 255, 255)).to eq(1)
    end
  end

  describe "#saturation" do
    it "is 0 for grayscale" do
      [0, 63, 127, 191, 255].each do |x|
        expect(subject.saturation(x, x, x)).to eq(0)
      end
    end

    it "is 1 for red, green and blue" do
      expect(subject.saturation(255, 0, 0)).to eq(1)
      expect(subject.saturation(0, 255, 0)).to eq(1)
      expect(subject.saturation(0, 0, 255)).to eq(1)
    end
  end

  describe "#hue" do
    it "is 0 for grayscale" do
      [0, 63, 127, 191, 255].each do |x|
        expect(subject.hue(x, x, x)).to eq(0)
      end
    end

    it "is 0 for red" do
      expect(subject.hue(255, 0, 0)).to eq(0)
    end

    it "is 120 for green" do
      expect(subject.hue(0, 255, 0)).to eq(120)
    end

    it "is 240 for blue" do
      expect(subject.hue(0, 0, 255)).to eq(240)
    end
  end

  describe "#hsl_to_rgb" do
    it "returns rgb(255, 255, 255) for hsl(0, 0%, 100%)" do
      expect(subject.hsl_to_rgb(0, 0, 1)).to eq({red: 255, green: 255, blue: 255})
    end

    it "returns rgb(0, 0, 0) for hsl(0, 0%, 0%)" do
      expect(subject.hsl_to_rgb(0, 0, 0)).to eq({red: 0, green: 0, blue: 0})
    end

    it "returns rgb(255, 0, 0) for hsl(0, 100%, 50%)" do
      expect(subject.hsl_to_rgb(0, 1, 0.5)).to eq({red: 255, green: 0, blue: 0})
    end

    it "returns rgb(0, 255, 0) for hsl(120, 100%, 50%)" do
      expect(subject.hsl_to_rgb(120, 1, 0.5)).to eq({red: 0, green: 255, blue: 0})
    end

    it "returns rgb(0, 0, 255) for hsl(240, 100%, 50%)" do
      expect(subject.hsl_to_rgb(240, 1, 0.5)).to eq({red: 0, green: 0, blue: 255})
    end
  end

  describe "#is_hex?" do
    shared_examples "valid HEX" do |value|
      it "is true for #{value.inspect}" do
        expect(subject.is_hex?(value)).to be true
      end
    end

    shared_examples "invalid HEX" do |value|
      it "is false for #{value.inspect}" do
        expect(subject.is_hex?(value)).to be false
      end
    end

    # Tests for valid values
    ["#000000", "#fff", "#0f0f0f99"].each do |value|
      include_examples "valid HEX", value
    end

    # Tests for invalid values
    [nil, "#", "#0", "#00", "#00ff", "#00ffa", "#00ffaa0", "#00ffaa00ff", "#ggg"].each do |value|
      include_examples "invalid HEX", value
    end
  end

  describe "#is_rgb?" do
    shared_examples "valid RGB" do |value|
      it "is true for #{value.inspect}" do
        expect(subject.is_rgb?(value)).to be true
      end
    end

    shared_examples "invalid RGB" do |value|
      it "is false for #{value.inspect}" do
        expect(subject.is_rgb?(value)).to be false
      end
    end

    # Tests for valid RGB values
    ["rgb(0,0,0)", "rgb(255, 255, 255)", "rgb( 0 , 255 , 0 )"].each do |value|
      include_examples "valid RGB", value
    end

    # Tests for invalid RGB values
    ["rgb(0,0,0,0)", "(255, 255, 255)", "rgba(0, 0, 0)", "rgba(0, 0, 0, 0)", "rgb 0 0 0", "rgb(0 0 0)"].each do |value|
      include_examples "invalid RGB", value
    end
  end

  describe "#is_rgba?" do
    shared_examples "valid RGBA" do |value|
      it "is true for #{value.inspect}" do
        expect(subject.is_rgba?(value)).to be true
      end
    end

    shared_examples "invalid RGBA" do |value|
      it "is false for #{value.inspect}" do
        expect(subject.is_rgba?(value)).to be false
      end
    end

    # Tests for valid RGB values
    ["rgba(0,0,0,0.5)", "rgba(255, 255, 255, 0)", "rgba( 0 , 255 , 0 , 1.0)"].each do |value|
      include_examples "valid RGBA", value
    end

    # Tests for invalid RGB values
    ["rgba(0,0,0)", "(255, 255, 255, 1)", "rgb(0, 0, 0)", "rgb(0, 0, 0, 0)", "rgba 0 0 0 0", "rgba(0 0 0)"].each do |value|
      include_examples "invalid RGBA", value
    end
  end

  describe "#is_hsl?"
  describe "#is_hsla?"
  describe "#random"
  describe "#from_rgb"
  describe "#from_rgba"
  describe "#from_hsl"
  describe "#from_hsla"
  describe "#from_custom_string"
  describe "#parse_color"

  describe "instance" do
    let(:color_str){ "#1b5e2099" }
    let(:hex6_str) { color_str[0..-3] }
    let(:rgb_str){ "rgb(27, 94, 32)" }
    let(:rgba_str) { "rgba(27, 94, 32, 0.6)" }
    let(:hsl_str) { "hsl(124, 55%, 24%)" }
    let(:hsla_str) { "hsl(124, 55%, 24%, 0.6)" }
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

    it "has a correct #to_s value" do
      expect(color.to_s).to eq(color_str)
    end

    it "has a correct #to_s(:hex6) value" do
      expect(color.to_s(:hex6)).to eq(color.hex6)
    end

    it "has a correct #to_s(:rgb) value" do
      expect(color.to_s(:rgb)).to eq(color.rgb)
    end

    it "has a correct #to_s(:rgba) value" do
      expect(color.to_s(:rgba)).to eq(color.rgba)
    end

    it "has a correct #to_s(:hsl) value" do
      expect(color.to_s(:hsl)).to eq(color.hsl)
    end

    it "has a correct #to_s(:hsla) value" do
      expect(color.to_s(:hsla)).to eq(color.hsla)
    end

    it "has a correct #hex value" do
      expect(color.hex).to eq(color_str)
    end

    it "has a correct #hex6 value" do
      expect(color.hex6).to eq(hex6_str)
    end

    it "has a correct #rgb value" do
      expect(color.rgb).to eq(rgb_str)
    end

    it "has a correct #rgba value" do
      expect(color.rgba).to eq(rgba_str)
    end

    it "has a correct #hsl value" do
      expect(color.hsl).to eq(hsl_str)
    end

    it "has a correct #hsla value" do
      expect(color.hsla).to eq(hsla_str)
    end
  end
end
