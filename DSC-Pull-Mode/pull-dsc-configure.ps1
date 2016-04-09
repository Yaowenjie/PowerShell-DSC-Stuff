Configuration SimpleMetaConfigurationForPull
{

    Param(
        [Parameter(Mandatory=$True)]
        [String]$NodeGUID
    )

     LocalConfigurationManager
     {
       ConfigurationID = $NodeGUID;
       RefreshMode = "PULL";
       RebootNodeIfNeeded = $true;
       RefreshFrequencyMins = 30;
       ConfigurationModeFrequencyMins = 15;
       ConfigurationMode = "ApplyAndAutoCorrect";
       DownloadManagerName = "WebDownloadManager";
       DownloadManagerCustomData = @{ServerUrl = "http://192.168.3.250:8080/PSDSCPullServer.svc"; AllowUnsecureConnection = “TRUE”}
     }
}

$data = import-csv "\\192.168.3.250\c$\Program Files\WindowsPowershell\DscService\Configuration\dscnodes.csv" -header("NodeName","NodeGUID")

SimpleMetaConfigurationForPull -NodeGUID ($data | where-object {$_."NodeName" -eq "192.168.50.4"}).NodeGUID -Output "."
$FilePath = (Get-Location -PSProvider FileSystem).Path + "\SimpleMetaConfigurationForPull"
Set-DscLocalConfigurationManager -ComputerName "localhost" -Path $FilePath -Verbose
