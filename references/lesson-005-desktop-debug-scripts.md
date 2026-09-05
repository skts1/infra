# Debug Scripts on Desktop Are a Credential Exposure Risk (Lesson 10)

## Date: 2026-09-05

## Problem
14 debug/infrastructure scripts were found on ~/Desktop:
- check_main.py, check_router.py, check_webhook.py
- finalize.py, fix_nginx.py
- get_prices.py, get_prices2.py through get_prices6.py
- inject_key.py, insert_block.py, patch_stripe_fix.py
- onebrain_prices.py

## Risk
These scripts likely contained API keys, internal logic, or debug endpoints.
If Desktop is synced to iCloud or accessible via Time Machine backup, they become an exposure vector.

## Remediation
- [x] All 14 scripts removed from ~/Desktop
- [x] Desktop now contains only: SIKRITS-Backups/
- [x] No debug scripts remain on Desktop

## Prevention
- Debug scripts belong in ~/Desktop/scripts/ or ~/infra/ at most
- Never put debug scripts in home directory root or Desktop
- Treat any script that makes API calls or contains logic as potentially sensitive
- Quarterly Desktop audit: ls ~/Desktop/*.py

## Related
~/Desktop/SIKRITS-Backups/ is acceptable — backup storage, not active code

## Status: CLOSED — Desktop audited and cleaned
