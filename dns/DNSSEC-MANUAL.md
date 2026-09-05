# DNSSEC — Manual Step Required

**Status**: Manual step required — cfut_ API token cannot enable DNSSEC (needs Global API Key)

## Why DNSSEC Matters
DNSSEC authenticates DNS responses. Without it, an attacker who compromises a nameserver can forge DNS records and redirect your traffic, email, or anything else to malicious destinations.

## Steps to Enable

### Step 1: Enable DNSSEC in Cloudflare Dashboard
1. Log into dash.cloudflare.com
2. Select **sikrits.com**
3. Go to **DNS** → **Advanced** (or "DNSSEC" tab)
4. Click **Enable DNSSEC**
5. Copy the **DS record** details shown:
   - Algorithm
   - Digest type
   - Digest
   - Key tag

### Step 2: Add DS Record to Squarespace (Domain Registrar)
1. Log into squarespace.com → Domains
2. Select **sikrits.com**
3. Go to **DNS Settings**
4. Find **DS Records** section
5. Add the DS record from Cloudflare:
   - Flags: 257 (or as shown)
   - Protocol: 3
   - Algorithm: (as shown in Cloudflare)
   - Key tag: (as shown in Cloudflare)
   - Digest type: (as shown — usually SHA-256)
   - Digest: (the full digest string from Cloudflare)

### Step 3: Verify
After DS records propagate (24-48 hours):
- Use: https://dnsviz.net/d/sikrits.com/dnsviz/
- Or: https://dnschecker.org/#dnssec/sikrits.com

## References
- Cloudflare DNSSEC docs: https://developers.cloudflare.com/dns/additional-options/dnssec/
- DS record format: RFC 4034
