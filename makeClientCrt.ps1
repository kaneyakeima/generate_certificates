$pw = "password"
$ca = ".\ppp-HOGE-CA"
$ulfn = "user-list.csv"
$lines = (Get-Content -Path "$ulfn").Length - 1
$ul = Import-Csv -Path "$ulfn"
$dt = Get-Date -Format "yyyyMMdd_HHmmss"
$startTime = Get-Date -Format "HH'mm'ss"
$log = "$dt" + ".log"
New-Item "cer" -ItemType Directory -Force > $null
New-Item "inf" -ItemType Directory -Force > $null
New-Item "csr" -ItemType Directory -Force > $null
Write-Host "PROCESS START!"
function main {
  foreach ($user in $ul){
    $cn = $user.cn
    Write-Output "###### START [ $cn ]"
    Write-Host "Processing $cn now..."
    $email = $user.email
    $upn = $user.upn
    $infval = @"
  [NewRequest]
  Subject = "CN=$cn"
  Exportable = TRUE
  ExportableEncrypted = TRUE
  [RequestAttributes]
  CertificateTemplate = WorkspaceONE
  [Extensions]
  2.5.29.17 = "{text}"
  _continue_ = "email=$email&"
  _continue_ = "UPN=$upn"
"@
    $inf = $user.cn + ".inf"
    $csr = $user.cn + ".csr"
    $cer = $user.cn + ".cer"
    Write-Output "### INF-FILE"
    New-Item -Force .\inf\$inf -type File -value $infval
    Write-Output "### CSR"
    certreq -new -f .\inf\$inf .\csr\$csr
    Write-Output "### CA-SIGN"
    certreq -submit -f -config $ca .\csr\$csr .\cer\$cer
    Write-Output "### INSTALL"
    certreq -accept .\cer\$cn.cer
    Write-Output "### EXPORT"
    certutil -f -exportpfx -p $pw My $cn "$cn.pfx" ExtendedProperties,ExportParameters
  }
}
$sec = (Measure-Command{ main >> $log}).TotalSeconds
$endTime = Get-Date -Format "HH'mm'ss"
Write-Output "###### Statistics
Write-Output "Total Entries : $lines" >> $log
Write-Output "Total Processing time :  $sec sec." >> $log
Write-Output "Begining Time : $startTime" >> $log
Write-Output "Finished Time : $endTime" >> $log
