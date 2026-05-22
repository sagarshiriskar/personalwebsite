# frozen_string_literal: true

require "fastimage"

module Jekyll
  module MediaDimensionsFilter
    def media_dimensions(path)
      return nil unless path.is_a?(String) && !path.empty?

      site = @context.registers[:site]
      relative = path.start_with?("/") ? path[1..] : path
      full_path = File.join(site.source, relative)
      return nil unless File.file?(full_path)

      width, height = FastImage.size(full_path)
      return nil unless width && height

      { "width" => width, "height" => height }
    end
  end
end

Liquid::Template.register_filter(Jekyll::MediaDimensionsFilter)
