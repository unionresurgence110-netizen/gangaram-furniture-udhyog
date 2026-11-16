# Gangaram Furniture Udhyog — Showcase Patch

## Included changes

- Homepage now displays only owner-featured furniture and caps the section at 10 items. There is no automatic fallback to unfeatured products.
- Manual catalogue entries in `assets/data/furniture.js` can also be featured with `featured: true`; manual items remain code-managed and are not inserted into PostgreSQL.
- Furniture image gallery supports one main image plus up to three additional image URLs (four total). Clicking a furniture image opens a responsive lightbox with previous/next, Escape/backdrop close, and touch swipe.
- Added client and API validation for the three additional-image limit.
- Call buttons now use a shared phone-number normalizer so formatting characters do not break `tel:` links.
- Business description is shown on About only; wood-mill description is shown on the Wood Mill page only, not the homepage or footer.
- Added an OpenStreetMap pin picker to Business Settings. The selected latitude/longitude are stored as existing `shop_settings` values and displayed as an embedded map on About. No new location table is required.
- Dashboard gallery now supports add, edit, delete, image URL entry, and image upload. Public gallery images open in a lightbox.
- Manual gallery entries can be maintained in `window.MANUAL_GALLERY` inside `assets/data/furniture.js`.
- Relative `/assets/...` images are resolved correctly on the GitHub Pages project path, including lightbox images.

## Deployment

1. Replace the repository files with this ZIP's contents, preserving the repository root structure.
2. Commit and push to the `main` branch so GitHub Pages deploys the frontend.
3. Deploy the backend changes to Render as well; the new gallery edit route and image-count validation are in `backend/src/routes/api.js`.
4. Confirm the Render environment has all Cloudflare R2 variables listed in `.env.example`. Do not commit real values to GitHub.
5. In Owner Dashboard → Business settings, place the map pin and save. The map is displayed on the About page only after valid coordinates are saved.

No SQL migration is required for this patch: the existing `shop_settings` JSONB store holds map coordinates, `products.image_urls` holds additional furniture image URLs, and `gallery_items` already holds gallery records.
