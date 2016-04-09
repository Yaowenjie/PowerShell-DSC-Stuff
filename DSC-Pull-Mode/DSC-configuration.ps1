Configuration TestConfig {

    Param(
        [Parameter(Mandatory=$True)]
        [String[]]$NodeGUID
    )


    Node $NodeGUID {

       <#
        Script MyScriptTest{
            SetScript = {
                New-Item C:\MyDSCTest.txt -Type file
                Set-Content C:\MyDSCTest.txt "Here we go!"
                whoami > "c:\whoami.txt"
            }
            GetScript = { #
            }
            TestScript = {$false}
        }
       #>

        WindowsFeature IIS {
            Name = "Web-Server"
            Ensure = "Present"
        }

        WindowsFeature DotNetFramework {
            Name = "AS-NET-Framework"
            Ensure = "Present"
        }


        cAppPool MyAppPool {
            Name  = "MyAppPool"
            Ensure = "Present"
            autoStart = "true"
            managedRuntimeVersion = "v4.0"
            identityType = "LocalSystem"
            startMode = "AlwaysRunning"
        }

        xWebSite MyWeb {
            Name = "MyWeb"
            DependsOn = @("[WindowsFeature]IIS", "[cAppPool]MyAppPool")
            ApplicationPool = "MyAppPool"
            Ensure = "Present"
            PhysicalPath = "C:\TestWebSite"
            BindingInfo = @(
                        @(MSFT_xWebBindingInformation
                            {
                                Protocol              = "HTTP"
                                Port                  =  1080
                                HostName              = "www.myweb.int"
                            }
                        );
                        @(MSFT_xWebBindingInformation
                            {
                                Protocol              = "HTTPS"
                                Port                  = 1081
                                HostName              = "www.myweb.int"
                            }
                        )
                       )
            State = "Started"

        }


    }
}

$Computers = @("192.168.50.4")

write-host "Generating GUIDs and creating MOF files..."
foreach ($Node in $Computers)
{
    $data = import-csv "$env:SystemDrive\Program Files\WindowsPowershell\DscService\Configuration\dscnodes.csv" -header("NodeName","NodeGUID")
    if($data.NodeName -contains $Node)
    {
        $MyGUID = ($data | ? {$_."NodeName" -eq $Node}).NodeGUID
    }
    else
    {
        $MyGUID = [guid]::NewGuid()
        $NewLine = "{0},{1}" -f $Node,$MyGUID
        $NewLine | add-content -path "$env:SystemDrive\Program Files\WindowsPowershell\DscService\Configuration\dscnodes.csv"
    }
    TestConfig -NodeGUID $MyGUID
    Write-Host -foregroundcolor Green "Node_Name: $Node ; GUID: $MyGUID"
}

write-host "Creating checksums..."
New-DSCCheckSum -ConfigurationPath .\TestConfig -OutPath .\TestConfig -Verbose -Force

write-host "Copying configurations to pull service configuration store..."
$SourceFiles = (Get-Location -PSProvider FileSystem).Path + "\TestConfig\*.mof*"
$TargetFiles = "$env:SystemDrive\Program Files\WindowsPowershell\DscService\Configuration"
Move-Item $SourceFiles $TargetFiles -Force
Remove-Item ((Get-Location -PSProvider FileSystem).Path + "\TestConfig\")
