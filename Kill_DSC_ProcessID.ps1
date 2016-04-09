###
### find the Process that is hosting the DSC engine
###
$dscProcess = Get-WmiObject msft_providers | 
Where-Object {$_.provider -like 'dsccore'} 
#Select-Object -ExpandProperty HostProcessIdentifier 

###
### Kill it
###
if($dscProcess){
   Get-Process -Id $dscProcess.HostProcessIdentifier | Stop-Process
}
else{
   echo "No DSC Process running!"
}