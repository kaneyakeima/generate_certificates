# Abstract
- Script to issue SSL certificates in a powershell.
- Use ADCS certificate templates.

## CSR Issuance in Windows
```
certreq -new -f CSR_Base.inf CSR.req
```

## Check if the ADCSAdministration module is available
```Powershell
Get-Module -ListAvailable -Name ADCSAdministration
```