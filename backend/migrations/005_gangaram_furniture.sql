-- Gangaram Furniture Udhyog showcase conversion
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
-- Keep legacy records in the database but prevent old stationery products/categories from showing.
UPDATE products SET is_hidden=TRUE WHERE TRUE;
UPDATE categories SET is_active=FALSE;
UPDATE categories SET name='Beds',name_ne='पलङ',sort_order=1,is_active=TRUE WHERE id=(SELECT id FROM categories ORDER BY sort_order,id OFFSET 0 LIMIT 1);
UPDATE categories SET name='Tables',name_ne='टेबल',sort_order=2,is_active=TRUE WHERE id=(SELECT id FROM categories ORDER BY sort_order,id OFFSET 1 LIMIT 1);
UPDATE categories SET name='Chairs',name_ne='कुर्सी',sort_order=3,is_active=TRUE WHERE id=(SELECT id FROM categories ORDER BY sort_order,id OFFSET 2 LIMIT 1);
UPDATE categories SET name='Doors & Windows',name_ne='ढोका र झ्याल',sort_order=4,is_active=TRUE WHERE id=(SELECT id FROM categories ORDER BY sort_order,id OFFSET 3 LIMIT 1);
UPDATE categories SET name='Wardrobes',name_ne='दराज',sort_order=5,is_active=TRUE WHERE id=(SELECT id FROM categories ORDER BY sort_order,id OFFSET 4 LIMIT 1);
UPDATE categories SET name='Wood Carving',name_ne='काठको नक्काशी',sort_order=6,is_active=TRUE WHERE id=(SELECT id FROM categories ORDER BY sort_order,id OFFSET 5 LIMIT 1);
INSERT INTO categories(name,name_ne,sort_order) VALUES
 ('Sofa Sets','सोफा सेट',7),('Custom Furniture','अर्डरअनुसारका फर्निचर',8),('Wood Mill','काठ मिल',9)
ON CONFLICT(name) DO NOTHING;
INSERT INTO shop_settings(key,value) VALUES
 ('name','"Gangaram Furniture Udhyog"'::jsonb),
 ('suffix','"Furniture & Wood Mill"'::jsonb),
 ('motto','"Crafted with care. Built to last."'::jsonb),
 ('description','"Furniture, custom woodwork, carving and wood mill services."'::jsonb),
 ('phone','""'::jsonb),
 ('email','""'::jsonb),
 ('address','""'::jsonb),
 ('bannerImage','""'::jsonb),
 ('aboutImage','""'::jsonb),
 ('millDescription','"Wood cutting and timber processing services."'::jsonb),
 ('socials','{}'::jsonb)
ON CONFLICT(key) DO UPDATE SET value=EXCLUDED.value,updated_at=NOW();
