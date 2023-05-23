$array = "cn,upn,email`r`n"
for($i=1;$i -lt 6;$i++){
$array += "test$i,test${i}upn,test$i@ppp.local"
$array += "`r`n"
}
$fileName = "user-list.csv"
New-Item -f $fileName -type file -value $array
Write-Host "`r`n###---VVV------<$fileName>------VVV---###"
type $fileName
Write-Host "###---AAA------<$fileName>------AAA---###"
