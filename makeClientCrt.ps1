# Check Powershell version
$PSVersionTable.PSVersion

# Define variables to create a self-signed client certificate
$certTemplate = "ClientAuth" # Certificate Template Name
$certStore = "cert:\LocalMachine\My" # Certificate storage location
$certPassword = ConvertTo-SecureString -String "P@ssw0rd" -Force -AsPlainText # Certificate Password

# Create a self-signed certificate using WindowsServer ADCS functionality
#New-SelfSignedCertificate -DnsName "ADCS-Client" -CertStoreLocation $certStore -FriendlyName "ADCS Client Certificate" -Type CodeSigningCert -Subject "CN=ADCS-Client" -KeyUsage DigitalSignature, KeyEncipherment -NotAfter (Get-Date).AddYears(5) -KeySpec Signature -TextExtension @("2.5.29.17={text}DNS=ADCS-Client", "2.5.29.37={text}1.3.6.1.5.5.7.3.2", "2.5.29.19={text}") -KeyExportPolicy Exportable -KeyAlgorithm RSA -KeyLength 2048 -KeyUsageProperty All -HashAlgorithm SHA256 -KeyProtection $certPassword
#New-SelfSignedCertificate -CertStoreLocation $certStore -FriendlyName "ADCS Client Certificate" -Type CodeSigningCert -Subject "CN=ADCS-Client.local" -KeyUsage DigitalSignature, KeyEncipherment -NotAfter (Get-Date).AddYears(5) -KeySpec Signature -TextExtension @("2.5.29.17={text}DNS=ADCS-Client", "2.5.29.37={text}1.3.6.1.5.5.7.3.2", "2.5.29.19={text}") -KeyExportPolicy Exportable -KeyAlgorithm RSA -KeyLength 2048 -KeyUsageProperty All -HashAlgorithm SHA256

# Reads SAN and email address from external text file and issues certificate
$userList = Import-Csv -Path ".\user-list.csv" # External text file path
foreach ($user in $userList) {
    $san = $user.SAN # SAN column of CSV file
    $email = $user.Email # Email column of CSV file
    
    # Define variables for certificate issuance
    $certProps = @{
        SubjectName = "CN=$san"
        CertStoreLocation = "cert:\LocalMachine\My"
        Template = "Machine"
        DnsName = $san
    }
    
    # Issue certificates
    Get-Certificate @certProps
}