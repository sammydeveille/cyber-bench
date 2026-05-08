# CyberSecurity Benchmark 
A lightweight, Docker Compose-based boilerplate for repeatable security testing.

## Overview
- [About](#about)
- [Install](#install)
- [Scripts](#scripts)

## About

### DefectDojo
Vulnerability management platform for tracking security findings.
- URL: http://localhost:8080
- Default: admin/admin (change on first login)
- Stack: Django + nginx + PostgreSQL + Redis

### InfluxDB
Time-series database for load testing metrics.
- URL: http://localhost:8086
- Credentials configured in `.env`
- Org: cyberbench, Bucket: metrics

### Nuclei
Fast vulnerability scanner.
- Execute: `docker exec nuclei nuclei -u <target>`
- Templates: `data/nuclei/`

### OWASP ZAP
DAST proxy for web application security testing.
- URL: http://localhost:8090
- API enabled

### Juice Shop
Intentionally vulnerable web application used as a scan target.
- URL: http://localhost:3000

## Install
```bash
npm run env           # Copy .env.example to .env
npm start             # Start all services
npm run init:dd       # Collect static files for DefectDojo
```

Edit `.env` and set `DD_API_TOKEN` to your DefectDojo API key (found under Admin → API v2 Key after first login).

## Run
```bash
npm start             # Start all services
npm stop              # Stop all services
npm run restart       # Restart all services
npm run log:dd        # Tail DefectDojo logs
npm run init:dd       # Initialize DefectDojo static files
npm run init:dd:user  # Create a DefectDojo superuser
```

## Scripts

Unified scan script that runs a tool against a target and imports results into DefectDojo.

**Prerequisites:** Set `DD_API_TOKEN` in `.env` and create a Product + Engagement in DefectDojo.

```bash
./scripts/scan.sh <tool> <target> <engagement_id>
```

**Available tools:** `nuclei`, `nmap`, `nikto`, `zap`

**Example** (scan Juice Shop and import to engagement 1):
```bash
./scripts/scan.sh nuclei http://juice-shop:3000 1
./scripts/scan.sh nmap juice-shop 1
./scripts/scan.sh nikto http://juice-shop:3000 1
./scripts/scan.sh zap http://juice-shop:3000 1
```
