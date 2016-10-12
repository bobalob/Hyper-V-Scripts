Param(
  $LogFile = ".\BrokenRAM.Log"
)

#Detects and moves VMs with broken dynamic memory (VM stuck at startup RAM value)

Write-Host "Detect and move VMs with broken dynamic memory..." -ForegroundColor Cyan

$BrokenVMs = Get-ClusterNode | 
	% {get-vm -ComputerName $_.Name} | 
	? {$_.State -ne "Off" -and $_.DynamicMemoryEnabled} | 
	? {$_.MemoryDemand -eq 0 -or (($_.MemoryAssigned - $_.MemoryDemand ) -eq 0)}

$FixedVMs = Get-ClusterNode | 
	% {get-vm -ComputerName $_.Name} | 
	? {$_.State -ne "Off" -and $_.DynamicMemoryEnabled} | 
	? {$_.MemoryDemand -eq 0 -or (($_.MemoryAssigned - $_.MemoryDemand ) -eq 0)} |
	% {Move-ClusterVirtualMachineRole -Name $_.Name}

if ($BrokenVMs) {
  $BrokenVMs
  Get-Date | Out-String | Out-File $LogFile -Enc ASCII -Append

  $BrokenVMs | Select Name, State, MemoryAssigned, MemoryDemand | Out-String | 
    Out-File $LogFile -Enc ASCII -Append

  $FixedVMs | Select Name, State, MemoryAssigned, MemoryDemand | Out-String | 
    Out-File $LogFile -Enc ASCII -Append

} else {
  Write-Host "Nothing broken." -ForegroundColor Green
}
Write-Host "Done..." -ForegroundColor Cyan