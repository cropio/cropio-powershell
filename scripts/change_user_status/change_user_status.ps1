param([string]$CropioToken,[string]$userEmail,[string]$setUserStatus)

# $CropioToken -- Cropio API Secret token (X-User-Api-Token)
# $userEmail -- Email of User we want to set status (mail@example.org)
# $setUserStatus -- Status of User. Must be one of:
#   'no_access' (blocked user)
#   'user'      (regular user)
#   'manager'   (full access, except managing Users and Roles)
#   'admin'     (full access)
#
# Usage example:
# powershell.exe -file change_user_status.ps1 -CropioToken 'TOKEN' -userEmail 'EMAIL' -setUserStatus 'STATUS'

echo "User Email: $userEmail"
echo "Obtaining User info..."

$CropioHeader=@{"X-User-Api-Token"=$CropioToken}
$uriUserSearch="https://cropio.com/api/v3/users?email_eq=$userEmail"

$user=(Invoke-RestMethod -Method Get -ContentType 'application/json' -Headers $CropioHeader -Uri $uriUserSearch).data | Select-Object -First 1
$userId=$user.id
$userName=$user.username
$previousUserStatus=$user.status

echo "User Id: $userId"
echo "User Name: $userName"
echo "Previous User status: $previousUserStatus"
echo "Desired User status: $setUserStatus"
echo "Setting new status..."

$uriUser="https://cropio.com/api/v3/users/$userId"
$body="{""data"": {""status"": ""$setUserStatus""}}"

$newUserStatus = (Invoke-RestMethod -Method Put -ContentType 'application/json' -Headers $CropioHeader -Uri $uriUser -Body $body).data.status

echo "New status: $newUserStatus"
