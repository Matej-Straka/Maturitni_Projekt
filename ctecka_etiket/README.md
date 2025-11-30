# Čtečka Etiket - Coffee Label Scanner

Mobilní aplikace pro prezentaci kávy prostřednictvím QR kódů s admin rozhraním pro správu obsahu.

## Architektura

```
┌─────────────────┐         ┌──────────────────┐
│  Mobile App     │◄────────┤  Serverpod API   │
│  (Flutter)      │  HTTP   │  (Dart)          │
│  iOS/Android    │         │  localhost:8080  │
└─────────────────┘         └──────────────────┘
        │                            │
        │ Scan QR                    │
        │ Get Coffee                 │
        │ Play Video                 ▼
        │                    ┌──────────────────┐
        │                    │   PostgreSQL     │
        │                    │   Database       │
        │                    └──────────────────┘
        │                            ▲
┌─────────────────┐                 │
│  Admin Panel    │◄────────────────┘
│  (Flutter Web)  │  HTTP + Auth
│  Chrome         │
└─────────────────┘
```

## Technologie

- **Backend**: Serverpod 2.9
- **Database**: PostgreSQL
- **Mobile App**: Flutter (iOS/Android)
- **Admin Panel**: Flutter Web
- **Features**: QR scanning, video playback, content management

## Struktura projektu

```
ctecka_etiket/
├── ctecka_etiket_server/      # Serverpod backend
├── ctecka_etiket_client/      # Generated client SDK
├── ctecka_etiket_flutter/     # Mobile app (iOS/Android)
└── ctecka_etiket_admin/       # Admin web interface
```

## Instalace a spuštění

### 1. Prerekvizity

- Dart SDK 3.5+
- Flutter 3.24+
- PostgreSQL 14+
- Docker (volitelně, pro snadné spuštění PostgreSQL)

### 2. Databáze

Spusťte PostgreSQL databázi. Nejjednodušší je přes Docker:

```bash
docker run -d \
  --name ctecka_etiket_db \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=your_password \
  -e POSTGRES_DB=ctecka_etiket \
  -p 5432:5432 \
  postgres:14
```

Nebo použijte existující PostgreSQL instanci a vytvořte databázi:

```sql
CREATE DATABASE ctecka_etiket;
```

### 3. Konfigurace serveru

Upravte `ctecka_etiket_server/config/development.yaml`:

```yaml
database:
  host: localhost
  port: 5432
  name: ctecka_etiket
  user: postgres
  password: your_password
```

### 4. Migrace databáze

Spusťte migraci (vytvoří tabulky):

```bash
cd ctecka_etiket_server
dart run bin/main.dart --apply-migrations
```

### 5. Vytvoření prvního admin uživatele

Po migraci musíte vytvořit prvního admin uživatele přímo v databázi:

```sql
-- Heslo "admin123" (SHA256 hash)
INSERT INTO app_user (username, password_hash, email, role, is_active, created_at)
VALUES (
  'admin',
  '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9',
  'admin@example.com',
  'admin',
  true,
  NOW()
);
```

Nebo použijte vlastní heslo a vygenerujte hash:

```bash
echo -n "your_password" | shasum -a 256
```

### 6. Spuštění serveru

```bash
cd ctecka_etiket_server
dart run bin/main.dart
```

Server poběží na `http://localhost:8080`

### 7. Spuštění mobilní aplikace

```bash
cd ctecka_etiket_flutter
flutter run
```

Pro iOS/Android simulátor/zařízení.

### 8. Spuštění admin panelu

```bash
cd ctecka_etiket_admin
flutter run -d chrome
```

Přihlašovací údaje:
- **Username**: `admin`
- **Password**: `admin123` (nebo vaše vlastní)

## Použití

### Mobilní aplikace

1. Spusťte aplikaci
2. Projděte onboarding (3 obrazovky)
3. Naskenujte QR kód na obalu kávy
4. Přehraje se video o kávě
5. Zobrazte složení nebo více informací

### Admin panel

1. Přihlaste se na `http://localhost:8080` (nebo kde běží Flutter Web)
2. **Správa káv**: Přidávejte, upravujte nebo mažte kávy
3. **QR kódy**: Přiřazujte QR kódy ke kávám
4. **Uživatelé**: Spravujte admin účty

## API Endpointy

### Veřejné (mobilní app)

- `POST /coffee/getCoffeeByQR` - Získat kávu podle QR kódu
- `POST /coffee/getAllCoffees` - Seznam všech káv
- `POST /coffee/getCoffeeDetail` - Detail kávy podle ID

### Admin (vyžaduje autentizaci)

- `POST /admin/login` - Přihlášení
- `POST /admin/createCoffee` - Vytvořit kávu
- `POST /admin/updateCoffee` - Upravit kávu
- `POST /admin/deleteCoffee` - Smazat kávu
- `POST /admin/assignQRCode` - Přiřadit QR kód
- `POST /admin/getAllQRMappings` - Seznam QR kódů
- `POST /admin/deleteQRMapping` - Smazat QR mapping
- `POST /admin/createUser` - Vytvořit uživatele
- `POST /admin/getAllUsers` - Seznam uživatelů

## Struktura databáze

### Tabulka `coffee`

- `id` - Primární klíč
- `name` - Název kávy
- `description` - Krátký popis
- `composition` - Složení
- `more_info` - Detailní informace
- `video_url` - URL videa
- `image_url` - URL obrázku
- `created_at`, `updated_at` - Časové značky

### Tabulka `qr_code_mapping`

- `id` - Primární klíč
- `qr_code` - QR kód (unikátní)
- `coffee_id` - Foreign key na `coffee`
- `is_active` - Aktivní/neaktivní
- `created_at` - Časová značka

### Tabulka `app_user`

- `id` - Primární klíč
- `username` - Uživatelské jméno (unikátní)
- `password_hash` - SHA256 hash hesla
- `email` - Email
- `role` - Role (admin, editor)
- `is_active` - Aktivní/neaktivní
- `created_at`, `last_login` - Časové značky

## Vývoj

### Regenerace protokolů

Po změně `.spy.yaml` souborů:

```bash
cd ctecka_etiket_server
serverpod generate  # nebo $HOME/.pub-cache/bin/serverpod generate
```

### Vytvoření nové migrace

```bash
cd ctecka_etiket_server
serverpod create-migration
```

### Build pro produkci

**Server**:
```bash
cd ctecka_etiket_server
dart compile exe bin/main.dart -o server
```

**Mobile**:
```bash
cd ctecka_etiket_flutter
flutter build apk  # Android
flutter build ios  # iOS
```

**Admin**:
```bash
cd ctecka_etiket_admin
flutter build web
```

## Poznámky

- Autentizace je jednoduchá (username+password v každém požadavku). Pro produkci zvažte JWT nebo session management.
- Video URL může být lokální asset nebo vzdálená URL.
- Obrázky mohou být asset paths nebo HTTP(S) URL.
- Pro produkční nasazení nezapomeňte změnit `serverUrl` v aplikacích.

## Autor

Matěj Straka  
Maturitní práce 2025
