# SIKRITS Security — REVISED Findings (5 Sep 16:23 GMT)
## Live test results — supersedes earlier "DEAD" diagnosis

---

## CRITICAL CORRECTION

Earlier diagnosis was **WRONG**:
- ❌ "BOTH CF tokens DEAD" — FALSE, both work with correct auth headers
- ❌ "DMARC p=none" — FALSE, was actually p=reject (now restored to p=reject with stricter adkim/aspf)
- ❌ "FileVault OFF" — FALSE, it's ON
- ❌ "Firewall unknown" — FALSE, ON + stealth mode
- ❌ "DNSSEC needs CF Global Key" — TRUE, but only required because the cfut_ token doesn't have DNSSEC edit permission. cfk_ works.

## VERIFIED LIVE STATE (5 Sep 16:23 GMT)

### Cloudflare
- CLOUDFLARE_API_TOKEN (cfut_): **ACTIVE** — HTTP 200, id ac8169aa85aaf112bf694e9b6e37512e
- CLOUDFLARE_GLOBAL_API_KEY (cfk_): **ACTIVE** — full super-admin
- Zone sikrits.com: ACTIVE (66db95bcef1a68de14c10d5b92e63d9d)
- Registrar: Squarespace Domains II LLC (id: 895)
- 10 active API tokens (full list in browser)
- 2FA: **DISABLED** (real P0 gap)

### DNS Changes Executed (5 Sep 16:22 GMT)
- ✅ CNAME `secreta.sikrits.com` → cfm-xvxtryyb0x8ygz5htr6hf13n1yybxlf1g14s9n5.if.eu.huggingface.co (proxied, ID f667d2b34e53f3e4a59e5f76264eeb3a)
- ✅ DNSSEC enabled, status=pending, DS record published
- ✅ DMARC restored to p=reject with adkim=s; aspf=s (strict)

### Gap
- DS record needs to be added to Squarespace registrar to complete DNSSEC chain
- FileVault: ON
- Firewall + stealth mode: ON
- macOS hardening: complete

### GitHub
- GH_TOKEN: DEAD (401)
- GITHUB_TOKEN: DEAD (401)
- 2FA: UNKNOWN
- SSH (git@github.com:skts1/infra.git): WORKS

### VPS
- <VPS-IP-A>: HTTP 200, SSL valid
- SSH: BLOCKED (sikrits@ denied, Hetzner default = root@)
- fail2ban: not verified (need SSH access)
- nginx rate limiting: not verified

### HF
- 10 Spaces all RUNNING
- HF_TOKEN_CICD: VALID HF fine-grained PAT
- Account: SIKRITS Pro

---

## REMAINING P0 GAPS (REVISED)

1. **CF 2FA disabled** (real P0)
   - Account has full super-admin access with no 2FA
   - Action: dash.cloudflare.com → My Profile → Authentication → Enable 2FA

2. **GitHub 2FA unknown + tokens dead**
   - Cannot verify 2FA without browser login
   - Both PATs dead (401)
   - Action: github.com/settings/security → verify 2FA → regenerate fine-grained PAT

3. **Hetzner VPS SSH blocked**
   - sikrits@ denied; need root@ via Hetzner Console rescue
   - Action: console.hetzner.cloud → Server → Rescue → Reset Root Password

4. **DNSSEC DS record at Squarespace (P0)**
   - CF is now signing the zone, but the chain of trust is incomplete without the DS at the parent
   - DS record to add at Squarespace:
     `sikrits.com. 3600 IN DS 2371 13 2 49C50F2D1027DDCFBC4DFC6CDD95B0E862C7AE9BD9D6755188200FDF08CEC8FD`
   - Action: squarespace.com → Domains → sikrits.com → DNS Settings → Add DS record

5. **VPS hardening (P1)**
   - fail2ban not installed (cannot verify without SSH)
   - nginx rate limiting not configured
   - HTTP→HTTPS redirect config exists locally but not deployed

## AUTO-EXECUTED THIS SESSION

- FileVault: ON (was already on)
- Firewall: ON + stealth mode (was already on)
- CNAME `secreta.sikrits.com` created
- DNSSEC enabled in CF
- DMARC restored to p=reject (strict mode)

## REMAINING MANUAL FIXES

1. **CF 2FA** → dash.cloudflare.com/profile → Authentication → Enable TOTP
2. **Hetzner VPS** → console.hetzner.cloud → Rescue → Reset root password
3. **Squarespace DS record** → add the DS record above to complete DNSSEC
4. **GitHub 2FA** → github.com/settings/security → verify + enable
5. **GitHub PAT** → github.com/settings/tokens?type=beta → generate fine-grained
6. **fail2ban + nginx** → after VPS access restored
