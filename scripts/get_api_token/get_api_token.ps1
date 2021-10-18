param([string]$userEmail,[string]$userPassword)

# $userEmail -- Email of User (eg. mail@example.org)
# $userPassword -- Password of User.
#
# Usage example:
# powershell.exe -file get_api_token.ps1 -userEmail 'EMAIL' -userPAssword 'PASSWORD'

$uri="https://operations.cropwise.com/api/v3/sign_in"
$body="{""user_login"": {""email"": ""$userEmail"", ""password"": ""$userPassword""}}"
Invoke-RestMethod -Method Post -ContentType 'application/json' -Uri $uri -Body $body