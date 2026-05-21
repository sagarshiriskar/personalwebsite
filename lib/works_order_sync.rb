# frozen_string_literal: true

require "fileutils"
require "yaml"

# Keeps _data/works_order.yml in sync with _works/*.md (collection file basenames).
# Safe to run on Netlify before `jekyll build` and in CI to commit updates for Pages CMS.
module WorksOrderSync
  WORKS_ORDER_FILE = "_data/works_order.yml"
  WORKS_GLOB = "_works/*.md"
  ORDER_KEY = "order"

  # @return [Array<String>] merged slug order after sync
  def self.run(root = Dir.pwd)
    Runner.new(root).run
  end

  class Runner
    def initialize(root)
      @root = File.expand_path(root)
    end

    # @return [Array<String>] merged slug order; writes YAML when it changed
    def run
      current_slugs = collect_work_slugs
      data_path = File.join(@root, WORKS_ORDER_FILE)
      existing_order = load_order(data_path)

      ordered_slugs = (existing_order & current_slugs) + (current_slugs - existing_order)
      write_order_file(data_path, ordered_slugs, existing_order)
      ordered_slugs
    end

    private

    # Permalink /:name/ uses the document file basename (not front matter `name`).
    def collect_work_slugs
      Dir.glob(File.join(@root, WORKS_GLOB))
         .map { |path| File.basename(path, ".md") }
         .uniq
    end

    def load_order(path)
      return [] unless File.file?(path)

      raw = YAML.safe_load_file(path, permitted_classes: [Symbol])
      list = raw.is_a?(Hash) ? raw[ORDER_KEY] : raw
      return [] unless list.is_a?(Array)

      list.filter_map { |e| e.is_a?(String) ? e : e["slug"] }
    end

    def write_order_file(path, ordered, previous_order)
      return false if previous_order == ordered

      FileUtils.mkdir_p(File.dirname(path))
      data = { ORDER_KEY => ordered.map { |s| { "slug" => s } } }
      File.write(path, data.to_yaml)
      true
    end
  end
end
