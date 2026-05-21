# frozen_string_literal: true

require_relative "../lib/works_order_sync"

# Local dev: sync YAML and inject ordered_works for templates.
# Netlify/CI: scripts/sync_works_order.rb runs before jekyll build; templates also use
# _includes/ordered_works.liquid when this plugin does not run.
module Jekyll
  class WorksOrderGenerator < Generator
    safe true
    priority :normal

    def generate(site)
      ordered_slugs = WorksOrderSync.run(site.source)

      docs = site.collections["works"]&.docs || []
      slug_to_doc = docs.map { |doc| [slug_from_doc(doc), doc] }.to_h
      ordered_docs = ordered_slugs.filter_map { |slug| slug_to_doc[slug] }

      site.data["works_order"] = ordered_slugs
      site.data["ordered_works"] = ordered_docs
    end

    private

    def slug_from_doc(doc)
      return nil if doc.url.nil? || doc.url.empty?
      doc.url.sub(%r{\A/}, "").sub(%r{/\z}, "")
    end
  end
end
