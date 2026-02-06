# HTTPS Konfigurace

## Generování self-signed certifikátu (pro vývoj)

```bash
cd ctecka_etiket_server
mkdir -p certs

# Generuj privátní klíč
openssl genrsa -out certs/server.key 2048

# Generuj certifikát (platný 365 dní)
# Pro localhost:
openssl req -new -x509 -key certs/server.key -out certs/server.crt -days 365 \
  -subj "/C=CZ/ST=Prague/L=Prague/O=Development/CN=localhost"

# Pro IP adresu (např. 34.122.70.47):
openssl req -new -x509 -key certs/server.key -out certs/server.crt -days 365 \
  -subj "/C=CZ/ST=Prague/L=Prague/O=Development/CN=34.122.70.47" \
  -addext "subjectAltName=IP:34.122.70.47"
```

## ⚠️ HTTPS s IP adresou (bez domény)

**Omezení:**
- Let's Encrypt **nepodporuje** certifikáty pro IP adresy
- Musíš použít self-signed certifikát
- Prohlížeče/aplikace zobrazí varování o nedůvěryhodném certifikátu
- Pro Flutter aplikace je třeba vypnout certificate validation (⚠️ bezpečnostní riziko!)

**Řešení:**
1. **Nejlepší**: Použij doménu (i zdarma z Freenom/DuckDNS) a Let's Encrypt
2. **Pokud nutně IP**: Self-signed + disable cert validation v aplikaci

## Pro produkci s doménou

Doporučení:
1. **Let's Encrypt** (zdarma): Použij certbot
2. **Cloudflare** - automatické HTTPS
3. **AWS Certificate Manager** / **GCP Load Balancer**

### Let's Encrypt příklad:

```bash
# Nainstaluj certbot
sudo apt-get install certbot

# Získej certifikát
sudo certbot certonly --standalone -d tvoje-domena.com

# Certifikáty budou v:
# /etc/letsencrypt/live/tvoje-domena.com/fullchain.pem
# /etc/letsencrypt/live/tvoje-domena.com/privkey.pem
```

## Konfigurace Serverpodu pro HTTPS

V `config/production.yaml`:

```yaml
apiServer:
  port: 8080
  publicHost: tvoje-domena.com
  publicPort: 443
  publicScheme: https
```

## Použití reverse proxy (doporučeno)

Nejlepší praxe je použít Nginx nebo Caddy jako reverse proxy:

### Nginx konfigurace:

```nginx
server {
    listen 443 ssl http2;
    server_name tvoje-domena.com;

    ssl_certificate /etc/letsencrypt/live/tvoje-domena.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/tvoje-domena.com/privkey.pem;

    # Silné SSL nastavení
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

# Přesměrování HTTP na HTTPS
server {
    listen 80;
    server_name tvoje-domena.com;
    return 301 https://$server_name$request_uri;
}
```

### Caddy konfigurace (automatické HTTPS):

**Jednoduchá varianta - pouze API:**
```
tvoje-domena.com {
    reverse_proxy localhost:8080
}
```

**Kompletní varianta - API + statický server:**
```
# API server
api.tvoje-domena.com {
    reverse_proxy localhost:8080
}

# Statický server pro obrázky/videa
static.tvoje-domena.com {
    reverse_proxy localhost:8090
}
```

**Nebo vše na jedné doméně:**
```
tvoje-domena.com {
    # Statické soubory z /uploads
    handle /uploads/* {
        reverse_proxy localhost:8090
    }
    
    # API na /api
    handle /api/* {
        reverse_proxy localhost:8080
    }
    
    # Nebo vše na API server
    handle {
        reverse_proxy localhost:8080
    }
}
```

Caddy automaticky získá a obnoví Let's Encrypt certifikáty!

**Instalace a spuštění Caddy:**
```bash
# Ubuntu/Debian
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update
sudo apt install caddy

# Vytvoř Caddyfile
sudo nano /etc/caddy/Caddyfile

# Spusť Caddy
sudo systemctl enable caddy
sudo systemctl start caddy
sudo systemctl status caddy
```

**Pro DuckDNS:**
```
# /etc/caddy/Caddyfile
moje-app.duckdns.org {
    reverse_proxy /uploads/* localhost:8090
    reverse_proxy localhost:8080
}
```

## Aktualizace URL v aplikacích

Po nasazení HTTPS aktualizuj:

### Mobilní app (`ctecka_etiket_flutter/lib/main.dart`):
```dart
// Pokud používáš subdomény:
const serverUrl = 'https://api.tvoje-domena.com';
const staticServerUrl = 'https://static.tvoje-domena.com';

// Nebo vše na jedné doméně:
const serverUrl = 'https://tvoje-domena.com';
const staticServerUrl = 'https://tvoje-domena.com'; // Caddy přesměruje /uploads/
```

### Admin panel (`ctecka_etiket_admin/lib/main.dart`):
```dart
// Pokud používáš subdomény:
const serverUrl = 'https://api.tvoje-domena.com';
const staticServerUrl = 'https://static.tvoje-domena.com';

// Nebo vše na jedné doméně:
const serverUrl = 'https://tvoje-domena.com';
const staticServerUrl = 'https://tvoje-domena.com'; // Caddy přesměruje /uploads/
```

## Použití self-signed certifikátu s IP adresou

### 1. Generuj certifikát pro IP:
```bash
cd ctecka_etiket_server
mkdir -p certs
openssl genrsa -out certs/server.key 2048
openssl req -new -x509 -key certs/server.key -out certs/server.crt -days 365 \
  -subj "/C=CZ/CN=34.122.70.47" \
  -addext "subjectAltName=IP:34.122.70.47"
```

### 2. Spusť Serverpod s HTTPS (vyžaduje úpravu kódu):
V `bin/main.dart` přidej SecurityContext (není standardní Serverpod feature).

### 3. Flutter aplikace - vypni cert validation (⚠️ POUZE PRO VÝVOJ!):

```dart
import 'dart:io';

void main() {
  // ⚠️ VAROVÁNÍ: Toto vypne všechny SSL kontroly!
  // NIKDY nepoužívej v produkci!
  HttpOverrides.global = MyHttpOverrides();
  
  runApp(MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
```

### 4. Lepší řešení - důvěřuj konkrétnímu certifikátu:

Načti `certs/server.crt` do aplikace a použij `SecurityContext.setTrustedCertificatesBytes()`.

## 🎯 Doporučení pro produkci:

**Pokud nemáš doménu:**
1. Získej zdarma subdoménu: [DuckDNS](https://www.duckdns.org/) nebo [Freenom](https://www.freenom.com/)
2. Nasměruj na tvoji IP: `moje-app.duckdns.org -> 34.122.70.47`
3. Použij Caddy (nejjednodušší) nebo Nginx + Let's Encrypt
4. ✅ Žádná varování, plná bezpečnost

## Rychlý návod s DuckDNS + Caddy:

```bash
# 1. Registruj se na duckdns.org a vytvoř subdoménu
# Např: moje-app.duckdns.org → 34.122.70.47

# 2. DŮLEŽITÉ: Otevři porty v firewallu (GCP/AWS/jiný cloud)
# Pro GCP - vytvoř firewall rule:
gcloud compute firewall-rules create allow-http-https \
  --allow tcp:80,tcp:443 \
  --source-ranges 0.0.0.0/0 \
  --description "Allow HTTP and HTTPS for Let's Encrypt"

# Nebo v GCP konzoli:
# VPC Network → Firewall → Create Firewall Rule
# - Name: allow-http-https
# - Targets: All instances
# - Source IP ranges: 0.0.0.0/0
# - Protocols and ports: tcp:80,tcp:443

# Pro lokální firewall (ufw):
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw reload

# Ověř, že porty jsou otevřené:
sudo ufw status

# 3. Na serveru nainstaluj Caddy
sudo apt install caddy

# 3. Zkopíruj Caddyfile na server
# Lokálně v projektu je připravený Caddyfile - uprav doménu a nahraj na server:
scp Caddyfile root@34.122.70.47:/etc/caddy/Caddyfile

# Nebo vytvoř přímo na serveru:
sudo nano /etc/caddy/Caddyfile
# Vlož obsah z Caddyfile v projektu (změň doménu!)

# 4. Spusť Caddy
sudo systemctl restart caddy

# 5. Zkontroluj logy pokud něco nefunguje:
sudo journalctl -u caddy -f

# 6. Hotovo! Caddy automaticky získá Let's Encrypt certifikát
# Aplikace budou používat: https://moje-app.duckdns.org
```

## 🔥 Řešení problému s firewallem

**Příznaky:**
- `Timeout during connect (likely firewall problem)`
- Let's Encrypt se nemůže připojit k serveru

**Řešení - Otevři porty 80 a 443:**

### GCP (Google Cloud Platform):

**Webová konzole:**
1. Jdi na [GCP Console](https://console.cloud.google.com/)
2. **VPC Network** → **Firewall** → **Create Firewall Rule**
3. Nastavení:
   - **Name:** `allow-http-https`
   - **Targets:** All instances (nebo vyber konkrétní instance)
   - **Source IP ranges:** `0.0.0.0/0` (celý internet)
   - **Protocols and ports:** Checkni TCP, zadej: `80,443`
4. Klikni **Create**

**Příkazová řádka:**
```bash
# Otevři porty 80 a 443
gcloud compute firewall-rules create allow-http-https \
  --allow tcp:80,tcp:443 \
  --source-ranges 0.0.0.0/0 \
  --description "Allow HTTP and HTTPS for Caddy and Let's Encrypt"

# Ověř pravidla
gcloud compute firewall-rules list
```

### Lokální firewall (ufw) na serveru:

```bash
# Zkontroluj stav
sudo ufw status

# Povolit HTTP a HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Aplikuj změny
sudo ufw reload

# Ověř
sudo ufw status numbered
```

### AWS (EC2 Security Groups):

1. EC2 Dashboard → Security Groups
2. Vyber security group pro tvoji instanci
3. **Inbound Rules** → **Edit inbound rules**
4. Přidej:
   - Type: HTTP, Port: 80, Source: 0.0.0.0/0
   - Type: HTTPS, Port: 443, Source: 0.0.0.0/0

### Test otevřených portů:

```bash
# Z lokálního počítače otestuj připojení
telnet ctecka-etiket.duckdns.org 80
telnet ctecka-etiket.duckdns.org 443

# Nebo s nmap
nmap -p 80,443 ctecka-etiket.duckdns.org
```

**Po otevření portů:**
```bash
# Restart Caddy a sleduj logy
sudo systemctl restart caddy
sudo journalctl -u caddy -f

# Caddy by měl úspěšně získat certifikát během ~30 sekund
```
