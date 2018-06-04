# broija 20180604
# A Powershell equivalent to "du <path>|sort -n"

Param(
  [parameter(Mandatory=$true)][System.IO.DirectoryInfo]$Path=$args[0]
)

function Get-DiskUsage {
<#
.SYNOPSIS
  Returns given path size. Fills List with child dir sizes.
  
.PARAMETER Path
  Path to analyze.
  
.PARAMETER Dirs
  List filled with Path and children size.
#>
  Param (
  [System.IO.DirectoryInfo]$Path,
  [System.Collections.Generic.List[System.Object]] $Dirs
  )

  [System.Int64] $size = 0

  # For all items in $Path
  Get-ChildItem $Path |ForEach-Object {
    [System.Int64] $tmp = 0

    # If it is a directory
    if ($_ -is [System.IO.DirectoryInfo]) {
      # Get its size
      $tmp = Get-DiskUsage $_.FullName $Dirs
    }
    else {
      $tmp = ($_ |Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum
    }

    # Incrementing $Path size
    if ($tmp -gt 0) {
      $size += $tmp
    }
  }

  # If positive size, add $Path to $Dirs List
  if ($size -gt 0) {
    $Dirs.Add(@{p="$Path"; s=$size})
  }
  
  return $size
}

# ------------------------------------------------------------------------------

if (! (Test-Path -Path $Path) ) {
  Write-Output "$Path is not a valid path!"
  exit $false
}

$dirs = New-Object System.Collections.Generic.List[System.Object]
Get-DiskUsage $Path $dirs |Out-Null

# sorting
$sorted = $dirs |Sort-Object {$_.s}

# Printing results
$size = ''
$unit = ''

$sorted | ForEach-Object {
  if ($_.s -ge 1GB) {
    $size = $_.s / 1GB
    $unit = 'GB'    
  }# > 1GB
  elseif ($_.s -ge 1MB) {
    $size = $_.s / 1MB
    $unit = 'MB'
  }# > 1MB
  elseif ($_.s -ge 1kB) {
    $size = $_.s / 1kB
    $unit = 'kB'
  }# > 1kB
  else {
    $size = $_.s
    $unit = 'B'
  }
  
  $size = [Math]::Round($size)

  Write-Output ("{0}{1} ({2}) : {3}" -f $size, $unit, $_.s, $_.p)
}
