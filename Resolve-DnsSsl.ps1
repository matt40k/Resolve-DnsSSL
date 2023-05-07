
<#PSScriptInfo

.VERSION 1.0

.GUID f132689b-b5f4-438a-bd99-fe9f2b0334fa

.AUTHOR matt@matt40k.uk

.COMPANYNAME

.COPYRIGHT

.TAGS

.LICENSEURI https://raw.githubusercontent.com/matt40k/Resolve-DnsSSL/main/LICENSE

.PROJECTURI https://github.com/matt40k/Resolve-DnsSSL

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Inital release - supports CloudFlare, Google, Quad9

.PRIVATEDATA

#> 


<#
 .Synopsis
  Resolve a DNS record over HTTPS

 .Description
  DNS over HTTPS (DoH) uses the HTTPS protocol for sending and retrieving encrypted DNS queries and responses. The DoH protocol has been published as a proposed standard by the IETF as RFC 8484.

 .Parameter Domains
  DNS domains

 .Parameter Type
  DNS record types - default is A record.

 .Parameter Provider
  DNS over HTTPS resolver provider - options are Cloudflare, Google or Quad9. Default is Cloudflare

 .Example
   # Show a default display of this month.
   Resolve-DnsSSL -domains github.com 

 .Example
   # Display a date range.
   Resolve-DnsSSL -domains github.com -Type A -Provider Google

#>
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
Function Resolve-DnsSSL {
 param (
	[Parameter(Mandatory=$True)]
	[array]$domains,

	[Parameter()]
	[array]$Type = 'A',
 
	[Parameter()]
	[ValidateSet("CloudFlare","Google","Quad9")]
	[String]$Provider = "CloudFlare"
 )

	Foreach ($domain in $domains) {
	
		switch ($Provider) {
			"CloudFlare" {$url = 'https://cloudflare-dns.com/dns-query?name='+$domain+'&type='+$type; break}
			"Google"     {$url = 'https://dns.google.com/resolve?name=' + $domain + '&type='+$type; break}
			"Quad9"      {$url = 'https://dns.quad9.net:5053/dns-query?name=' + $domain; break}
		}
    
		$header = @{"accept"="application/dns-json"}
		$response = (Invoke-WebRequest -Uri $url -Headers $header -UseBasicParsing)
	
		if ($response.Content.GetType().name -eq "Byte[]") {
			$json = [System.Text.Encoding]::UTF8.GetString($response.Content)
		}
		Else {
			$json = $response.Content
		}
	
		$content = $json | ConvertFrom-Json
		$content.Answer
	}
}
