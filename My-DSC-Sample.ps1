if(Test-Path ./MySample) {
  rm -force -r ./MySample/*
}


Configuration MySample
{
    Node "localhost"
    {
        WindowsFeature IIS {
            Name = "Web-Server"
            Ensure = "Present"
        }

        WindowsFeature Web-Mgmt-Tools {
            Name = "Web-Mgmt-Tools"
            Ensure = "Present"
        }

        WindowsFeature DotNetFramework {
            Name = "AS-NET-Framework"
            Ensure = "Present"
        }

        File WebsiteFolder {
            DestinationPath = "C:\MyDsc\TestWebSite"
            Type = "Directory"
            Ensure = "Present"
            Force = $true
        }

        File WebsiteIndexer {
            DestinationPath = "C:\MyDsc\TestWebSite\index.html"
            Type = "File"
            Ensure = "Present"
            Contents = "<h1>Hello DSC!</h1>"
            Force = $true
            DependsOn = "[File]WebsiteFolder"
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
            ApplicationPool = "MyAppPool"
            Ensure = "Present"
            PhysicalPath = "C:\MyDsc\TestWebSite" # Hardcoded website content folder.
            BindingInfo = @(
                        @(MSFT_xWebBindingInformation
                            {
                                Protocol              = "HTTP"
                                Port                  =  2000
                            }
                        );
                        @(MSFT_xWebBindingInformation
                            {
                                Protocol              = "HTTPS"
                                Port                  = 2001
                            }
                        )
                        )
            State = "Started"
            DependsOn = @("[WindowsFeature]IIS", "[cAppPool]MyAppPool", "[File]WebsiteFolder")
        }

    }
}

MySample
Start-DscConfiguration -Wait -Verbose -Path ./MySample
