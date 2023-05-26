$pw = "[private-key passphrase]"
$ca = ".\[FQDN of local CA]"
$ulfn = "[user list for input(csv)]"
$lines = (Get-Content -Path "$ulfn").Length - 1
$ul = Import-Csv -Path "$ulfn"
$dt = Get-Date -Format "yyyyMMdd_HHmmss"
$startTime = Get-Date -Format "HH:mm:ss"
$log = "log\" + "$dt" + ".log"
New-Item "cer" -ItemType Directory -Force > $null
New-Item "inf" -ItemType Directory -Force > $null
New-Item "csr" -ItemType Directory -Force > $null
New-Item "pfx" -ItemType Directory -Force > $null
New-Item "log" -ItemType Directory -Force > $null
Write-Host "Start processing."
function main {
  foreach ($user in $ul){
    $cn = $user.cn
    Write-Output "###### START [ $cn ]"
    Write-Host "$cn : $(Get-Date -Format "HH:mm:ss")"
    $email = $user.email
    $upn = $user.upn
    $un = $user.un1 + " " + $user.un2
    $inf = $cn + ".inf"
    $csr = $cn + ".csr"
    $cer = $cn + ".cer"
    Write-Output "### INF-FILE"
    Write-Output @"
[NewRequest]
FriendlyName = "$un"
Subject = "CN=$cn,L=[localityName],ST=[stateOrProvinceName],O=[organizationName],OU=[organizationalUnitName],DC=[domainComponent]"
Exportable = TRUE
ExportableEncrypted = TRUE
[RequestAttributes]
CertificateTemplate = [ADCS-TemplateName]
[Extensions]
2.5.29.17 = "{text}"
_continue_ = "email=$email&"
_continue_ = "UPN=$upn"
"@ | Out-file .\inf\$inf -Encoding unicode
    Write-Output "### CSR"
    certreq -new -f .\inf\$inf .\csr\$csr
    Write-Output "### CA-SIGN"
    certreq -submit -f -config $ca .\csr\$csr .\cer\$cer
    Write-Output "### INSTALL"
    certreq -accept .\cer\$cn.cer
    Write-Output "### EXPORT"
    certutil -f -exportpfx -user -p $pw My $cn ".\pfx\$cn.pfx" ExtendedProperties,ExportParameters
  }
}
$sec = (Measure-Command{ main >> $log}).TotalSeconds
$endTime = Get-Date -Format "HH:mm:ss"
Write-Output "###### Statistics" >> $log
Write-Output "Total Entries : $lines" >> $log
Write-Output "Total Processing time :  $sec sec." >> $log
Write-Output "Begining Time : $startTime" >> $log
Write-Output "Finished Time : $endTime" >> $log
Write-Host "Finished : $endTime"
Write-Host "Total : $sec sec."
