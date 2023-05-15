# Abstract
- Script to issue SSL certificates in a powershell.
- Use ADCS certificate templates.

## CSR Issuance in Windows
```bat
certreq -new -f CSR_Base.inf CSR.req
```

## Check if the ADCSAdministration module is available
```Powershell
Get-Module -ListAvailable -Name ADCSAdministration
```

## Jumble reference
- https://www.vwnet.jp/windows/WS16/2017092701/Certreq.htm
- https://learn.microsoft.com/ja-jp/azure/vpn-gateway/vpn-gateway-certificates-point-to-site
- https://www.nextdoorwith.info/wp/se/how-to-create-self-signed-rootca-server-client-certificate/

## Microsoft Official Powershell Reference
- https://learn.microsoft.com/en-us/powershell/module/pki/get-certificate?view=windowsserver2022-ps