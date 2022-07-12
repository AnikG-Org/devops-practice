Param(
   [string]$collectionurl = "https://{organization}.vsrm.visualstudio.com",
   [string]$projectName = "{project}",
   [string]$user = "",
   [string]$token = "PATtoken",
   [string]$releasedDefinitionId = "1" #release pipeline DefinitionId

)

# Base64-encodes the Personal Access Token (PAT) appropriately
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$token)))

function CreateJsonBody
{
    $value = @"
{
 "definitionId":$releasedDefinitionId,
#  "artifacts":[{"alias":"_BitBucket",
#                 "instanceReference":{"id":"11",
#                        "name":"11",
#                        "definitionId":"1",
#                        "sourceBranch":"master",
#                     }
#                 }
#             ],

 "isDraft":false,
 "manualEnvironments":[]
}
"@

 return $value
}

$json = CreateJsonBody

$uri = "$($collectionurl)/$($projectName)/_apis/Release/releases?api-version=6.0"
$result = Invoke-RestMethod -Uri $uri -Method Post -Body $json -ContentType "application/json" -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}

$ReleaseID = $result.id

Write-Host "ReleaseID:" $ReleaseID