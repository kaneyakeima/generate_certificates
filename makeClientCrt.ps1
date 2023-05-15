$certStore = "cert:\LocalMachine\My"
$certTemplate = "Machine"
Get-Certificate -Template $certTemplate -CertStoreLocation $certStore