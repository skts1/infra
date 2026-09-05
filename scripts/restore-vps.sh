#!/bin/bash
# restore-vps.sh — rebuild SIKRITS web server from this repo
# Run on a fresh Ubuntu/Debian VPS as root
# Usage: bash restore-vps.sh your.domain.com

set -euo pipefail

DOMAIN="${1:-sikrits.com}"
WWW_DOMAIN="www.${DOMAIN}"

echo "[1/6] Installing nginx + certbot..."
apt-get update -qq
apt-get install -y -qq nginx certbot python3-certbot-nginx

echo "[2/6] Copying nginx config from this repo..."
cp nginx/sikrits.com.conf /etc/nginx/sites-available/sikrits.com
ln -sf /etc/nginx/sites-available/sikrits.com /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

echo "[3/6] Setting up web root..."
mkdir -p /var/www/${DOMAIN}/public
mkdir -p /var/www/letsencrypt
# Placeholder index — replace with real site
cat > /var/www/${DOMAIN}/public/index.html <<'HTML'
<!doctype html><html><head><title>SIKRITS</title></head>
<body><h1>SIKRITS</h1><p>Restore in progress...</p></body></html>
HTML

echo "[4/6] Testing nginx config..."
nginx -t

echo "[5/6] Reloading nginx..."
systemctl reload nginx

echo "[6/6] Requesting Let's Encrypt cert (CRITICAL: includes www SAN)..."
echo "    This is the lesson from Aug 18 — cert must include BOTH domains"
certbot --nginx \
    -d "${DOMAIN}" \
    -d "${WWW_DOMAIN}" \
    --non-interactive --agree-tos -m info@sikrits.com

echo ""
echo "✓ Restore complete. Verify:"
echo "  curl -I https://${DOMAIN}/"
echo "  curl -I https://${WWW_DOMAIN}/"
echo ""
echo "Cert auto-renews via certbot.timer. Verify with:"
echo "  systemctl status certbot.timer"
echo "  certbot certificates"
