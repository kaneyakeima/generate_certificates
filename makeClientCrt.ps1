# Reads SAN and email address from external text file and issues certificate
$userList = Import-Csv -Path ".\user-list.csv" # External text file path
foreach ($user in $userList) {
  $san = $user.SAN # SAN column of CSV file
  $email = $user.Email # Email column of CSV file
  $certProps = @{
    SubjectName = "CN=$san"
    CertStoreLocation = "cert:\LocalMachine\My"
    Template = "Machine"
    DnsName = $san
  }
  Get-Certificate @certProps
}