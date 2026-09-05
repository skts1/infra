# SIKRITS nginx config — reconstituted backup

**Purpose:** If the VPS at <VPS-IP-B> ever dies, this repo has everything
needed to rebuild the web server in under 5 minutes.

## What's here

- `nginx/sikrits.com.conf` — the full server block, reconstructed from the
  public response headers at https://www.sikrits.com (sampled Sep 5, 2026)
- `scripts/restore-vps.sh` — one-command VPS rebuild
- `docs/incident-2026-08-18.md` — what went wrong + how to prevent it

## The Aug 18 lesson

The cert at the time was `CN=sikrits.com` only — NO `www.sikrits.com` SAN.
Browsers visiting `https://www.sikrits.com` saw a hostname mismatch and
showed a security warning.

**Root cause:** Someone ran `certbot -d sikrits.com` without `-d www.sikrits.com`,
then either:
1. The cert was originally for a domain that didn't need www, and the nginx
   `server_name` was updated later without re-issuing the cert
2. The cert was issued before the `www` subdomain was added to nginx

**The fix that worked:** `certbot --expand -d sikrits.com -d www.sikrits.com`

**The lesson:** When you ever run certbot, ALWAYS include every name in the
nginx `server_name` directive. This is now automated in `restore-vps.sh` line
"[6/6]".

## How to use

```bash
# On a fresh VPS as root:
bash scripts/restore-vps.sh sikrits.com
```

This will:
1. Install nginx + certbot
2. Copy the server block from this repo
3. Set up the web root
4. Test config
5. Reload nginx
6. Issue a cert for BOTH sikrits.com AND www.sikrits.com

## Ongoing monitoring

- `~/.hermes/scripts/sikrits-ssl-guardian.sh` (cron job `21e627b167cb`) runs
  every 15 min and alerts if the cert issuer changes to non-LE, SANs drop a
  hostname, or HTTPS stops returning 200.

## If the cert is wrong

```bash
ssh root@<VPS-IP-B>
certbot delete --cert-name sikrits.com
certbot --nginx -d sikrits.com -d www.sikrits.com
systemctl reload nginx
```

Then verify:
```bash
curl -I https://www.sikrits.com
openssl s_client -connect www.sikrits.com:443 -servername www.sikrits.com < /dev/null 2>/dev/null | openssl x509 -noout -ext subjectAltName
```
