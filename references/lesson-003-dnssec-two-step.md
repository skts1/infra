# DNSSEC Requires Registrar DS Record (Lesson 8)

## Date: 2026-09-05

## Problem
DNSSEC enabled in Cloudflare but DNS resolution intermittent for some recursive resolvers.

## Root Cause
DNSSEC is a two-step chain:
Step 1: Enable DNSSEC signing in Cloudflare (zone → DNS → DNSSEC → Enable)
Step 2: Add DS record at your REGISTRAR (Squarespace for sikrits.com)

Without Step 2, the DS record at the parent zone (.com) does not chain to your signed zone.
Result: DNSSEC validation fails for strict resolvers.

## For sikrits.com (Squarespace registrar):
1. Cloudflare dashboard → sikrits.com → DNS → DNSSEC → Enable
2. Copy the DS record details from Cloudflare
3. Squarespace → Domain settings → Advanced DNS → DS Records → Add
4. Paste DS record from Cloudflare
5. Wait 24-48h for propagation

## To verify:
dig ds.sikrits.com → should return DS record
dig dnskey.sikrits.com → should return DNSKEY

## Alternative: Disable DNSSEC if registrar DS not possible
Cloudflare → DNS → DNSSEC → Disable

## Status: OPEN — requires Squarespace access + CF token rotation
