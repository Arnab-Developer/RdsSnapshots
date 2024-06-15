using namespace System.Collections.Generic

BeforeAll {
    . "$PSScriptroot\Snapshot.ps1"
    . "$PSScriptroot\RdsManager.ps1"
    . "$PSScriptroot\Worker.ps1"

    $cluster = "test-cluster"
    $rdsManager = [RdsManager]::new($cluster)

    $rdsManagerMock = New-MockObject -InputObject $rdsManager -Methods @{
        GetSnapshots = { 
            $snapshot1 = [Snapshot]::new("1", [DateTime]::Now.AddDays(-14)) 
            $snapshot2 = [Snapshot]::new("2", [DateTime]::Now.AddDays(-7))
            
            $testSnapshots = [List[Snapshot]]::new()

            $testSnapshots.Add($snapshot1)
            $testSnapshots.Add($snapshot2)

            $jsonResults = $testSnapshots | ConvertTo-Json
            return $jsonResults
        }
    }

    $worker = [Worker]::new($rdsManagerMock)
}

Describe "WorkerTests" {
    It "Can_GetSnapshots_ReturnProperData" {
        $sevenDaysAgo = [DateTime]::Now.AddDays(-7).Date
        $fourteenDaysAgo = [DateTime]::Now.AddDays(-14).Date

        $snapshots = $worker.GetSnapshots()

        $snapshots[0].Id | Should -Be "2"
        $snapshots[0].CreationTime.Date | Should -Be $sevenDaysAgo

        $snapshots[1].Id | Should -Be "1"
        $snapshots[1].CreationTime.Date | Should -Be $fourteenDaysAgo

        $invokes = $rdsManagerMock._GetSnapshots
        $invokes | Should -HaveCount 1
    }
}