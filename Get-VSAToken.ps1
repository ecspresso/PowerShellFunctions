function Get-VSAToken {
    param(
        [Int]$Random = (Get-Random -Minimum 1 -Maximum 1000000),
        [Parameter(Mandatory=$true)]
        [String]$Username,
        [Parameter(Mandatory=$true)]
        [SecureString]$Password,
        [Parameter(Mandatory=$true)]
        [String]$BaseURI
    )

    function Get-SHA256Hash { Param([string]$textToHash)$hasher = new-object System.Security.Cryptography.SHA256Managed; $toHash = [System.Text.Encoding]::UTF8.GetBytes($textToHash); $hashByteArray = $hasher.ComputeHash($toHash); $result = $null; foreach ($byte in $hashByteArray) { $result += "{0:X2}" -f $byte }return $result.ToLower() }
    function Get-SHA1Hash { Param([string]$textToHash)$hasher = new-object System.Security.Cryptography.SHA1Managed; $toHash = [System.Text.Encoding]::UTF8.GetBytes($textToHash); $hashByteArray = $hasher.ComputeHash($toHash); $result = $null; foreach ($byte in $hashByteArray) { $result += "{0:X2}" -f $byte }return $result.ToLower() }

    [String]$Password = [PSCredential]::new("N/A", $Password).GetNetworkCredential().Password

    $RawSHA256Hash = Get-SHA256Hash -textToHash $Password
    $CoveredSHA256HashTemp = Get-SHA256Hash -textToHash "$Password$Username"
    $CoveredSHA256Hash = Get-SHA256Hash -textToHash "$CoveredSHA256HashTemp$random"

    $RawSHA1Hash = Get-SHA1Hash -textToHash $Password
    $CoveredSHA1HashTemp = Get-SHA1Hash -textToHash "$Password$Username"
    $CoveredSHA1Hash = Get-SHA1Hash -textToHash "$CoveredSHA1HashTemp$random"

    $StringToEncode = "user={0},pass2={1},pass1={2},rpass2={3},rpass1={4},rand2={5}" -f $Username, $CoveredSHA256Hash, $CoveredSHA1Hash, $RawSHA256Hash, $RawSHA1Hash, $random
    $EncryptedHash = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($StringToEncode))

    $Headers = @{
        'Content-Type'  = 'application/json'
        'Authorization' = "Basic $EncryptedHash"
    }

    return Invoke-RestMethod -Uri "$BaseURI/auth" -Method GET -Headers $Headers
}