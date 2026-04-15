# Documentation

## Work page and gallery

Work pages use **`_layouts/work.liquid`**. Optional **hero** (images/videos with `size`: 25, 50, 75, or 100) sits above the content. The **gallery** is a CSS grid: 2 columns on desktop, 1 on mobile. Each gallery item has a **`position`** that controls how the image sits in its cell and whether it spans the row:

| `position`   | Effect |
|-------------|--------|
| `full`      | Spans 2 columns; image fills the cell. |
| `center`    | Spans 2 columns; image centered at 75% width. |
| `half`      | Single cell; image centered, scaled to fit. |
| `top-left`, `top-right`, `bottom-left`, `bottom-right` | Image anchored to that corner of the cell (e.g. portrait in bottom-left sits with its bottom-left at the cell’s); margin on the opposite sides for spacing. |

Images never overflow the cell; they scale down to fit. **`media_gap`** (work-level front matter) sets the gap between grid cells and the margin around positioned images. Uses **vw** so spacing stays balanced on all viewports. Options: **`none`**, **`small`**, **`medium`**, **`large`** (values in **`_data/media_gap.yml`**; default `medium`). CMS options in `.pages.yml`; layout reads `site.data.media_gap[page.media_gap]` and sets `--media-gap` on `.work_gallery`; styles in `assets/css/style.css` (`.work_gallery`, `.gallery_cell`, `.position_*`).

---

## Works order (plugin)

The order of works on the homepage is controlled by **`_data/works_order.yml`** (e.g. reorder via Pages CMS).

The Jekyll plugin **`_plugins/works_order_generator.rb`**:

1. Reads `_data/works_order.yml` and merges with the works collection (keeps order, appends new works, drops removed slugs).
2. Injects **`site.data.works_order`** (slugs) and **`site.data.ordered_works`** (full documents) at build time.
3. Writes back to `_data/works_order.yml` only when the order actually changes (avoids watch loops).

Templates use **`site.data.ordered_works`**, falling back to **`site.works`** if the plugin isn’t loaded.

---

## Work layout front matter

- **`listing_image`**: Used only on the home page (works list). **`hero`**: Optional block on the work page (images/videos with `size`: 25, 50, 75, 100).
- **`links`**: List of `{ name, href }` in the meta block.
- **`logos`**: List of images (fixed height in CSS).
- **`media_gap`**: Gallery spacing (viewport-relative). Preset name: `none`, `small`, `medium`, or `large`; default `medium`. Preset → CSS value is defined in **`_data/media_gap.yml`**.
- **`gallery`**: List of images/videos; each has **`position`** (`full`, `center`, `half`, `top-left`, `top-right`, `bottom-left`, `bottom-right`). Hero items use **`size`** only (see table below).

**Hero (and `_data/info.yml` images) — `size`:**

| `size` | Max width |
|--------|-----------|
| 25     | 25%       |
| 50     | 50%       |
| 75     | 75%       |
| 100    | 100%      |
