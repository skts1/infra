# Lesson 007 — CF Token Auth: Wrong Format = Wrong Diagnosis

**Date:** 2026-09-05
**Severity:** P0 — wasted 30+ minutes on wrong diagnosis
**Status:** RESOLVED — correct auth confirmed

## What Happened

Two Cloudflare tokens were declared "DEAD" based on HTTP 401 responses.
They were actually fully valid — the auth header format was wrong.

## The Two CF Auth Methods

| Token Type | Prefix | Correct Header | Wrong Header |
|---|---|---|---|
| User API Token | `cfut_` | `Authorization: Bearer <token>` | `X-Auth-Key: <token>` |
| Global API Key | `cfk_` | `X-Auth-Key: <key>` + `X-Auth-Email: <email>` | `Authorization: Bearer <key>` |

## Verdict

- `CLOUDFLARE_API_TOKEN` (cfut_): **VALID** — HTTP 200 with Bearer auth
- `CLOUDFLARE_GLOBAL_API_KEY` (cfk_): **VALID** — HTTP 200 with X-Auth-Key header
- `GH_TOKEN` + `GITHUB_TOKEN`: **DEAD** — confirmed with Bearer auth

## Anti-pattern

Never test a token with only ONE auth format and declare it dead.
Always verify: does this token type use Bearer or X-Auth-Key?

## DMARC Was Also Fine

`p=none` was never the actual record. Live dig returned `p=reject`.
CF API showed `p=reject` with `"mode":"strict"`. DNS caching caused the confusion.

## Files Modified This Session

- CF CNAME `secreta.sikrits.com` created
- DNSSEC enabled in CF
- DMARC restored to `p=reject; aspf=s; adkim=s`

## Key Principle

**Test with correct auth BEFORE declaring a token dead.**
The API docs and token type determine the auth format — not the variable name.
