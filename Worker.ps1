using namespace System.Text
using namespace System.Collections.Generic

. "$PSScriptroot\Snapshot.ps1"
. "$PSScriptroot\RdsManager.ps1"

class Worker
{
    hidden [RdsManager] $_rdsManager

    Worker([RdsManager] $rdsManager)
    {
        $this._rdsManager = $rdsManager
    }

    [List[Snapshot]] GetSnapshots()
    {
        $jsonResults = $this._rdsManager.GetSnapshots()
        $results = $jsonResults | ConvertFrom-Json

        $snapshots = [List[Snapshot]]::new()

        foreach ($result in $results)
        {
            $snapshot = [Snapshot]::new($result.Id, $result.CreationTime)
            $snapshots.Add($snapshot)
        }

        $sortedSnapshots = $snapshots | Sort-Object { $_.CreationTime } -Descending
        return $sortedSnapshots
    }
}