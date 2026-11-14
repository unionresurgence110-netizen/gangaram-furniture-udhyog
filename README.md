# Gangaram Furniture Udhyog

A bilingual (English / Nepali) furniture and wood-mill showcase website with a private owner dashboard. This project was converted from the supplied working stationery-shop project while retaining its Node.js, Express, PostgreSQL/Neon and Cloudflare R2 architecture.

## What's included

### Public website
- Premium walnut, warm ivory and antique-gold visual design.
- English by default, with an English / नेपाली language switch.
- Responsive layouts for phones, small screens, tablets and desktops.
- Furniture catalogue with large product cards (one card per row on phone-sized screens).
- Furniture name and long description in English and Nepali.
- Optional price; an empty price displays “Contact for Price”.
- Wood type, finish, dimensions and custom-design availability.
- Individual direct-call enquiry links using the business phone number.
- Furniture categories, search, featured furniture and project gallery.
- Separate Wood Mill services section.
- Business announcements, About and Contact information.
- Lazy-loaded images and WebP conversion in the browser before upload.
- No customer login, registration, favourites, reservations, checkout or online payment.

### Private owner dashboard
- Private email/password login at `/admin/login.html`.
- Dashboard at `/admin/dashboard.html`; no public registration page or customer-facing login link.
- Owner-only APIs require a valid JWT and the database `admin` role.
- Add/edit/hide furniture, manage categories, add/delete gallery projects, publish/delete announcements and edit business settings.
- Product fields include English/Nepali names and descriptions, optional price, category, wood type, finish, dimensions, custom-design flag, featured flag and image URLs.
- Images selected in the dashboard are converted to WebP and resized in the browser before upload. Final uploaded image must be no larger than 1 MB. Backend multer limit is also 1 MB.
- Manual/code-based catalogue is supported in `assets/data/furniture.js`.

## Technology
- Frontend: HTML, CSS, vanilla JavaScript.
- Backend: Node.js 20+, Express.
- Database: PostgreSQL (Neon supported).
- Image storage: Cloudflare R2 (S3-compatible).
- Owner authentication: bcrypt password hashes + JWT.
- Hosting: Render Web Service can serve frontend and API from the same origin.

## Local setup
1. Install Node.js 20 or newer and PostgreSQL (or create a Neon database).
2. Copy `.env.example` to `.env` and set `DATABASE_URL` and a long random `JWT_SECRET`.
3. Run the SQL files in this order against the database:
   - `backend/schema.sql`
   - `backend/migrations/002_feature_completion.sql`
   - `backend/migrations/003_prd_alignment.sql`
   - `backend/migrations/005_gangaram_furniture.sql`
4. Install dependencies: `npm install`.
5. Create the owner account from the project root: `npm run create-owner`. The command asks for the owner's name, email and password; the password prompt is hidden in a terminal. Use a unique password of at least 12 characters.
6. Start the app: `npm start`.
7. Open `http://localhost:3000`. Owner login: `http://localhost:3000/admin/login.html`.
8. Set the business phone number in the Owner Dashboard before publishing, so Call buttons dial the correct number.

## Environment variables
- `DATABASE_URL`: PostgreSQL / Neon connection string.
- `JWT_SECRET`: unique, high-entropy secret; keep private.
- `JWT_EXPIRES_IN`: optional; defaults to `7d`.
- `PORT`: optional; defaults to `3000`.
- `NODE_ENV`: set to `production` when deployed.
- `CORS_ORIGIN`: exact allowed origins. For same-origin hosting, use the deployed site origin and local origin.
- `R2_ACCOUNT_ID`, `R2_ACCESS_KEY_ID`, `R2_SECRET_ACCESS_KEY`, `R2_BUCKET_NAME`, `R2_PUBLIC_BASE_URL`: required for dashboard image uploads. Keep R2 credentials only in the server environment, never in frontend files.

## Manual/code-based furniture and gallery entries

Edit `assets/data/furniture.js` and add objects to `window.MANUAL_FURNITURE`. Example:

```js
window.MANUAL_FURNITURE = [
  {
    id: 'manual-carved-bed',
    name: 'Hand-Carved Wooden Bed',
    nameNe: 'हातले कुँदिएको काठको पलङ',
    description: 'A custom wooden bed with detailed hand-carved work.',
    descriptionNe: 'विस्तृत हातको नक्काशीसहितको कस्टम काठको पलङ।',
    image: '/assets/images/furniture/carved-bed.webp',
    category: 'Beds',
    price: null,
    woodType: 'Sal wood',
    dimensions: '6 ft × 6.5 ft',
    finish: 'Natural polish',
    featured: true
  }
];
```

Put the image file in `assets/images/furniture/` (create the folder if needed). Use `price: null` to show “Contact for Price”. Manual entries are read-only in the dashboard; edit the JavaScript file to change them. The owner dashboard and manual code entries appear together on the public site.

For manual gallery entries, add objects to `window.MANUAL_GALLERY` with `title`, `description` and `image` fields.

## Deployment (Render + Neon + Cloudflare R2)
1. Push the project to a Git repository.
2. Create a Neon PostgreSQL database and run the SQL files in the order listed above.
3. Create a Render Web Service from the repository. Build command: `npm install`; start command: `npm start`; use Node 20+.
4. Add `DATABASE_URL`, `JWT_SECRET`, `JWT_EXPIRES_IN`, `NODE_ENV=production`, `CORS_ORIGIN` and the five R2 variables to Render environment settings.
5. Create an R2 bucket and an access key scoped to that bucket. Configure a public custom domain for image delivery and use it as `R2_PUBLIC_BASE_URL`.
6. Deploy. Open the Render URL plus `/admin/login.html` and create the owner using the local `npm run create-owner` command with the production `DATABASE_URL` configured in the local `.env`, or run the script in a trusted environment connected to the production database.
7. In the owner dashboard, set the business phone, address, tagline and business descriptions. Add actual furniture photos and real completed-work gallery images before sharing the website.

## Image notes
- Dashboard accepts JPG, PNG and WebP input. Browser converts/resizes selected images to WebP before upload.
- Final browser-uploaded file must be 1 MB or less; backend upload limit is independently enforced at 1 MB.
- Images are lazy-loaded on the public website.
- Manual code images are local project assets or public image URLs; keep them optimized (prefer WebP under 1 MB).

## Checks and limitations
- Run `npm run check` for JavaScript syntax checks.
- `npm start` requires a configured PostgreSQL database and `JWT_SECRET`.
- Image uploads require configured Cloudflare R2 credentials and a public image delivery domain.
- No live Neon, Render or R2 credentials were supplied in the ZIP, so this workspace cannot perform a real production deployment or verify a live database connection. Apply migration `005_gangaram_furniture.sql` before using the converted API against a database.
- Existing stationery product records are retained but hidden by migration 005; existing customer accounts are not exposed by the new public UI. The migration renames the first six existing categories and adds furniture categories.
