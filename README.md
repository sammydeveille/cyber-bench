# CyberSecurity Benchmark 
A lightweight, Docker Compose-based boilerplate for repeatable security testing.

Spin up vulnerable targets, run DAST/penetration/load tests, and aggregate findings in DefectDojo for deduplicated tracking across multiple sites and iterations.

## Overview
- [About](#about)
- [Structure](#structure)
- [Install](#install)
- [Services](#services)

## About
CyberSecurity Benchmark provides a Docker-based environment for security testing with:
- **DefectDojo**: Centralized vulnerability management and deduplication
- **InfluxDB**: Metrics storage for load testing results
- **Nuclei**: Fast vulnerability scanner
- **OWASP ZAP**: DAST proxy for web application security testing
- **k6**: Load testing tool

## Structure
```
cyber-bench/
├── infra/
│   └── docker.yml
├── .env.example 
├── package.json
└── README.md
```

## Install
```bash
npm run env              # Copy .env.example to .env
npm install              # Install dependencies
npm start                # Start all services
```

## Services

- **DefectDojo**: Vulnerability tracking [http://localhost:8080](http://localhost:8090)
- **InfluxDB**: Time-series db [http://localhost:8086](http://localhost:8086)
- **Nuclei**: Vulnerability scanner `nuclei -u <target>`
- **OWASP Zap**: DAST testing [](http://localhost:8090)