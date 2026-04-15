# Jekyll Boilerplate 2026 (Pages CMS)

A minimal Jekyll site with content in YAML data files and optional editing via [Pages CMS](https://pagescms.org/). Use it as a starting point for any static site.

## Quick start

```bash
bundle install
bundle exec jekyll serve
```

Open `http://localhost:4000`. The root `/` is the homepage; `/blog`, `/works`, `/impressum`, and `/privacy` are the main pages. If you change `_config.yml` (e.g. collections), restart the server for changes to apply.

---

## Project structure

```
├── _config.yml          # Jekyll config (collections, etc.)
├── _data/               # Editable content (YAML), editable via Pages CMS
│   ├── company.yml
│   ├── footer.yml
│   ├── nav.yml
│   └── seo.yml          # url, title, description, image (OG/twitter)
├── _includes/
│   ├── footer.html      # Footer (uses footer.yml)
│   ├── head.html        # Meta, SEO, CSS, OG/twitter image
│   └── nav.html         # Site title + nav links (from nav.yml)
├── _layouts/
│   ├── default.html     # Wrapper: head, nav, main, footer
│   ├── index.liquid     # Homepage (data dump + blog/works lists)
│   ├── blog.liquid      # Blog index
│   ├── works.liquid     # Works index
│   └── article.liquid   # Terms, privacy, work detail, etc.
├── _posts/              # Blog posts
├── _works/              # Works collection (output: true, permalink: /:name/)
├── index.html           # Homepage
├── blog.md              # Blog index → /blog/
├── works.md             # Works index → /works/
├── impressum.md         # Impressum (markdown body)
├── privacy.md           # Privacy (markdown body)
├── 404.html
├── assets/
│   ├── css/style.css
│   └── img/meta/        # favicon, og
└── .pages.yml           # Pages CMS schema (edits _data/*.yml)
```

---

## Content

- **Data:** Editable text lives in `_data/*.yml`. Layouts and includes use `site.data` (e.g. `site.data.seo.title`, `site.data.company.company`). The site URL and OG image path are in `seo.yml`; nav links come from `nav.yml` and are rendered in `nav.html`. Keep HTML in `_layouts/` and `_includes/`; pages use front matter and, where needed, markdown in the body.
- **Blog:** Posts go in `_posts/` with standard Jekyll front matter. The sample post uses `permalink: /blog/draft-post/` so posts live under `/blog/`. The blog index is at `/blog/`.
- **Works:** The `works` collection lives in `_works/`. Each document has front matter (e.g. `title`, `description`, `listing_image`) and markdown body; they are output with `permalink: /:name/`. The homepage lists works in the order defined in `_data/works_order.yml`. Reorder works by editing that file (e.g. drag-and-drop in Pages CMS under “Works order”). New works are appended to the order on each build; the `_plugins/works_order_generator.rb` plugin keeps the file in sync.
- **Impressum & privacy:** Plain markdown pages (`impressum.md`, `privacy.md`); edit their content in those files. Privacy can still use `site.data.company` for company/address.

## Pages CMS

`.pages.yml` defines how Pages CMS edits content. You can edit:

- **Data files:** `_data/company.yml`, `_data/seo.yml`, `_data/nav.yml`, `_data/footer.yml`.
- **Markdown pages:** Impressum (`impressum.md`), Privacy (`privacy.md`), and the Blog and Works index pages (`blog.md`, `works.md`). For these, the main content is the **body** field (rich-text); front matter (layout, title) is edited in the same form.
- **Collections:** Posts (`_posts/`) and Works (`_works/`). Each post has date, title, permalink, and body; each work has a URL slug (name), title, description, hero image, and body.

With `settings.content.merge: true`, the CMS merges your edits into existing files instead of overwriting them, which helps preserve Liquid (e.g. `{{ site.data.company.company }}` in privacy) or other content you don’t expose in the schema.

### Tips for a good .pages.yml

- **Media as a list:** Use the array form for `media` (a `-` before each entry) so multiple media folders are supported and the schema stays clear. Each entry needs `name`, `label`, `input`, `output`, and optionally `path`.
- **Lists of objects (nav, footer):** Use a single field with `type: object` and `list: true`. The field name (e.g. `links`) becomes the key in the YAML file, so the data file has that key wrapping the array. Use the same field names for similar lists (e.g. `label` and `href` for both nav and footer) so templates stay consistent.
- **Collapsible list with summary:** For list fields, use `list:` as an object with `collapsible.summary` so the CMS shows a meaningful label per item instead of "Item #1", "Item #2". Example:
  ```yaml
  - name: links
    label: Nav links
    type: object
    list:
      collapsible:
        collapsed: true
        summary: "{fields.label}"
    fields:
      - { name: label, label: Label, type: string }
      - { name: href, label: Link, type: string }
  ```
  The summary template can use `{fields.fieldName}` for any field in the list item (e.g. `{fields.label}` or `{fields.title}`).
- **Data files as canon:** Prefer updating `.pages.yml` to match your `_data/*.yml` structure (e.g. root-level list → use a wrapper key and `links` in the schema) rather than changing the data file shape to fit a default schema.

---

## Meta assets

Place these under `assets/img/meta/`:

- **favicon** — Browser tab icon.
- **og** — Social sharing image (e.g. 1200×630). Set `image` in `_data/seo.yml` to `/assets/img/meta/og.jpg`; `url` in the same file is used to build absolute OG/twitter image URLs.

---

## License

Use and adapt as you like.
