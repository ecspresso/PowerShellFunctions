function Get-ITGlueAccount {
    param(
        [Switch]$AsPlainText
    )

    $key = Get-ITGlueAPIKey

    if($AsPlainText) {
        [PSCredential]::new('n/a',$key).GetNetworkCredential().Password
    } else {
        $key | ConvertFrom-SecureString
    }
}