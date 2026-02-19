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
- Username: admin / Password: adminpassword
- Org: cyberbench, Bucket: metrics

### Nuclei
Fast vulnerability scanner.
- Execute: `docker exec nuclei nuclei -u <target>`
- Templates: `data/nuclei/`

### OWASP ZAP
DAST proxy for web application security testing.
- URL: http://localhost:8090
- API enabled

## Install
```bash
npm run env           # Copy .env.example to .env
npm install           # Install dependencies
npm start             # Start all services
```

## Run
```bash
npm run env           # Copy .env.example to .env
npm start             # Start all services
npm stop              # Stop all services
npm run restart       # Restart all services
npm run log:dd        # Tail DefectDojo logs
npm run init:dd       # Initialize DefectDojo
```
