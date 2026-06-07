param(
  [string]$Container = "cache_cassandra",
  [string]$User = $env:CASSANDRA_USER,
  [string]$Password = $env:CASSANDRA_PASSWORD
)

$ErrorActionPreference = "Stop"

$baseDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$schema = Join-Path $baseDir "schema.cql"
$init = Join-Path $baseDir "init_cassandra.cql"
$populate = Join-Path $baseDir "populate_cassandra.cql"
$venueTrends = Join-Path $baseDir "venue_trends.csv"

$authArgs = @()
if ($User -and $Password) {
  $authArgs = @("-u", $User, "-p", $Password)
}

function Invoke-Checked {
  param([string[]]$Command)

  & $Command[0] $Command[1..($Command.Length - 1)]
  if ($LASTEXITCODE -ne 0) {
    throw "Command failed: $($Command -join ' ')"
  }
}

Invoke-Checked @("docker", "cp", $schema, "${Container}:/tmp/schema.cql")
Invoke-Checked @("docker", "cp", $init, "${Container}:/tmp/init_cassandra.cql")
Invoke-Checked @("docker", "cp", $populate, "${Container}:/tmp/populate_cassandra.cql")
Invoke-Checked @("docker", "cp", $venueTrends, "${Container}:/tmp/venue_trends.csv")

Write-Host "Waiting for Cassandra to accept cqlsh connections..."
$ready = $false
for ($i = 1; $i -le 30; $i++) {
  docker exec $Container cqlsh @authArgs -e "DESCRIBE KEYSPACES" *> $null
  if ($LASTEXITCODE -eq 0) {
    $ready = $true
    break
  }

  Start-Sleep -Seconds 5
}

if (-not $ready) {
  throw "Cassandra is not ready. Check it with: docker ps; docker logs $Container"
}

$schemaCommand = @("docker", "exec", $Container, "cqlsh") + $authArgs + @("-f", "/tmp/schema.cql")
$initCommand = @("docker", "exec", $Container, "cqlsh") + $authArgs + @("-f", "/tmp/init_cassandra.cql")
$populateCommand = @("docker", "exec", $Container, "cqlsh") + $authArgs + @("-f", "/tmp/populate_cassandra.cql")

Invoke-Checked $schemaCommand
Invoke-Checked $initCommand
Invoke-Checked $populateCommand

Write-Host "Cassandra schema and seed data loaded."
