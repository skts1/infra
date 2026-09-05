# Misnamed Env Vars Create Confusion (Lesson 9)

## Date: 2026-09-05

## Problem
HF_TOKEN_CICD in ~/.hermes/.env was assumed to be a Cloudflare token during a prior session.
The variable name suggested it was a HuggingFace CI/CD token, but the value started with cfut_.

## Root Cause
Variable was named HF_TOKEN_CICD but actually contained a cfut_ Cloudflare token.
This caused a cascade of failed API attempts with wrong auth headers.

## Token Prefix Reference
| Prefix | Provider | Auth Format |
|--------|----------|-------------|
| hf_ | HuggingFace | Bearer token |
| cfut_ | Cloudflare (zone token) | X-Auth-Key + X-Auth-Email |
| cfk_ | Cloudflare (global key) | Bearer token |
| ghp_ | GitHub (PAT) | Bearer token |
| gho_ | GitHub (OAuth) | Bearer token |

## Action Items
- [x] Check variable NAME and VALUE independently
- [x] Never trust the name — always check the prefix of the actual value
- [x] Rename HF_TOKEN_CICD to CLOUDFLARE_ZONE_TOKEN since it holds a cfut_ value
- [x] Use meaningful variable names: HF_TOKEN_CICD for HF, CF_ZONE_TOKEN for cfut_

## Prevention
Before using any token from .env:
1. Print first 3-5 chars to confirm prefix
2. Match prefix to known provider patterns
3. Use correct auth header format for that prefix

## Status: CLOSED — prefix-checking habit established
