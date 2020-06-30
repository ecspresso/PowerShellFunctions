function ConvertTo-QuickSecureString {
    [CmdletBinding()]
    [Alias('qss')]
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [String]$String,
        [Switch]$Clipboard
    )

    begin {}
    process {
        $secureString = Convertto-SecureString $String -AsPlainText -Force | ConvertFrom-SecureString
        if($Clipboard) {
            $secureString | Set-Clipboard
        } else {
            $secureString
        }
    }
    end {}
}