# Joyful Notes Children's Choir · 天赐之音儿童合唱团

Website for Joyful Notes Children's Choir, served by GitHub Pages at https://www.joyfulnotescc.org.

Migrated from the original Google Site. The whole site is a single static `index.html` (styled to match the Zhi Yin Choir website) — edit it directly and push to `main` to publish.

## Performance galleries from Google Drive

The performance galleries can be loaded from Google Drive, so new events and photos appear without code changes:

1. Create a parent folder in Google Drive with one sub-folder per event, named `YYYY-MM-DD Event title` (e.g. `2024-03-17 Performance at MRU Bella Concert Hall`). Folders without a date (e.g. `Weekly Practice`) are shown after the dated events. Folders whose name starts with `_` are never shown, so use that for working folders.
2. Share the parent folder as **Anyone with the link → Viewer**.
3. Create a Google Cloud API key with the Google Drive API enabled, restricted to the Drive API and to the website `https://www.joyfulnotescc.org/*`.
4. In `index.html`, fill in `DRIVE_CONFIG.apiKey` and `DRIVE_CONFIG.parentFolderId` (the ID at the end of the folder's URL).

Until this is configured, or if Drive cannot be reached, the built-in galleries (photos in `images/`) are shown.
