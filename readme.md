# Abstract
## makeClientCrt.ps1
- Script to issue SSL certificates in a powershell.
- Using ADCS certificate templates.

## CSR Issuance in Windows
```bat
certreq -new -f CSR_Base.inf CSR.req
```

## Check if the ADCSAdministration module is available
```Powershell
Get-Module -ListAvailable -Name ADCSAdministration
```

### Get a self-signed certificate
```Powershell
$CertDir = 'cert:\LocalMachine\My'
$FrdlNm = '[Cert Friendly Name]'
$Cn = '[Cert Common Name]'
$DnsName = '[Cert Dns Name]'
New-SelfSignedCertificate -CertStoreLocation $CertDir `
 -FriendlyName $FrdlNm `
 -Type CodeSigningCert `
 -Subject "CN=$Cn" `
 -KeyUsage DigitalSignature, KeyEncipherment `
 -NotAfter (Get-Date).AddYears(5) `
 -KeySpec Signature `
 -TextExtension @("2.5.29.17={text}DNS=$DnsName", "2.5.29.37={text}1.3.6.1.5.5.7.3.2", "2.5.29.19={text}") `
 -KeyExportPolicy Exportable `
 -KeyAlgorithm RSA -KeyLength 2048 `
 -KeyUsageProperty All `
 -HashAlgorithm SHA256 `
 -KeyProtection 'None'
```

### Get a local ca signed certificate by use of cert-template and user-list.csv
```Powershell
$userList = Import-Csv -Path ".\user-list.csv"
foreach ($user in $userList) {
  $Cn = $user.CN
  $DnsName = $user.DNS
  $CertDir = "cert:\LocalMachine\My"
  $Tmplt = "[Template Name]"
  Get-Certificate -Template $Tmplt `
   -Subject CN=$Cn `
   -CertStoreLocation $CertDir `
   -DnsName $DnsName
}
```
user-list.csv
```csv
CN,DNS,Email
CommonName1,DnsName1,1@example.local
CommonName2,DnsName2,2@example.local
```

### Check Powershell version
```Powershell
$PSVersionTable.PSVersion
```
### Export certificates from the certificate store
```Powershell
$certStore = "cert:\LocalMachine\My"
$exportDir = "C:\Users\Administrator\Desktop\work"
Get-ChildItem -Path $certStore | ForEach-Object { Export-Certificate -Cert $_ -FilePath "$exportDir$($_.Thumbprint).cer" }
```

## 감사드립니다
