# Reads SAN and email address from external text file and issues certificate
$userList = Import-Csv -Path ".\user-list.csv"
foreach ($user in $userList) {
  $certProps = @{
    SubjectName = "CN=$user.SAN"
    CertStoreLocation = "cert:\LocalMachine\My"
    Template = "Machine"
    DnsName = $user.DNS
  }
  Get-Certificate @certProps
}
#Get-Certificate -CertStoreLocation "cert:\LocalMachine\My" -Template "Machine"