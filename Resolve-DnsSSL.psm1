<#
 .Synopsis
  Resolve a DNS record over HTTPS

 .Description
  Displays a visual representation of a calendar. This function supports multiple months
  and lets you highlight specific date ranges or days.

 .Parameter Domains
  DNS domains

 .Parameter Type
  DNS record types - default is A record.

 .Parameter Provider
  DNS over HTTPS resolver provider - options are Cloudflare, Google or Quad9. Default is Cloudflare

 .Example
   # Show a default display of this month.
   Provider -domains github.com 

 .Example
   # Display a date range.
   Provider -domains github.com -Type A -Provider Google

#>
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
