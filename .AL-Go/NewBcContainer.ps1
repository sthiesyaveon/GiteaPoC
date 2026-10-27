Param([Hashtable] $parameters)

New-BcContainer @parameters
Invoke-ScriptInBcContainer $parameters.ContainerName -scriptblock { $progressPreference = 'SilentlyContinue' }

# The Server Core image of the container lacks the fonts used by the RDLC layouts of the Yaveon apps: installing
# Yaveon 365 Process Base fails with "Invalid font family: the font 'Segoe UI' is not installed".
# Same font list as D365BC.Management Templates/bc/scripts/Install-BCContainer.ps1.
Add-FontsToBcContainer -containerName $parameters.ContainerName -path @(
    'C:\Windows\Fonts\arial*',
    'C:\Windows\Fonts\calibri*',
    'C:\Windows\Fonts\cambria*',
    'C:\Windows\Fonts\consol*',
    'C:\Windows\Fonts\cour*',
    'C:\Windows\Fonts\fram*',
    'C:\Windows\Fonts\lucon.ttf',
    'C:\Windows\Fonts\micross.ttf',
    'C:\Windows\Fonts\Roboto*',
    'C:\Windows\Fonts\seg*',
    'C:\Windows\Fonts\tahoma*',
    'C:\Windows\Fonts\times*',
    'C:\Windows\Fonts\trebuc*',
    'C:\Windows\Fonts\verdana*',
    'C:\Windows\Fonts\webdings*',
    'C:\Windows\Fonts\wingdings*'
)

# Add-FontsToBcContainer registers the fonts with AddFontResource, which only affects its own session; the already
# running service tier sees them after a restart (run 40500289605: fonts copied, install still failed on 'Segoe UI').
# Restart the whole container, not only the service tier: after Restart-BcContainerServiceTier the next call failed
# with "The tenant 'default' is not accessible" (run 40508595968); Restart-BcContainer waits until the container is ready.
Restart-BcContainer -containerName $parameters.ContainerName
Invoke-ScriptInBcContainer $parameters.ContainerName -scriptblock { $progressPreference = 'SilentlyContinue' }
