# Rychlý Start Guide

## Krok za krokem

### 1. Spusťte PostgreSQL databázi

```bash
cd ctecka_etiket_server
docker-compose up -d postgres
```

Počkejte pár sekund, než se databáze inicializuje.

### 2. Proveďte migraci databáze

```bash
cd ctecka_etiket_server
dart run bin/main.dart --apply-migrations
```

### 3. Vytvořte admin uživatele

```bash
docker exec -i ctecka_etiket_server-postgres-1 psql -U postgres -d ctecka_etiket < init_admin.sql
```

Nebo se připojte k databázi a spusťte SQL manuálně:

```bash
docker exec -it ctecka_etiket_server-postgres-1 psql -U postgres -d ctecka_etiket
```

Pak zkopírujte obsah `init_admin.sql`.

### 4. Spusťte server

```bash
cd ctecka_etiket_server
dart run bin/main.dart
```

Server běží na http://localhost:8080

### 5. Otevřete admin panel

V novém terminálu:

```bash
cd ctecka_etiket_admin
flutter run -d chrome
```

Přihlaste se:
- Username: `admin`
- Password: `admin123`

### 6. Přidejte kávu a QR kód

V admin panelu:
1. Klikněte na "Správa káv"
2. Klikněte "Přidat" (FAB vpravo dole)
3. Vyplňte údaje o kávě:
   - Název: např. "Podzimní směs"
   - Popis: "Lahodná káva..."
   - Složení: "Arabica 80%, Robusta 20%..."
   - Více informací: "Naše podzimní směs..."
   - URL videa: `https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4`
   - URL obrázku: `https://picsum.photos/seed/coffee1/400/400`
4. Klikněte "Přidat"

Pak přidejte QR kód:
1. Zpět na Dashboard → "QR kódy"
2. Klikněte "Přidat"
3. Zadejte QR kód: např. `TEST_QR_001`
4. Vyberte kávu z dropdown
5. Klikněte "Přidat"

### 7. Spusťte mobilní aplikaci

V novém terminálu:

```bash
cd ctecka_etiket_flutter
flutter run
```

Vyberte zařízení (iOS/Android simulátor).

### 8. Otestujte flow

1. V mobilní aplikaci projděte onboarding (3 obrazovky)
2. Na scanner obrazovce naskenujte QR kód
   - Pro testování můžete zadat text `TEST_QR_001` manuálně
   - Nebo vygenerujte QR kód online (https://www.qr-code-generator.com/) s textem `TEST_QR_001`
3. Přehraje se video
4. Klikněte "VÍCE INFORMACÍ"
5. Zobrazte složení nebo více info

## Troubleshooting

### Server se nespustí
- Zkontrolujte, že PostgreSQL běží: `docker ps`
- Zkontrolujte port 8080 není obsazený: `lsof -i :8080`

### Mobilní app se nemůže připojit k serveru
- Ujistěte se, že server běží na `http://localhost:8080`
- Pro fyzické zařízení změňte `serverUrl` na IP adresu vašeho počítače

### Admin panel - Nesprávné přihlašovací údaje
- Zkontrolujte, že jste spustili `init_admin.sql`
- Zkuste se připojit k databázi a ověřit, že uživatel existuje:
  ```sql
  SELECT * FROM app_user WHERE username = 'admin';
  ```

### Video se nepřehrává
- Zkontrolujte, že URL videa je platná
- Pro testování použijte veřejné demo video (v příkladu výše)

## Užitečné příkazy

### Restart databáze
```bash
cd ctecka_etiket_server
docker-compose down
docker-compose up -d postgres
```

### Zobrazit logy serveru
Server běží v terminálu, kde jste spustili `dart run bin/main.dart`

### Přístup k databázi
```bash
docker exec -it ctecka_etiket_server-postgres-1 psql -U postgres -d ctecka_etiket
```

### Hot reload mobilní aplikace
Stiskněte `r` v terminálu, kde běží `flutter run`

### Hot restart mobilní aplikace
Stiskněte `R` v terminálu, kde běží `flutter run`
