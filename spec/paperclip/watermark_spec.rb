require 'active_support/core_ext/object/blank'
require 'tempfile'
require 'paperclip'
require 'paperclip/watermark'
require 'paperclip/errors'
require 'paperclip/geometry'
require 'paperclip/geometry_detector_factory'
require 'paperclip/geometry_parser_factory'
require 'cocaine'

describe PaperclipWatermark::Watermark do
  let(:file) { File.new(File.expand_path('../../support/dummy.jpg', __FILE__)) }
  let(:watermark_path) { File.new(File.expand_path('../../support/logo.png', __FILE__)) }
  let(:position) { 'Center' }
  let(:watermark_distance_from_top) { nil }
  let(:options) do
    {
      watermark_path: watermark_path,
      watermark_position: position,
      watermark_distance_from_top: watermark_distance_from_top
    }
  end

  subject{ described_class.new(file, options) }

  describe "#make" do
    let(:composition_options) { 'composition_options' }

    before do
      allow(subject).to receive(:composition_options).and_return(composition_options)
    end

    it "applies a scaled watermark" do
      expect(Paperclip).to receive(:run).with('composite', composition_options)
      subject.make
    end
  end

  describe "#composition_options" do
    let(:destination) { 'destination' }
    let(:watermark_command) { 'watermark_command' }

    before do
      allow(subject).to receive(:watermark_command).and_return(watermark_command)
    end

    it "returns the right command" do
      command = subject.composition_options(destination)
      expected_command = "-dissolve 30% -quality 100 -gravity Center #{watermark_command} #{file.path} destination"
      expect(command).to eq(expected_command)
    end
  end

  describe "#watermark_command" do
    let(:watermark_path) { 'watermark_path' }
    before do
      allow(subject).to receive(:scaled_size_for_watermark).and_return(Paperclip::Geometry.new(100,100))
    end

    it "returns the right command" do
      expected_command = '\\( watermark_path -resize 100.0x100.0 \\)'
      expect(subject.watermark_command).to eq(expected_command)
    end
  end

  describe "#watermak_position" do
    let(:position) { 'Center' }

    context "with a position" do
      it "returns the gravity" do
        expect(subject.watermak_position).to eq('-gravity Center')
      end
    end

    context "without a position" do
      let(:position) { nil }
      let(:watermark_distance_from_top) { 80 }

      it "returns the geometry" do
        expect(subject.watermak_position).to eq('-geometry +10.0+208.0')
      end
    end
  end

  describe "#scaled_size_for_watermark" do
    it "returns the scaled size for the watermark" do
      result = subject.scaled_size_for_watermark
      expect(result.width).to eq(280)
      expect(result.height).to eq(40.0)
    end
  end
end
