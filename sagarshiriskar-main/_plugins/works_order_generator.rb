# frozen_string_literal: true

# Ensures _data/works_order.yml exists and stays in sync with the works collection.
# - Reads existing order (from file or CMS edits); preserves user order.
# - Appends any new works (in collection but not in order) at the end.
# - Removes slugs that no longer exist in the collection.
# - Injects the merged order into site.data (works_order = slugs, ordered_works = docs).
# Users can reorder works by editing _data/works_order.yml (e.g. via Pages CMS drag-and-drop).
module Jekyll
  class WorksOrderGenerator < Generator
    safe true
    priority :normal

    WORKS_ORDER_FILE = "_data/works_order.yml"
    ORDER_KEY = "order"

    def generate(site)
      docs = site.collections["works"]&.docs || []
      current_slugs = docs.map { |doc| slug_from_doc(doc) }.compact.uniq

      data_path = File.join(site.source, WORKS_ORDER_FILE)
      existing_order = load_order(data_path)

      # Keep existing order but only for slugs that still exist; append new slugs at the end
      ordered_slugs = (existing_order & current_slugs) + (current_slugs - existing_order)

      # Build ordered list of document objects for templates (no slug lookup in Liquid)
      slug_to_doc = docs.map { |doc| [slug_from_doc(doc), doc] }.to_h
      ordered_docs = ordered_slugs.filter_map { |slug| slug_to_doc[slug] }

      inject_into_site(site, ordered_slugs, ordered_docs)
      # Only write file when order actually changed to avoid watch loop (write → change → rebuild → write → …)
      write_order_file(data_path, ordered_slugs, existing_order)
    end

    private

    def slug_from_doc(doc)
      return nil if doc.url.nil? || doc.url.empty?
      doc.url.sub(%r{\A/}, "").sub(%r{/\z}, "")
    end

    def load_order(path)
      return [] unless File.file?(path)
      raw = YAML.load_file(path)
      list = raw.is_a?(Hash) ? raw[ORDER_KEY] : raw
      return [] unless list.is_a?(Array)
      list.filter_map { |e| e.is_a?(String) ? e : e["slug"] }
    end

    def inject_into_site(site, ordered_slugs, ordered_docs)
      site.data["works_order"] = ordered_slugs
      site.data["ordered_works"] = ordered_docs
    end

    # Write as list of { slug: "..." } so Pages CMS can show one row per work and allow reordering.
    # Only writes when content changed to avoid jekyll serve --watch triggering an infinite rebuild loop.
    def write_order_file(path, ordered, previous_order)
      return if previous_order == ordered
      FileUtils.mkdir_p(File.dirname(path))
      data = { ORDER_KEY => ordered.map { |s| { "slug" => s } } }
      File.write(path, data.to_yaml)
    end
  end
end
