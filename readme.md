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

### How to get a self-signed certificate
```Powershell
$certStore = "cert:\LocalMachine\My" # Certificate storage location
$certPassword = ConvertTo-SecureString -String "P@ssw0rd" -Force -AsPlainText # Certificate Password
New-SelfSignedCertificate -DnsName "ADCS-Client" -CertStoreLocation $certStore -FriendlyName "ADCS Client Certificate" -Type CodeSigningCert -Subject "CN=ADCS-Client" -KeyUsage DigitalSignature, KeyEncipherment -NotAfter (Get-Date).AddYears(5) -KeySpec Signature -TextExtension @("2.5.29.17={text}DNS=ADCS-Client", "2.5.29.37={text}1.3.6.1.5.5.7.3.2", "2.5.29.19={text}") -KeyExportPolicy Exportable -KeyAlgorithm RSA -KeyLength 2048 -KeyUsageProperty All -HashAlgorithm SHA256 -KeyProtection $certPassword
```

### Check Powershell version
```Powershell
$PSVersionTable.PSVersion
```
