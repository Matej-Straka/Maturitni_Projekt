# Bezpečnostní vylepšení - Implementace

## ✅ Implementováno

### 1. Bcrypt pro hashování hesel
- ✅ Nahrazen SHA256 za bcrypt s cost faktorem 10
- ✅ Všechna místa aktualizována (_isAdmin, _hasRole, _getUserRole, login, createUser, updateUser)
- ✅ Nový `hash_password.dart` skript pro generování hashů
- ✅ Aktualizován `init_admin.sql` s bcrypt hashem

**Použití:**
```bash
# Generuj bcrypt hash pro nové heslo
dart run bin/hash_password.dart "tvoje_heslo"
```

### 2. Rate Limiting
- ✅ Implementován in-memory rate limiter
- ✅ Max 10 pokusů o přihlášení za 15 minut na uživatele
- ✅ Automatické čištění starých záznamů
- ✅ Aplikováno na všechny autentizační metody

**Konfigurace:**
V `admin_endpoint.dart`:
```dart
// Lze změnit limity:
attempts.removeWhere((time) => now.difference(time).inMinutes > 15);  // Časové okno
if (attempts.length >= 10) {  // Max pokusů
```

### 3. HTTPS
- ✅ Vytvořen kompletní návod v `HTTPS_SETUP.md`
- ✅ Konfigurace pro development (self-signed)
- ✅ Konfigurace pro production (Let's Encrypt + Nginx/Caddy)

**Rychlé spuštění:**
```bash
# Development - self-signed certifikát
cd ctecka_etiket_server && openssl genrsa -out certs/server.key 2048

# Production - použij Nginx nebo Caddy jako reverse proxy
```

## 🔄 Migrace existujících uživatelů

Pokud máš existující uživatele v databázi se starými SHA256 hashy:

```sql
-- VAROVÁNÍ: Toto smaže všechny existující uživatele!
-- Pro zachování dat, požádej uživatele o reset hesla
DELETE FROM app_user;

-- Nebo obnov admin účet s novým bcrypt hashem
UPDATE app_user 
SET password_hash = '$2a$10$Pm7XAY5vJaQYNChtEXPZrO8FU2Ot7hikeSQcEcSjv.DHwEn2hnlpS'
WHERE username = 'admin';
```

## 📝 Checklist po implementaci

- [ ] Spusť `dart pub get` v ctecka_etiket_server
- [ ] Aktualizuj hashe všech existujících uživatelů
- [ ] Nastav HTTPS (alespoň reverse proxy s Let's Encrypt)
- [ ] Testuj přihlášení s novým bcrypt
- [ ] Testuj rate limiting (zkus 11 neúspěšných pokusů)
- [ ] Zkontroluj, že HTTPS funguje v mobilní app i admin panelu

## 🔐 Další doporučení (neimplementováno)

Pro ještě lepší zabezpečení zvažte:
- **JWT tokeny** místo username+password v každém requestu
- **CORS middleware** - omezení povolených originů
- **API keys** pro statické soubory
- **Database connection pooling** s limity
- **Logging & monitoring** - sledování podezřelých aktivit
- **2FA (Two-Factor Authentication)**
- **Account lockout** po X neúspěšných pokusech

## 🐛 Známé limity

1. **Rate limiting je in-memory** - resetuje se při restartu serveru
   - Pro produkci použij Redis nebo databázi
   
2. **Bcrypt je CPU-intensive** 
   - Může zpomalit server při velkém množství přihlášení
   - Zvažte použití async workers nebo cachování sessions

3. **HTTPS vyžaduje manuální setup**
   - Pro automatickou konfiguraci použij Caddy nebo cloud služby
