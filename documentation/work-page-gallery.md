# Work pages and gallery

Work pages use **`_layouts/work.liquid`**. Optional **hero** (images/videos with `size`: 25, 50, 75, or 100) sits above the content. The **gallery** is a CSS grid: 2 columns on desktop, 1 on mobile. Each gallery item has a **`position`** that controls how the image sits in its cell and whether it spans the row:

| `position`   | Effect |
|-------------|--------|
| `full`      | Spans 2 columns; image fills the cell. |
| `center`    | Spans 2 columns; image centered at 75% width. |
| `half`      | Single cell; image centered, scaled to fit. |
| `top-left`, `top-right`, `bottom-left`, `bottom-right` | Image anchored to that corner of the cell (e.g. portrait in bottom-left sits with its bottom-left at the cell’s); margin on the opposite sides for spacing. |

Images stay inside each cell (`object-fit: contain`, max-width 100%). Build-time **`width`** / **`height`** on images and video placeholders prevent layout shift when media loads — see [work-page-image-loading.md](work-page-image-loading.md).

**`media_gap`** sets the grid gap and the extra margin on corner-placed images. Presets use **vw** (`none` = 0, `small` = 2vw, `medium` = 5vw, `large` = 10vw in **`_data/media_gap.yml`**; default **`medium`**). The work layout sets `--media-gap` on `.work_gallery`; styles live in **`assets/css/style.css`**. With **`none`**, the grid has no gap and corner positions are centered like half-width items.

On viewports under 768px, the gallery uses **one column** (gap and margins are slightly reduced).

---

## Homepage work order

See [works-order.md](works-order.md). For the desktop hover preview and preload behavior, see [homepage-work-preview.md](homepage-work-preview.md).

---

## Work layout front matter

Editable in Pages CMS under each work (template **`work`**, set automatically):

- **`title`**, **`description`**, **`body`** — title, short text, and main rich-text content
- **`year`** — optional line in the meta block
- **`listing_image`** — preview on the homepage only (not on the work page itself); see [homepage-work-preview.md](homepage-work-preview.md)
- **`hero`** — optional top banner; each item is image or video with **`size`** 25, 50, 75, or 100 (% width)
- **`links`** — list of `{ name, href }` in the meta block
- **`logos`** — list of images (shown at 60px height)
- **`media_gap`** — gallery spacing preset: `none`, `small`, `medium`, `large` (default `medium`)
- **`gallery`** — list of images/videos; each item uses **`position`** only (no `size`). Default position in the CMS is **`half`**

**`size` on work hero and About page (`_data/info.yml` images):**

| `size` | Typical max width |
|--------|-------------------|
| 25     | 25%               |
| 50     | 50%               |
| 75     | 75%               |
| 100    | 100%              |

About page images use the same size values via `about.html` and `.info_image.media_*` in CSS. Hero widths on small screens may differ slightly from desktop.
