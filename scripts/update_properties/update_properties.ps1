# Usage example:
# powershell.exe -file update_properties.ps1

# NOTE: You need to specify next settings:

##################
#### Settings ####
##################
$userApiToken="USER_TOKEN"
$baseUrl= "https://operations.cropwise.com/api/v3/additional_objects"
$filter="object_type=Farm"
$dataToUpdate='{ "data": { "polygon_color": "#007700", "polygon_opacity": 0.5 } }'
##################

$authHeader=@{"X-User-Api-Token"=$userApiToken}

# Get IDs to update.
$urlBuilder = new-object System.UriBuilder($baseUrl)
$urlBuilder.Path = $urlBuilder.Path + '/ids'
$urlBuilder.Query = $filter
$url = $urlBuilder.ToString()
$idsToUpdate = (Invoke-RestMethod -Method Get -ContentType 'application/json' -Headers $authHeader -Uri $url).data

# Update each record
foreach ($id in $idsToUpdate) {
    $urlBuilder = new-object System.UriBuilder($baseUrl)
    $urlBuilder.Path = $urlBuilder.Path + "/$id"
    $url = $urlBuilder.ToString()
    Invoke-RestMethod -Method Put -ContentType 'application/json' -Headers $authHeader -Uri $url -Body $dataToUpdate
}