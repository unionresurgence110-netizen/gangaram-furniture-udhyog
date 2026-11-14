-- Per-field public visibility for furniture details.
-- Apply after 005_gangaram_furniture.sql.
ALTER TABLE products
 ADD COLUMN IF NOT EXISTS details_visibility JSONB NOT NULL
 DEFAULT '{"description":true,"price":true,"woodType":true,"finish":true,"dimensions":true,"customDesign":true}'::jsonb;
UPDATE products
 SET details_visibility='{"description":true,"price":true,"woodType":true,"finish":true,"dimensions":true,"customDesign":true}'::jsonb
 WHERE details_visibility IS NULL;
