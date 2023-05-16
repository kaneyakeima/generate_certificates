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

### Get a self-signed certificate
```Powershell
$certStore = "cert:\LocalMachine\My" # Certificate storage location
$certPassword = ConvertTo-SecureString -String "P@ssw0rd" -Force -AsPlainText # Certificate Password
New-SelfSignedCertificate -CertStoreLocation $certStore -FriendlyName "ADCS Client Certificate" -Type CodeSigningCert -Subject "CN=ADCS-Client" -KeyUsage DigitalSignature, KeyEncipherment -NotAfter (Get-Date).AddYears(5) -KeySpec Signature -TextExtension @("2.5.29.17={text}DNS=ADCS-Client", "2.5.29.37={text}1.3.6.1.5.5.7.3.2", "2.5.29.19={text}") -KeyExportPolicy Exportable -KeyAlgorithm RSA -KeyLength 2048 -KeyUsageProperty All -HashAlgorithm SHA256 -KeyProtection $certPassword
```

### Get a local ca signed certificate by use of cert-template and user-list.csv
```Powershell
$userList = Import-Csv -Path ".\user-list.csv"
foreach ($user in $userList) {
  $cn = $user.CN
  $san = $user.SAN
  $CertDir = "cert:\LocalMachine\My"
  $Tmplt = "[Template Name]"
  Get-Certificate -Template $Template -Subject CN=$cn -CertStoreLocation $CertDir -DnsName $san
}
```
user-list.csv
```csv
CN,SAN,Email
1,1.ppp.local,1@ppp.local
2,2.ppp.local,2@ppp.local
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

### Thanks
- 감사드립니다 / カムサトゥリムニダ / 感謝致します
- 수고했어요 / スゴヘッソヨ / お疲れ様
