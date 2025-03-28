Param(
   [string]$collectionurl = "https://{organization}.vsrm.visualstudio.com",
   [string]$projectName = "{project}",
   [string]$user = "",
   [string]$token = "PATtoken",
   [string]$releasedDefinitionId = "1", #release pipeline DefinitionId
   [int]   $stage_no = 1  #stages Eg= 1,2,3......x

)

$stage = $stage_no-1
# Base64-encodes the Personal Access Token (PAT) appropriately
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$token)))


function CreateJsonBody
{
    $value = @"
{
 "definitionId":$releasedDefinitionId,
 "isDraft":false,
 "manualEnvironments":[]
}
"@

 return $value
}

$json = CreateJsonBody

$url = "$($collectionurl)/$($projectName)/_apis/Release/releases?api-version=6.0"
$result = Invoke-RestMethod -Uri $url -Method Post -Body $json -ContentType "application/json" -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}

$ReleaseID = $result.id
$EnvironmentIds = $result.environments | select id
$time = $result.createdOn
$StageEnvironmentId = $result.environments[$($stage)] | select id
$releaseNo = $result.name

#Output
Write-Host "ReleaseID:" $ReleaseID
Write-Host "EnvironmentIds:" $EnvironmentIds
Write-Host $releaseNo
##################################### Part 1 [End] used to trigger the release pipeline. if stages for release pipelines are after release trigger then It will deploy all stages.

##################################### Part 2 used to trigger specic stage. need to make sure all stages for release pipelines are 'mannual trigger' only. 
$envBody='{
"status": "inProgress"
}'

#Trigger specific stage / Env
$EnvUrl = "$($collectionurl)/$($projectName)/_apis/Release/releases/$($ReleaseID)/environments/$($EnvironmentIds[$($stage)].id)?api-version=6.0"

Invoke-RestMethod -Uri $EnvUrl -Headers @{Authorization = ("Basic {0}" -f $base64AuthInfo)} -Method patch -Body $envBody -ContentType "application/json"

#Output
Write-Host $releaseNo $result.status
Write-Host "Triggered successfully at $time Stage_ReleaseID = $ReleaseID & Stage: $stage_no &  Stahe_EnvironmentId: $StageEnvironmentId" 
