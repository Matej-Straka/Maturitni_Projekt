# HTTPS Konfigurace

## Generování self-signed certifikátu (pro vývoj)

```bash
cd ctecka_etiket_server
mkdir -p certs

# Generuj privátní klíč
openssl genrsa -out certs/server.key 2048

# Generuj certifikát (platný 365 dní)
openssl req -new -x509 -key certs/server.key -out certs/server.crt -days 365 \
  -subj "/C=CZ/ST=Prague/L=Prague/O=Development/CN=localhost"
```

## Pro produkci

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

```
tvoje-domena.com {
    reverse_proxy localhost:8080
}
```

Caddy automaticky získá a obnoví Let's Encrypt certifikáty!

## Aktualizace URL v aplikacích

Po nasazení HTTPS aktualizuj:

### Mobilní app (`ctecka_etiket_flutter/lib/main.dart`):
```dart
const serverUrl = 'https://tvoje-domena.com';
```

### Admin panel (`ctecka_etiket_admin/lib/main.dart`):
```dart
const serverUrl = 'https://tvoje-domena.com';
const staticServerUrl = 'https://static.tvoje-domena.com';
```
