### This file is for excute configuration at once in pull mode.

$params = @{
    Namespace = ‘root/Microsoft/Windows/DesiredStateConfiguration’
    ClassName = ‘MSFT_DSCLocalConfigurationManager’
    MethodName = ‘PerformRequiredConfigurationChecks’
    Arguments = @{
        Flags = [uint32] 1
    }
}

Invoke-CimMethod @params
