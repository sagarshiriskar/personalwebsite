# Homepage work list and preview

On desktop, the homepage (`index.html`) shows a scrollable project list on the left and a large preview image on the right. Moving the mouse over a project updates the preview. The JavaScript in `index.html` handles hover swaps and **preloads** images in the background so hovers feel instant after the first visit (or after preload finishes).

Layout and styling live in `assets/css/style.css` under `#main:has(#works-preview)`. On mobile, the right preview is hidden and each row shows a small thumbnail instead.

---

## What the page outputs (before JavaScript runs)

Jekyll builds the list from ordered works (`_includes/ordered_works.liquid`). For each non-draft project:

- Each `<li>` has a **`hero-url`** attribute with that work’s **`listing_image`** path (for example `/assets/img/works/.../photo.jpg`), or `-` if there is no image.
- The first work that has a `listing_image` is also used in a small `<style>` block to set the **initial** background image on `#works-preview`.

Image paths always start with `/`. They are root-relative: the browser loads them from whatever domain the site is on. They are **not** tied to a specific hostname in config.

The preview panel itself is an empty `<div id="works-preview">`. The visible image is always a CSS `background-image`, not an `<img>` tag.

---

## What the JavaScript is for

Without preloading, changing `background-image` on hover starts a new download each time. The right side can stay blank for a moment while the file loads.

The script does two jobs:

1. **Preload** — Download listing images in the background and store them in the browser cache.
2. **Hover** — When the user moves the mouse over a project row, point the preview panel at that project’s image URL.

Preloading does **not** change what the user sees by itself. It only warms the cache. The preview only updates on hover.

---

## How the script is structured

All of the code runs inside an immediately invoked function `(function() { ... })();`. That keeps variables like `preview` and `works_list` private so they do not become global page variables.

On load, the script finds:

- **`preview`** — The `#works-preview` element (right-hand panel).
- **`works_list`** — Every `<li>` in the project list.

---

## Preloading step by step

### The `preload(url)` helper

For each URL, the script creates a temporary `Image` object in memory, sets its `src` to the URL, and waits until the browser finishes loading (or fails).

- The image is never inserted into the page, so nothing flickers on screen.
- Setting `src` triggers the same kind of download as a normal `<img>`.
- Once loaded, the browser can reuse that file from cache when the same URL is used as a `background-image` on hover.

If one image fails, the script still continues (both success and error resolve the promise).

### Building the URL list

A first loop walks every list row and reads `hero-url`:

- Rows with `-` or no URL are skipped.
- Duplicate URLs are skipped (two projects can share the same `listing_image`).

The result is an ordered array of unique image paths, in list order.

### Download order

1. **First image** — `preload(first)` runs alone. This matches the image already shown in CSS when the page opens. Waiting for it avoids competing with the initial paint for bandwidth.

2. **All other images** — When the first preload finishes, `rest.forEach(...)` calls `preload(url)` for every remaining URL. That loop starts **many downloads in parallel**, not strictly one-after-another. We only *wait* for the first image before starting the rest.

There is no visible “slideshow” during preload. The user still sees only the first project’s image until they hover something else.

### When hover feels instant

- **First project** — Should already be visible from the inline CSS on `#works-preview`.
- **Any project** — Hover is instant only if that URL was already preloaded and cached. On a slow connection, hovering before preload finishes can still show a short delay.

Return visits often feel instant everywhere because the browser still has the files cached.

---

## Hover behavior

A second loop attaches a `mouseover` listener to each list row.

When the pointer enters a row:

1. Read `hero-url` from that `<li>`.
2. If it is a real path (not `-`), set `preview.style.backgroundImage` to that URL.
3. Remove an `active` class from all rows and add it to the current row (for possible styling; list row highlight on desktop is mainly driven by CSS `:hover` on the link).

There is no `mouseout` handler. The preview **stays** on the last hovered project until the user hovers another row.

---

## How this fits with CSS

| Viewport | List | Preview panel |
|----------|------|----------------|
| Desktop (≥ 768px) | Left half, scrollable; row thumbnails hidden | Fixed right half, `background-size: cover` |
| Mobile (< 768px) | Full width; small `.img` thumbnail per row | `#works-preview` hidden; hover script has no visible effect |

The script still runs on mobile; it simply has nothing to show on the right.

---

## Where to change things

| Goal | Where |
|------|--------|
| Which image each project uses on the homepage | `listing_image` in each `_works/*.md` file |
| List order | `_data/works_order.yml` (see [works-order.md](works-order.md)) |
| Split layout, preview size, borders | `assets/css/style.css` — `#main:has(#works-preview)` |
| Preload timing, hover events, cache behavior | `<script>` in `index.html` |
| Initial image on load | Jekyll loop + `<style>` block in `index.html` (first work with `listing_image`) |

---

## Related docs

- [work-page-gallery.md](work-page-gallery.md) — `listing_image` vs gallery images on work pages
- [works-order.md](works-order.md) — Homepage list order
