<#
  Copy-WebsitePhotos.ps1 - copy the photos currently on the Joyful Notes website (from your local
  clone of the JoyfulnotesWebsite repo) into the Google Drive photo folder, one folder per gallery,
  named the way the website's Drive galleries expect ("YYYY-MM-DD Event title").

  Photos are COPIED, not moved: the website keeps its own copies as a fallback.
  Files that already exist in the destination are skipped, so it is safe to run more than once.

  USAGE (in PowerShell, from inside your JoyfulnotesWebsite folder, after "git pull"):
    powershell -ExecutionPolicy Bypass -File .\Copy-WebsitePhotos.ps1
  or give both paths:
    powershell -ExecutionPolicy Bypass -File .\Copy-WebsitePhotos.ps1 -Repo "C:\path\to\JoyfulnotesWebsite" -Drive "G:\Shared drives\JNCC\Photos"
#>
param(
  [string]$Repo = (Get-Location).Path,
  [string]$Drive = 'G:\Shared drives\JNCC\Photos'
)

$ErrorActionPreference = 'Stop'

$map = [ordered]@{
  'images\performances\mru-2024-03' = '2024-03-17 Performance at MRU Bella Concert Hall'
  'images\performances\cny-2024'    = '2024-02-25 Chinese New Year Gala at Southern Alberta Jubilee Auditorium'
  'images\performances\xmas-2023'   = '2023-12-21 Christmas Concert at MRU Bella Concert Hall'
  'images\practice'                 = 'Weekly Practice at Mount Royal University Conservatory'
  # Not a gallery: the leading "_" keeps it off the website's performance section.
  'images\about'                    = '_Website - About & Instructors'
  'images\instructors'              = '_Website - About & Instructors'
}

if (-not (Test-Path -LiteralPath (Join-Path $Repo 'index.html'))) {
  throw "Can't find the website in '$Repo'. Run this from your JoyfulnotesWebsite folder, or pass -Repo `"C:\path\to\JoyfulnotesWebsite`"."
}
if (-not (Test-Path -LiteralPath $Drive)) { throw "Drive folder not found: $Drive" }

$copied = 0; $skipped = 0
foreach ($src in $map.Keys) {
  $from = Join-Path $Repo $src
  if (-not (Test-Path -LiteralPath $from)) { Write-Warning "Missing in repo, skipped: $src"; continue }
  $to = Join-Path $Drive $map[$src]
  if (-not (Test-Path -LiteralPath $to)) { New-Item -ItemType Directory -Path $to | Out-Null }
  foreach ($f in Get-ChildItem -LiteralPath $from -File) {
    $dest = Join-Path $to $f.Name
    if (Test-Path -LiteralPath $dest) { $skipped++; continue }
    Copy-Item -LiteralPath $f.FullName -Destination $dest
    $copied++
  }
  Write-Host ('{0,-34} -> {1}' -f $src, $map[$src])
}
Write-Host ""
Write-Host "Copied $copied photos ($skipped already there) into $Drive"
