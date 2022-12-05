#Comando para deshabilitar warnings, ejecutar una vez en la terminal
#Set-PowerCLIConfiguration -DisplayDeprecationWarnings $false
#Comando para genera clave cifrada
#$securePassword = Read-host -AsSecureString|ConvertFrom-SecureString

#parametros enviados por PRTG
param (
        [Parameter(Mandatory=$true)][String]$Org
)

#valor por defecto para prtg 0
$prtgvalue=0
$prtgmsg="OK"


$info=Import-CSV credentials.csv

for ($i=0; $i -lt $info.count; $i++)
{
        Write-Host $i
        Write-Host $info.Org[$i]
        if ($Org -eq $info.Org[$i])
        {
                Write-Host $i
                $username=$info[$i].username
                Write-Host $info[$i].password
                $pass=$info[$i].password|ConvertTo-SecureString
                #Conexion y consulta snapshot
                Connect-CIServer -Server <vmwarevclouddirector.com> -Org $Org -User $username -password $pass|out-null
                $OrgVms=Get-CIVM
                for ($j=0; $j -lt $OrgVms.length; $j++)
                {
                        $querysnapshot=$OrgVms[$j].ExtensionData.GetSnapshotSection().Snapshot
                        if ($querysnapshot)
                        {
                                Write-Host $querysnapshot
                                $prtgmsg=$OrgVms[$j].name
                                $prtvalue=4
                        }
                }
                break
        }
        else
        {
                $prtgvalue=4
                $prtgmsg="Organizacion erronea"
        }
}
Write-Host "${prtgvalue}:$prtgmsg"
