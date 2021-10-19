# Usage example:
# powershell.exe -file update_properties.ps1

# NOTE: You need to specify next settings:

##################
#### Settings ####
##################
$userApiToken="USER_API_TOKEN"
$apiEndpoint="api/v3/additional_objects"
$filter="geometry_type=line"
$dataToUpdate='{ "data": { "line_color": "#007700" } }'
$nameStartsWith='farm'
##################

# Preparations
$apiUrl = "https://operations.cropwise.com/"
$baseUrl= $apiUrl + $apiEndpoint
$authHeader=@{"X-User-Api-Token"=$userApiToken}

# Get IDs to update.
$urlBuilder = new-object System.UriBuilder($baseUrl)
$urlBuilder.Path = $urlBuilder.Path + '/ids'
$urlBuilder.Query = $filter
$url = $urlBuilder.ToString()
$idsToUpdate = (Invoke-RestMethod -Method Get -ContentType 'application/json' -Headers $authHeader -Uri $url).data

# Get number of available records.
$urlBuilder = new-object System.UriBuilder($baseUrl)
$urlBuilder.Path = $urlBuilder.Path + '/count'
$url = $urlBuilder.ToString()
$availableRecordsCount = (Invoke-RestMethod -Method Get -ContentType 'application/json' -Headers $authHeader -Uri $url).data

# Get number of filtered records.
$filteredeRecordsCount = $idsToUpdate.Count;

# Show information of records that would be updated.
Write-Host "API endpoint: " -NoNewline
Write-Host $apiEndpoint -ForegroundColor DarkGreen
Write-Host "Filter: " -NoNewline
Write-Host $filter -ForegroundColor DarkGreen
Write-Host "Data: " -NoNewline
Write-Host $dataToUpdate -ForegroundColor DarkGreen
Write-Host ""
Write-Host "Total available records: " -NoNewline
Write-Host $availableRecordsCount -ForegroundColor DarkYellow
Write-Host "Records to update (filtered): " -NoNewline
Write-Host $filteredeRecordsCount -ForegroundColor DarkYellow

# Ask to start update.
Write-Host ""
Write-Warning "Start updating records?" -WarningAction Inquire

# Update each record.
foreach ($id in $idsToUpdate) {
    Write-Host ""
    Write-Host "ID: $id"

    $urlBuilder = new-object System.UriBuilder($baseUrl)
    $urlBuilder.Path = $urlBuilder.Path + "/$id"
    $url = $urlBuilder.ToString()

    # Get object
    $object = (Invoke-RestMethod -Method Get -ContentType 'application/json' -Headers $authHeader -Uri $url).data

    if($object.name.StartsWith($nameStartsWith)) {
        Write-Host 'Updating record...'
        Invoke-RestMethod -Method Put -ContentType 'application/json' -Headers $authHeader -Uri $url -Body $dataToUpdate
   } else {
        Write-Host "Skip (name doesn't match)."
   }
}