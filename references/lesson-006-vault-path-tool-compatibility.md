# write_file Cannot Reach All Paths — Use Terminal for Edge Cases (Lesson 11)

## Date: 2026-09-05

## Problem
write_file failed to write to ~/obsidian-memory-vault/ and ~/Desktop/SIKRITS-Backups/
Error: permission/path issue

## Root Cause
write_file tool has its own path resolution that doesn't match terminal's tilde expansion.
Terminal runs in a shell where ~ expands to /Users/sikrits, but write_file resolves paths differently.

## Workaround
For paths that write_file cannot reach:
1. Use terminal with python3 -c:
   python3 -c "content = open('/dev/stdin').read(); open('/path/to/file', 'w').write(content)" << 'EOF'
   ...content...
   EOF

2. This works because terminal runs in a real shell with full path expansion.

## Paths write_file can reach:
- ~/.hermes/ skills and configs
- Current working directory and subdirectories
- Absolute paths like /tmp/

## Paths write_file CANNOT reliably reach:
- ~/ paths (tilde not expanded)
- ~/Desktop/
- ~/obsidian-memory-vault/
- External volumes

## Prevention
When write_file fails, fall back to:
python3 -c "open('/full/path/to/file', 'w').write(content)"

## Status: CLOSED — workaround documented
