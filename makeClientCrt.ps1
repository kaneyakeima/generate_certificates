$userList = Import-Csv -Path ".\user-list.csv"
foreach ($user in $userList) {
  $cn = $user.CN
  $san = $user.SAN
  $CertDir = "cert:\LocalMachine\My"
  $Template = "[Template Name]"
  Get-Certificate -Template $Template -Subject CN=$cn -CertStoreLocation $CertDir -DnsName $san
}
