# frozen_string_literal: true

require "cgi"
require "uri"

module Jekyll
  module YoutubeIdFilter
    # Accepts a YouTube watch/share/embed URL or an 11-character video ID.
    def youtube_id(input)
      id = extract_youtube_id(input)
      return nil unless id

      # CMS sometimes stores watch?v=<another full YouTube URL> — unwrap until we get the real ID.
      3.times do
        break unless id.match?(%r{\Ahttps?://}i)

        nested = extract_youtube_id(id)
        break unless nested

        id = nested
      end

      id.match?(/\A[\w-]{11}\z/) ? id : nil
    end

    def extract_youtube_id(input)
      return nil unless input.is_a?(String) && !input.strip.empty?

      value = input.strip
      return value if value.match?(/\A[\w-]{11}\z/)

      uri = URI.parse(value)
      return nil unless uri.is_a?(URI::HTTP) && uri.host

      host = uri.host.downcase.sub(/\Awww\./, "")
      path = uri.path.to_s

      case host
      when "youtu.be"
        path.delete_prefix("/").split("/").first
      when "youtube.com", "m.youtube.com", "music.youtube.com"
        if path == "/watch"
          query = CGI.parse(uri.query.to_s)
          query["v"]&.first
        elsif path.start_with?("/embed/", "/shorts/", "/live/", "/v/")
          path.split("/")[2]
        end
      end
    rescue URI::InvalidURIError
      nil
    end
  end
end

Liquid::Template.register_filter(Jekyll::YoutubeIdFilter)
