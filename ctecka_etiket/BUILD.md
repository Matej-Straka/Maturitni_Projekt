# Export / Build Instrukce

## Mobilní aplikace (ctecka_etiket_flutter)

### Android APK
```bash
cd ctecka_etiket_flutter
flutter build apk --release
```
Soubor bude v: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (pro Google Play)
```bash
cd ctecka_etiket_flutter
flutter build appbundle --release
```
Soubor bude v: `build/app/outputs/bundle/release/app-release.aab`

### iOS (vyžaduje Mac)
```bash
cd ctecka_etiket_flutter
flutter build ios --release
```
Poté otevři `ios/Runner.xcworkspace` v Xcode a proveď Archive & Export

### Nastavení server URL před buildem
V souboru `lib/main.dart` zkontroluj:
```dart
const serverUrl = String.fromEnvironment('SERVER_URL', defaultValue: 'http://34.122.70.47:8080/');
```

Pro produkční build s vlastní URL:
```bash
flutter build apk --release --dart-define=SERVER_URL=https://tvoje-url.com
```

---

## Admin panel (ctecka_etiket_admin)

### Web build
```bash
cd ctecka_etiket_admin
flutter build web --release
```
Soubory budou v: `build/web/`

### Nastavení server URL
V souboru `lib/main.dart` zkontroluj:
```dart
const serverUrl = String.fromEnvironment('SERVER_URL', defaultValue: 'http://34.122.70.47:8080/');
const staticServerUrl = String.fromEnvironment('STATIC_SERVER_URL', defaultValue: 'http://34.122.70.47:8090');
```

Pro produkční build:
```bash
flutter build web --release \
  --dart-define=SERVER_URL=https://tvoje-api.com \
  --dart-define=STATIC_SERVER_URL=https://tvoje-static.com
```

### Deploy admin panelu na web hosting
1. Nahraj obsah `build/web/` na hosting (Netlify, Vercel, Firebase Hosting, atd.)
2. Ujisti se, že server podporuje SPA routing (přesměrování na index.html)

Příklad pro Firebase Hosting:
```bash
firebase deploy --only hosting
```

---

## Server (ctecka_etiket_server)

### Build serveru
```bash
cd ctecka_etiket_server
dart pub get
dart compile exe bin/main.dart -o server
```
Vytvoří se spustitelný soubor `server`

### Docker build
```bash
cd ctecka_etiket_server
docker build -t ctecka-etiket-server .
docker run -p 8080:8080 -p 8090:8090 ctecka-etiket-server
```

### Deploy na produkci
1. Nastav environment variables (DATABASE_URL, apod.)
2. Spusť migrace: `dart run bin/main.dart --apply-migrations`
3. Spusť server: `dart run bin/main.dart`

---

## Rychlý export všeho

```bash
# Mobilní app
cd ctecka_etiket_flutter && flutter build apk --release

# Admin panel
cd ../ctecka_etiket_admin && flutter build web --release

# Server
cd ../ctecka_etiket_server && dart compile exe bin/main.dart -o server
```

## Výstupní soubory

Po úspěšném buildu najdeš:
- **Mobilní APK**: `ctecka_etiket_flutter/build/app/outputs/flutter-apk/app-release.apk`
- **Admin web**: `ctecka_etiket_admin/build/web/` (celá složka)
- **Server**: `ctecka_etiket_server/server` (spustitelný soubor)

## Instalace na zařízení

### Android (APK)
1. Zkopíruj `app-release.apk` na Android zařízení
2. Povolit "Instalace z neznámých zdrojů" v Nastavení > Zabezpečení
3. Otevři APK soubor a nainstaluj

Nebo pomocí ADB:
```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

### iOS
Vyžaduje Apple Developer účet a distribuci přes TestFlight nebo App Store
