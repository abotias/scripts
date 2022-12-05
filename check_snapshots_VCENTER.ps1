function Get-SnapChild
{
   param(
   [VMware.Vim.VirtualMachineSnapshotTree]$Snapshot
   )
   process
   {
   $snapshot | Select Name, Description, CreateTime
   if ($Snapshot.ChildSnapshotList.Count -gt 0)
   {
   $Snapshot.ChildSnapshotList | % {
   Get-SnapChild -Snapshot $_
   }
   }
   }
}

$VCServer='<IP VIRTUALCENTER>'
$username="<USER WITH ACCESS VIRTUALCENTER>"
$pass=Get-Content pass.txt | ConvertTo-SecureString
Connect-VIServer $VCServer -User $username -Password $pass|Out-null

foreach ($vm in Get-View -ViewType VirtualMachine -Property Name, Snapshot -Filter @{'Snapshot' = '' })
{
   $vm.Snapshot.RootSnapshotList | % {
   Get-SnapChild -Snapshot $_ |
  Select @{N = 'VM'; E = { $vm.name } },
   @{N = 'Snapshot'; E = { $_.Name } },
   @{N = 'Description'; E = { $_.Description } },
   @{N = 'CReated'; E = { $_.CreateTime } }
   } | Format-table
}