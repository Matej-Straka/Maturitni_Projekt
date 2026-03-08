-- Script pro vytvoření prvního admin uživatele
-- Spusťte tento script po migraci databáze

-- Admin uživatel
-- Username: admin
-- Password: admin123
-- Email: admin@example.com
-- Role: admin
-- Hash: bcrypt with cost 10

INSERT INTO app_user (username, password_hash, email, role, is_active, created_at)
VALUES (
  'admin',
  '$2a$10$Pm7XAY5vJaQYNChtEXPZrO8FU2Ot7hikeSQcEcSjv.DHwEn2hnlpS',
  'admin@example.com',
  'admin',
  true,
  NOW()
)
ON CONFLICT (username) DO UPDATE SET 
  password_hash = EXCLUDED.password_hash;

-- Ukázková káva pro testování
INSERT INTO coffee (name, description, composition, more_info, video_url, image_url, created_at, updated_at)
VALUES (
  'Podzimní směs',
  'Lahodná káva s tóny karamelu a oříšků',
  'Arabica 80%, Robusta 20%. Původ: Brazílie, Kolumbie',
  'Naše podzimní směs je pečlivě vybrána z nejkvalitnějších zrn z Latinské Ameriky. Pražení probíhá při středně vysoké teplotě pro dokonalou vyváženost chutí.',
  'https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
  'https://picsum.photos/seed/coffee1/400/400',
  NOW(),
  NOW()
)
ON CONFLICT DO NOTHING
RETURNING id;

-- QR kód pro testování (pokud máte ID kávy z předchozího INSERT)
-- Nahraďte <coffee_id> skutečným ID z výstupu předchozího příkazu
-- INSERT INTO qr_code_mapping (qr_code, coffee_id, is_active, created_at)
-- VALUES (
--   'TEST_QR_001',
--   <coffee_id>,
--   true,
--   NOW()
-- );
