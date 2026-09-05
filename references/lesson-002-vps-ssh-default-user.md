# VPS SSH Default User (Lesson 7)

## Date: 2026-09-05

## Problem
VPS SSH access denied for user sikrits@<VPS-IP-A>.

## Root Cause
Hetzner cloud servers default to root user, not a custom username.
ssh -o ConnectTimeout=5 sikrits@<VPS-IP-A> → Permission denied (publickey)
Solution: try root@<VPS-IP-A>

## Recovery Steps
1. Log into Hetzner Robot console: console.hetzner.cloud
2. Select project → Select server → Access tab
3. Use Reset root password or add SSH key via console
4. Try: ssh root@<VPS-IP-A>
5. Once in: add your SSH key to /root/.ssh/authorized_keys
6. Add non-root user for daily SSH: useradd -m -s /bin/bash deploy
7. Grant sudo: usermod -aG sudo deploy
8. Copy SSH key: cp /root/.ssh/authorized_keys /home/deploy/.ssh/authorized_keys

## Prevention
- Document expected SSH usernames per provider
- Hetzner: root (default)
- AWS: ubuntu / ec2-user
- DigitalOcean: root

## Status: CLOSED — recovery steps documented
