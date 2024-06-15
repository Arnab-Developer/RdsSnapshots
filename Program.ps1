param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Environment
)

. "$PSScriptroot\Snapshot.ps1"
. "$PSScriptroot\RdsManager.ps1"
. "$PSScriptroot\Worker.ps1"

$cluster = "$($Environment)-cluster"
$rdsManager = [RdsManager]::new($cluster)

$worker = [Worker]::new($rdsManager)
$snapshots = $worker.GetSnapshots()

foreach ($snapshot in $snapshots)
{
    "$($snapshot)"
}