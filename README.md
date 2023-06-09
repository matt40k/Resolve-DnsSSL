# Resolve-DnsSSL
Simple PowerShell module to lookupo DNS records using public DNS-over-HTTPS (DoH) resolvers.

Supports the following public DNS-over-HTTPS (DoH) resolvers
- [1.1.1.1](https://1.1.1.1) provided by [CloudFlare](https://www.cloudflare.com)
- [Google](https://dns.google)
- [Quad9](https://quad9.net)

## Installation
Via [PowerShell Gallery](https://www.powershellgallery.com/packages/Resolve-DnsSsl/)
```
Install-Script -Name Resolve-DnsSsl -Scope CurrentUser
```

## Usage
```
Resolve-DnsSsl -domains "google.com" -Provider CloudFlare
```
