# Gitea PoC: the Gitea server has no trusted TLS certificate yet. AL-Go runs this override before
# Run-AlPipeline resolves dependencies, in the same Windows PowerShell 5.1 process, so a host-restricted
# ServicePointManager callback lets Download/Publish-BcNuGetPackage* reach the feed.
# Remove this file once the server has a trusted certificate.

$giteaHost = '4.184.85.207'

if ($PSVersionTable.PSEdition -eq 'Core') {
    throw 'PipelineInitialize.ps1 needs Windows PowerShell 5.1 (githubRunnerShell = powershell): the certificate callback has no effect in PowerShell 7.'
}

[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

if (-not ('GiteaPocCertTrust' -as [type])) {
    Add-Type -TypeDefinition @'
using System;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;

public static class GiteaPocCertTrust
{
    private static string trustedHost;

    public static void Enable(string host)
    {
        trustedHost = host;
        ServicePointManager.ServerCertificateValidationCallback = Validate;
    }

    private static bool Validate(object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors errors)
    {
        if (errors == SslPolicyErrors.None)
            return true;
        HttpWebRequest request = sender as HttpWebRequest;
        return request != null && string.Equals(request.RequestUri.Host, trustedHost, StringComparison.OrdinalIgnoreCase);
    }
}
'@
}
[GiteaPocCertTrust]::Enable($giteaHost)
Write-Host "TLS certificate check disabled for host $giteaHost (Gitea PoC)"
