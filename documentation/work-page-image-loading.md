# Work page images and layout shift

Hero, gallery, and logo images on work pages used to have no size until they loaded, so content below jumped. We fix that at **build time** by writing each image’s pixel `width` and `height` into the HTML. **Videos** use a CSS **16∶9** box instead (FastImage does not size MP4s reliably).

Gallery grid and `position` modes: [work-page-gallery.md](work-page-gallery.md).

---

## How it works

1. Jekyll build reads each image file under `assets/` and gets its dimensions (FastImage).
2. `_includes/work_media.liquid` outputs `<img width="…" height="…">` plus `src` and `alt`.
3. The visitor’s browser reserves space from that aspect ratio while CSS uses `width: 100%` and `height: auto` — before the file downloads.

No width/height in the CMS or work markdown; only `src` paths like `/assets/img/works/...`.

```text
_works/*.md  →  work.liquid  →  work_media.liquid  →  media_dimensions (FastImage)  →  _site/ HTML
```

---

## Files

| File | Role |
|------|------|
| `_plugins/media_dimensions.rb` | Liquid filter `media_dimensions` |
| `_includes/work_media.liquid` | One image or video tag |
| `_layouts/work.liquid` | Includes `work_media` for hero, gallery, logos |
| `assets/css/style.css` | Image sizing; video `aspect-ratio` |
| `Gemfile` | `fastimage` gem |

---

## FastImage

Ruby gem used **only at build time** — not in the browser. Reads the **file header** (JPEG, PNG, WebP, GIF, etc.) to return width and height without decoding the full image. Does not resize or optimize files. Returns `nil` if the file is missing or unsupported.

---

## `work_media` include

```liquid
{% include work_media.liquid media=media %}
```

Hero size class — do not use double quotes in `{% include %}`; use `capture`:

```liquid
{% capture hero_class %}media_{{ media.size }}{% endcapture %}
{% include work_media.liquid media=media class=hero_class %}
```

| Parameter | Purpose |
|-----------|---------|
| `media` | Front matter: `type`, `src`, optional `alt` |
| `class` | Optional (e.g. `media_50`) |

- **Image** (`type: image`, or omitted for logos) → `<img>` with `width`/`height` when FastImage succeeds.
- **Video** → `<video controls>`; no dimensions from FastImage.

**Covered:** hero, gallery, logos. **Not covered:** images in the markdown **body** (`markdownify`).

---

## Browser and CSS

`width`/`height` on the tag define the ratio; CSS scales to layout width. Hero `media_25` … `media_100` only cap max-width — ratio still comes from the attributes.

Videos: `aspect-ratio: 16 / 9` in `style.css` (approximate placeholder).

Gallery **full** / **center** (`media_gap_none`) images use `height: auto` instead of `height: 100%` so reserved `<img>` height is not collapsed before load.

---

## Edge cases and dev

- Missing or unreadable file → `<img>` without dimensions (may still shift).
- New/replaced assets → rebuild (`bundle exec jekyll build`) to refresh attributes.
- Check output: work page source should show `width` and `height` on gallery/hero `<img>` tags.
- Include error with `class="media_50"` → use `{% capture hero_class %}` as above.

---

## Related

- [work-page-gallery.md](work-page-gallery.md) — grid, `position`, `media_gap`
- [homepage-work-preview.md](homepage-work-preview.md) — homepage listing previews (separate)
