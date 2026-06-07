# Security Policy

## Scope

builder-design is a skills and agents pack — it contains no executable code deployed to production, no authentication, and no data storage. Security issues are limited to:

- **Malicious content in skill files** — skills that instruct agents to exfiltrate data or take harmful actions
- **Install script vulnerabilities** — `install.sh` or `install.ps1` executing unintended commands
- **CI/CD vulnerabilities** — GitHub Actions workflows with privilege escalation

## Reporting

Report security issues privately via GitHub's [Security Advisories](https://github.com/RBraga01/builder-design/security/advisories/new).

Do not open public issues for security vulnerabilities.

## Response

Security reports are reviewed within 7 days. Critical issues (malicious skill content, install script RCE) are patched within 48 hours of confirmation.
