# File and folder names for images and videos

### A quick note on file and folder names

Browsers can be picky about certain characters in file names — they can cause images or videos to silently fail to load on the site. Here's a simple set of rules to keep everything working smoothly.

### The rules

Stick to:

- Letters and numbers (`a-z`, `0-9`)
- Hyphens
- Underscores `_`
- The file extension (`.jpg`, `.png`, `.mp4`)

**Spaces** are handled fine by modern browsers, but as a general habit it's safer to use a hyphen or underscore instead — some tools and URLs handle them less gracefully.

**Pipe characters** `|` are a different story — avoid these entirely, as they're reserved in URLs and can cause problems.

### Examples based on your files

| Instead of | Use |
| --- | --- |
| `katib-e-taqdeer_7. a customer sits and watches ghalib \| img_9481.jpg` | `katib-e-taqdeer_7-a-customer-sits-and-watches-ghalib-img_9481.jpg` |
| folder: `juhu beach` | folder: `juhu-beach` |
| `mannequin_4. img_4541.jpg` | `mannequin_4-img_4541.jpg` |

### Before uploading, quickly check that you have:

1. Replaced any spaces with hyphens (optional but recommended)
2. Removed any pipe `|` characters
3. Applied the same rules to folder names
4. If you rename a file that's already on the site, update its name in Pages CMS too — otherwise the link breaks

---

Example: These images were not loading because the file names had pipes `|`.

![CleanShot 2026-05-21 at 04.36.34@2x](images/CleanShot_2026-05-21_at_04.36.34@2x.png)

![CleanShot 2026-05-21 at 04.35.35@2x](images/CleanShot_2026-05-21_at_04.35.35@2x.png)
