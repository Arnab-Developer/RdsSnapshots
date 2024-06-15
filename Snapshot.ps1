using namespace System.Text

class Snapshot
{
    [string] $Id
    [DateTime] $CreationTime

    Snapshot([string] $id, [DateTime] $creationTime)
    {
        $this.Id = $id
        $this.CreationTime = $creationTime
    }

    [string] ToString()
    {
        $builder = [StringBuilder]::new()

        $builder.Append("Id: ")
        $builder.AppendLine($this.Id)
        $builder.Append("Creation Time: ")
        $builder.AppendLine($this.CreationTime.ToString("dd-MMMM-yyyy hh:mm"))

        return $builder.ToString()
    }
}