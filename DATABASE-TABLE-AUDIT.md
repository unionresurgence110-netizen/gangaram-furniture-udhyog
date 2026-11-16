# Database table audit — Gangaram Furniture Udhyog

This is an audit note, not a destructive migration. No tables are dropped by the showcase patch.

## Core tables used by the current showcase

- `users` — owner authentication and roles.
- `categories` — furniture categories.
- `products` — dashboard-managed furniture, including `image_urls`, `featured`, and detail visibility.
- `gallery_items` — dashboard-managed public gallery projects.
- `notices` — business announcements.
- `shop_settings` — business details, image URLs, social links, and OpenStreetMap latitude/longitude values.

## Legacy / optional tables that need a separate retirement decision

The current backend API still contains legacy routes or queries for several of these features. They must not be dropped while those routes remain deployed:

- `product_likes`
- `favourites`
- `reservations`
- `suggestions`
- `suggestion_likes`
- `offers`
- `offer_products`
- `notifications`
- `shop_reviews`

## Tables not referenced by the current API source scan

These look like migration leftovers or abandoned feature scaffolding, but still require checking the live database for foreign keys, views, triggers, and external jobs before removal:

- `shop_likes`
- `owner_about` (location is now stored in `shop_settings`, so this table is not needed by the new map feature)
- `homepage_sections` (homepage featured items currently use `products.featured`)
- `offer_product_discounts`
- `reservation_events`

## Recommendation

Do not run `DROP TABLE` statements yet. First take a Neon backup/export, inspect live constraints and dependencies, remove any unused API routes in a separate reviewed patch, then prepare a transaction-based cleanup migration. This avoids accidentally breaking older deployments or losing data that might still be needed.
