require "paperclip/processor"

module Paperclip
  class Watermark < Paperclip::Processor

    def initialize(file, options = {}, attachment = nil)
      super
      @file              = file
      @whiny             = options.fetch(:whiny, true)
      @watermark_path    = options[:watermark_path]
      @dissolve          = options.fetch(:watermark_dissolve, 30)
      @position          = options[:watermark_position]
      @distance_from_top = options[:watermark_distance_from_top]

      raise Paperclip::Error.new('Position or distance from top required') if @position.nil? && @distance_from_top.nil?
      raise Paperclip::Error.new('Missing watermark path') if @watermark_path.nil?
    end

    def make
      destination = Tempfile.new([file_basename, current_format ? ".#{current_format}" : ''])
      destination.binmode

      Paperclip.run('composite', composition_options(destination.path))
      destination
      rescue Paperclip::Errors::CommandNotFoundError
        raise Paperclip::Errors::CommandNotFoundError, "There was an error processing the watermark for #{@file.path}" if @whiny
    end

    def composition_options(destination_path)
      options = []
      options << "-dissolve #{@dissolve}%"
      options << '-quality 100'
      options << watermak_position
      options << watermark_command
      options << @file.path
      options << destination_path
      options.join(' ')
    end

    def watermak_position
      if @position
        "-gravity #{@position}"
      else
        "-geometry +#{calculated_watermak_position.first}+#{calculated_watermak_position.last}"
      end
    end

    def watermark_command
      options = []
      options << '\\('
      options << @watermark_path
      options << '-resize'
      options << "#{scaled_size_for_watermark.width}x#{scaled_size_for_watermark.height}"
      options << '\\)'
      options.join(' ')
    end

    def scaled_size_for_watermark
      destination_width = file_size.width - 20
      calculated_height = watermark_size.height.to_f / watermark_size.width.to_f * destination_width.to_f
      Paperclip::Geometry.new(destination_width, calculated_height.to_i)
    end

    private

    def watermark_size
      @watermark_size ||= Paperclip::Geometry.from_file(@watermark_path)
    end

    def file_size
      @file_size ||= Paperclip::Geometry.from_file(@file.path)
    end

    def file_basename
      File.basename(@file.path, current_format)
    end

    def current_format
      File.extname(@file.path)
    end

    def calculated_watermak_position
      top = ((file_size.height - scaled_size_for_watermark.height)/100) * @distance_from_top
      left = (file_size.width - scaled_size_for_watermark.width)/2
      [left, top]
    end
  end
end
