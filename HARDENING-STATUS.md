# SIKRITS Production Hardening — 2026-09-05

## Completed Hardening Actions

| Gap | Fix | Status |
|-----|-----|--------|
| No CAA record | Added: issue/issuewild/iodef for Let's Encrypt only | ✅ DONE |
| SPF softfail | Hardened to -all (hardfail) | ✅ DONE |
| Backup agent too small | Improved script with broader sources | ✅ DONE |
| SSL guardian missing www | v2 script monitors www + apex | ✅ DONE |
| Secrets scattered | Vaulted to ~/infra/secrets/ | ✅ DONE |
| No DNS change checklist | Lesson: always READ before WRITE | ✅ DONE |
| DNSSEC | Manual step in CF dashboard + Squarespace | ⏳ MANUAL |
| VPS SSH rate limiting | Requires VPS SSH access | 🔒 BLOCKED |
| HTTPS redirect | Requires VPS SSH access | 🔒 BLOCKED |
| 9 missing credentials | Located: CF token, Stripe keys | ⚠️ PARTIAL |

## Live Monitoring
- **SSL Guardian v2**: Every 15 min, monitors www.sikrits.com + sikrits.com
- **Cron ID**: `21e627b167cb`
- **Alert**: Silent on healthy; Telegram + home channel on failure

## DNS Records Now Active
- `sikrits.com CAA 0 issue "letsencrypt.org"`
- `sikrits.com CAA 0 issuewild "letsencrypt.org"`
- `sikrits.com CAA 0 iodef "mailto:info@sikrits.com"`
- `sikrits.com TXT v=spf1 include:zohomail.eu include:resend.com -all`
- `_dmarc.sikrits.com TXT v=DMARC1; p=reject; ...` (pre-existing)

## Still Needed
1. **DNSSEC**: CF dashboard → enable → Squarespace DS record
2. **VPS SSH**: Authorize SSH key for sikrits@<VPS-IP-A>
3. **fail2ban + rate limiting**: VPS config (needs SSH)
4. **HTTPS redirect**: nginx on origin (needs SSH)
5. **Offsite backup**: Configure rclone for off-machine destination
6. **GitHub 2FA**: Verify skts1 account has 2FA enabled

## Lessons Learned
Written to: `~/.hermes/skills/security/security-audit/references/`
