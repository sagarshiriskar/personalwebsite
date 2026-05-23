# Work page YouTube embeds

Work pages can include YouTube videos in the **hero** or **gallery**. Each item uses `type: youtube` and a separate **`youtube_url`** field (images and videos still use **`src`** with the file picker in Pages CMS).

For gallery layout and `position` values, see [work-page-gallery.md](work-page-gallery.md).

---

## Adding a video in Pages CMS

1. Open a work in Pages CMS.
2. In **Hero** or **Gallery**, add an item and set **Media type** to **YouTube**.
3. Paste a link into **YouTube URL** — not into **File** (`src`).

**Good examples:**

- `https://youtu.be/9kzE8isXlQY`
- `https://www.youtube.com/watch?v=9kzE8isXlQY`
- `9kzE8isXlQY` (11-character ID only)

**Avoid:**

- Pasting a watch URL whose `v=` is *another* full YouTube link, e.g. `watch?v=https://youtu.be/…` — the site will try to fix this, but paste a direct link when you can.

Optional **`alt`** is used as the iframe `title` for accessibility (and as the default title if you leave it empty).

---

## Example front matter

```yaml
gallery:
  - type: youtube
    youtube_url: "https://youtu.be/9kzE8isXlQY"
    alt: Documentation video
    position: full
```

---

## How it is built (at `jekyll build`)

```text
youtube_url in _works/*.md
  → youtube_id filter (_plugins/youtube_id.rb)  →  11-character video ID
  → work_media.liquid (_includes/work_media.liquid)  →  HTML in _site/
```

### Files

| File | Role |
|------|------|
| `_plugins/youtube_id.rb` | Liquid filter `youtube_id` — turns a URL or ID into `dQw4w9WgXcQ`-style ID |
| `_includes/work_media.liquid` | Renders the iframe, fallback link, and embed URL |
| `assets/css/style.css` | `.youtube_embed` 16∶9 wrapper; gallery rules do not treat it like an image |
| `_data/seo.yml` | `url` — used for the production `origin` parameter (see below) |

---

## The `youtube_id` filter

Editors paste links in many shapes. The player only needs the **video ID** (usually 11 characters).

The filter accepts:

- `https://www.youtube.com/watch?v=…`
- `https://youtu.be/…`
- `https://www.youtube.com/embed/…`, `/shorts/…`, `/live/…`
- A bare ID: `9kzE8isXlQY`

If the stored value is a nested URL (e.g. `watch?v=https://youtu.be/…`), the filter unwraps it up to three times and only keeps a valid ID. If it cannot find one, nothing is rendered (no broken iframe).

---

## What `yt_src` is

In `work_media.liquid`, **`yt_src`** is a Liquid variable: the full **iframe `src` URL**, built at build time.

**Step 1 — base embed URL:**

```liquid
{% capture yt_src %}https://www.youtube.com/embed/{{ yt_id }}{% endcapture %}
```

Example: `https://www.youtube.com/embed/9kzE8isXlQY`

**Step 2 — production only — append `origin`:**

```liquid
{% if jekyll.environment == 'production' and site.data.seo.url != '' and site.data.seo.url != nil %}
  {% capture yt_src %}{{ yt_src }}?origin={{ site.data.seo.url | uri_escape }}{% endcapture %}
{% endif %}
```

Example: `https://www.youtube.com/embed/9kzE8isXlQY?origin=https%3A%2F%2Fwww.sagarshiriskar.com`

The iframe then uses `src="{{ yt_src }}"`.

---

## The `origin` parameter (production only)

On the **live site**, the embed URL includes `?origin=…` with your site URL from **`_data/seo.yml`** (`url`, currently `https://www.sagarshiriskar.com`).

**What it does:** Tells YouTube which site is embedding the video. [Google’s iframe API docs](https://developers.google.com/youtube/iframe_api_reference) recommend setting `origin` to your site’s scheme and domain for security and fewer embed issues on the real domain.

**Why production only:** During `jekyll serve`, `jekyll.environment` is `development`. The `origin` line is skipped so localhost is not given the production domain (which could confuse YouTube when you preview at `http://127.0.0.1:4000`).

| Environment | `origin` in embed URL |
|-------------|------------------------|
| `jekyll serve` (local) | No |
| `jekyll build` / GitHub Pages (production) | Yes — from `seo.url` |

`uri_escape` encodes the URL for the query string (`:` → `%3A`, etc.).

---

## Other iframe details

- **`referrerpolicy="strict-origin-when-cross-origin"`** — Sends enough referrer information for YouTube’s embed requirements without leaking the full page path.
- **No `loading="lazy"`** — The iframe loads with the page so behavior is consistent on refresh (gallery is often below the fold).
- **“Watch on YouTube”** — A fallback link under the player uses `youtube_url` when it is already a full `http(s)` link; otherwise it builds `https://www.youtube.com/watch?v={{ yt_id }}`.

---

## Troubleshooting

| Symptom | Things to check |
|--------|------------------|
| No embed at all | `youtube_url` empty or not a valid YouTube link; restart `jekyll serve` after changing `_plugins/` |
| “Watch on YouTube” goes to a broken URL | Re-save with a direct youtu.be or `watch?v=ID` link, not a double-wrapped URL |
| Works locally, odd on live (or the reverse) | Compare embed `src` in page source; production should include `?origin=` |
| Blocked or error on play | Browser privacy settings (not only ad blockers); try the fallback link; test on https://www.sagarshiriskar.com after deploy |
| uBlock / ad blockers | `youtube-nocookie.com` is often blocked; this site uses `youtube.com/embed` |

After changing plugins or `work_media.liquid`, restart `jekyll serve` and hard-refresh the browser.

---

## Related

- [work-page-gallery.md](work-page-gallery.md) — grid, `position`, `media_gap`, hero vs gallery
- [work-page-image-loading.md](work-page-image-loading.md) — image `width`/`height` and MP4 video placeholders
