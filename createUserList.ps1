$array = "cn,upn,email`r`n"
for($i=1;$i -lt 6;$i++){
$array += "CommonName$i,UserPrincipalName${i}upn,Emai$i@example.com,UserFamilyName${i},UserLastName${i}"
$array += "`r`n"
}
$fileName = "user_list.csv"
New-Item -f $fileName -type file -value $array
Write-Host "`r`n###---VVV------<$fileName>------VVV---###"
type $fileName
Write-Host "###---AAA------<$fileName>------AAA---###"
