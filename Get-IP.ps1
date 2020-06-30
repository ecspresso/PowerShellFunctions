function Get-IP {
    Param(
        [String]$URL,
        [Switch]$More
    )

    if($More) {[System.Net.Dns]::GetHostAddresses($URL)}
    else {[System.Net.Dns]::GetHostAddresses($URL).IPAddressToString}
}