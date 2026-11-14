-- Gangaram Furniture Udhyog showcase conversion.
-- Run once after the original schema and migrations 002 + 003.
ALTER TABLE products ALTER COLUMN price DROP NOT NULL;
ALTER TABLE products ALTER COLUMN price DROP DEFAULT;
ALTER TABLE products ADD COLUMN IF NOT EXISTS name_ne VARCHAR(180) NOT NULL DEFAULT '';
ALTER TABLE products ADD COLUMN IF NOT EXISTS description_ne TEXT NOT NULL DEFAULT '';
ALTER TABLE products ADD COLUMN IF NOT EXISTS wood_type VARCHAR(160) NOT NULL DEFAULT '';
ALTER TABLE products ADD COLUMN IF NOT EXISTS finish VARCHAR(160) NOT NULL DEFAULT '';
ALTER TABLE products ADD COLUMN IF NOT EXISTS dimensions VARCHAR(160) NOT NULL DEFAULT '';
ALTER TABLE products ADD COLUMN IF NOT EXISTS custom_design BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE products ADD COLUMN IF NOT EXISTS image_urls JSONB NOT NULL DEFAULT '[]'::jsonb;
ALTER TABLE categories ADD COLUMN IF NOT EXISTS name_ne VARCHAR(120) NOT NULL DEFAULT '';
CREATE TABLE IF NOT EXISTS gallery_items (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
 title VARCHAR(180) NOT NULL,
 description TEXT NOT NULL DEFAULT '',
 image_url TEXT NOT NULL,
 is_visible BOOLEAN NOT NULL DEFAULT TRUE,
 sort_order INT NOT NULL DEFAULT 0,
 created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
-- Hide only products assigned to the known legacy stationery categories.
-- This is safe to rerun and does not hide newly added furniture.
UPDATE products p SET is_hidden=TRUE
FROM categories c
WHERE p.category_id=c.id
 AND c.name IN ('Pen & Pencils','School Kit','Kids Fun','Art','Sports','Decorative');
-- Deactivate old stationery categories and create/activate the furniture categories by name.
UPDATE categories SET is_active=FALSE;
INSERT INTO categories(name,name_ne,icon,sort_order,is_active) VALUES
 ('Beds','पलङ','bed',1,TRUE),
 ('Doors','ढोका','door-open',2,TRUE),
 ('Windows','झ्याल','app-window',3,TRUE),
 ('Wardrobes','दराज','cabinet',4,TRUE),
 ('Tables','टेबल','table',5,TRUE),
 ('Chairs','कुर्सी','armchair',6,TRUE),
 ('Sofa Sets','सोफा सेट','sofa',7,TRUE),
 ('Wooden Carving','काठको नक्काशी','hammer',8,TRUE),
 ('Custom Furniture','अर्डरअनुसारका फर्निचर','package',9,TRUE)
ON CONFLICT(name) DO UPDATE SET name_ne=EXCLUDED.name_ne,icon=EXCLUDED.icon,sort_order=EXCLUDED.sort_order,is_active=TRUE;
-- Seed defaults without overwriting details entered later in the dashboard.
INSERT INTO shop_settings(key,value) VALUES
 ('name','"Gangaram Furniture Udhyog"'::jsonb),
 ('suffix','"Furniture & Wood Mill"'::jsonb),
 ('motto','"Crafted with care. Built to last."'::jsonb),
 ('description','""'::jsonb),
 ('phone','""'::jsonb),('email','""'::jsonb),('address','""'::jsonb),
 ('bannerImage','""'::jsonb),('aboutImage','""'::jsonb),('millImage','""'::jsonb),
 ('millDescription','""'::jsonb),('socials','{}'::jsonb)
ON CONFLICT(key) DO NOTHING;
