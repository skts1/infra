# CF Token Auth Format (Lesson 6)

## Date: 2026-09-05

## Problem
Cloudflare API calls failing with auth errors. Both cfut_ zone token and cfk_ global key returning 401/9106.

## Root Cause
cfut_ tokens require X-Auth-Key + X-Auth-Email headers (older API v4 format), NOT Bearer token header.
Bearer token works only with cfk_ global keys AND only with cfk_ format.
The cfut_ prefix was misidentified as a Cloudflare token when HF_TOKEN_CICD (a valid HF token) was stored in the same .env.

## Correct Auth Patterns

### Cloudflare cfut_ zone token:
curl -H "X-Auth-Key: $CLOUDFLARE_API_TOKEN"      -H "X-Auth-Email: info@sikrits.com"      "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records"

### Cloudflare cfk_ global key (Bearer):
curl -H "Authorization: Bearer $CLOUDFLARE_GLOBAL_API_KEY"      "https://api.cloudflare.com/client/v4/zones"

## Action Items
- [x] Verify cfut_ vs cfk_ format before making API calls
- [x] Always use X-Auth-Key for cfut_ tokens
- [x] Note: HF tokens are hf_ prefix, CF tokens are cfut_ or cfk_ prefix
- [x] Misnamed env vars (HF_TOKEN_CICD containing cfut_) should be renamed

## Status: CLOSED
