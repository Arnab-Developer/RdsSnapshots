class RdsManager
{
    hidden [string] $_cluster

    RdsManager([string] $cluster)
    {
        $this._cluster = $cluster
    }

    [string] GetSnapshots()
    {
        $query = "DBClusterSnapshots[].{Id:DBClusterSnapshotIdentifier, CreationTime:SnapshotCreateTime}"
        $jsonResults = aws rds describe-db-cluster-snapshots --db-cluster-identifier $this._cluster --query $query
        return $jsonResults
    }
}