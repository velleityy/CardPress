# CardPress — local business card imposition

A local browser app that converts Canva exports into **10 business cards per portrait A4 sheet (2 × 5)**. Supports identical copies, personalized cards from a CSV, trim marks, and interleaved front/back pages for duplex printing.

## Quick start (macOS / Windows / Linux)

1. Install Node.js 20.19+ (or 22.12+) if not installed.
2. Open Terminal in this folder and run:

   ```bash
   npm install
   npm run dev
   ```

3. Open the local URL printed in Terminal (normally **http://127.0.0.1:5173**).
4. Upload a Canva export for the front and optionally back. Use **PNG, JPG, or a single-page PDF** per side.
5. Choose **Identical** and quantity, or **Personalized** and upload a CSV.
6. Generate the A4 PDF. PDFs download into your browser's default download folder.

The web app is hosted only on 127.0.0.1 and files are processed in your browser. Dependencies are installed from npm, so internet is needed for first setup. Google Fonts can be skipped offline (the UI falls back to system fonts).

## Canva artwork

- Recommended finished card size: **90 × 50 mm**. Design in Canva at that physical size.
- Export front/back as **separate single-page PDF Print files**, or PNG/JPG. A PDF preserves vector design details when possible.
- Do **not** enable Canva's crop marks for each card export — this app adds sheet-level crop marks.
- The generator scales uploaded artwork to the chosen physical card width and height. **There is no automatic aspect-ratio cropping.** Ensure the uploaded artwork has the correct ratio.
- Crop marks indicate the actual **card boundary**, not a bleed border. Artwork extending to the trim line may leave a white sliver due to printer alignment or cutting tolerance. For production full-bleed work, commission bleed-aware imposition or use a commercial printer.

## Personalized cards

One CSV row per person. Optional `quantity` column sets how many copies of that person's card to make.

```csv
name,title,email,phone,quantity
Alex Chen,Sales Manager,alex@example.com,+1 555 0100,20
Jordan Lee,Operations Lead,jordan@example.com,+1 555 0101,10
```

Map CSV headers to text fields, then adjust the text area's X/Y position, font size and line spacing. All four fields are printed in a vertical stack on top of the **front artwork** (one font and color style; the first row is bold). Use a Canva template with a clear text area, and avoid putting the employee-specific details in the underlying Canva art. Text is truncated if too long; do a proof before printing. The optional `quantity` header must be lowercase and counts must be whole numbers.

## A4 geometry

Default: 90 × 50 mm cards, 4 mm column and row gaps. Two columns × five rows = **184 × 266 mm**, centered on 210 × 297 mm A4, giving **13 mm side margins and 15.5 mm top/bottom margins**.

## Double-sided printing

- If a back artwork is provided, output is ordered **front sheet 1, back sheet 1, front sheet 2, back sheet 2**, etc.
- Back-side placement defaults to **Mirror columns**; options: Same positions, Mirror columns, Reverse rows, Rotate positions 180°. These reorder card *positions*, not card artwork orientation.
- Generate a **Duplex alignment test**. Print it double-sided on A4 at **Actual size / 100%**, never "Fit". Try long-edge vs. short-edge duplex flipping and different back-side placement until each front numbered 1–10 matches the same back number when viewed through the paper or cut.
- Not all printers align fronts and backs perfectly; adjust your printer's duplex registration or cutting tolerance as needed.
- If your printer cannot auto-duplex, print odd pages as fronts, then reload and print even pages as backs according to your printer's manual. Paper feed direction matters.

## Limits

- Maximum **50,000 cards** per export; large batches use substantial browser memory. For large orders, export in smaller runs.
- No automated editable Canva integration: upload Canva exports as files. You can still use Canva Bulk Create to generate customized images, but direct import of a multi-page Canva PDF into different personalized cards is not implemented.
- PDFs use standard Helvetica for personalized text (supports basic Latin/Windows-1252 text; some scripts and emoji are not supported).
- The preview represents A4 geometry and raster artwork placement; **PDF export is authoritative** for print output. PDF artwork is rasterized only for on-screen preview, embedded directly for export.
- No bleed handling, color profiles, or professional printer ICC calibration.

## Build

```bash
npm run build
npm run preview
```

The built static `dist/` folder can be served locally. App is not designed to accept public traffic.

## Deploy to GitHub Pages

This repository comes with a GitHub Actions workflow at `.github/workflows/deploy.yml`.

1. Create a repository named `CardPress` on GitHub.
2. Upload/push the **contents** of this folder to the repository root, including `.github` (hidden files).
3. In GitHub, open **Settings → Pages → Build and deployment**, set **Source: GitHub Actions**.
4. Push to `main` (or run the workflow manually from the Actions tab), then visit `https://YOUR-USERNAME.github.io/CardPress/`.

**If the GitHub repo is named differently**, change the `base` setting in `vite.config.js` from `/CardPress/` to `/<YOUR-REPO-NAME>/`. For a root user site or custom-domain site, use `/`.

Files remain processed entirely in the browser; GitHub Pages does not receive uploaded designs or CSV content. Note that anyone can access a published site in a public repository, though this does not make the locally uploaded files public.
