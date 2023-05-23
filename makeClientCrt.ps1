$pw = "password"
$ca = ".\ppp-HOGE-CA"
$ulfn = "user-list.csv"
$lines = (Get-Content -Path "$ulfn").Length - 1
Write-Host "### Total entries in $ulfn : $lines"
$ul = Import-Csv -Path "$ulfn"
$dt = Get-Date -Format "yyyyMMdd_HHmmss"
$log = "$dt" + ".log"
New-Item "cer" -ItemType Directory -Force
New-Item "inf" -ItemType Directory -Force
New-Item "csr" -ItemType Directory -Force
Write-Output "###### SINGLE" >> $log
function main {
  foreach ($user in $ul){
    $cn = $user.cn
    Write-Output "###### START [ $cn ]  "
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
Write-Output "###### Total processing time","$sec sec." >> $log
