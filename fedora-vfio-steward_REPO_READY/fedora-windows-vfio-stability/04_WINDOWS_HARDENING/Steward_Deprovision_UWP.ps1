<# 
Steward_Deprovision_UWP.ps1
Purpose:
  Remove unwanted built-in / Store apps in a way that tends to STICK:
   1) Remove from existing user profiles (Remove-AppxPackage)
   2) Deprovision so it won’t install for NEW profiles (Remove-AppxProvisionedPackage)

Usage:
  - Run PowerShell as Administrator.
  - Optional: Set-ExecutionPolicy -Scope Process Bypass -Force
  - Edit $AppNamePatterns below (use wildcards).
  - Run: .\Steward_Deprovision_UWP.ps1

Notes:
  - Deprovisioning prevents new-user installs, but does NOT remove the app from existing users.
  - Some removals can fail if users are logged in / apps are in use. Reboot and try again.
#>

$AppNamePatterns = @(
  "*Copilot*",
  "*Microsoft.Windows.Copilot*",
  "*Microsoft.Copilot*"
  # Add your own patterns here, e.g. "*BingNews*", "*ZuneMusic*", etc.
)

function Show-Provisioned {
  Write-Host "`n== Provisioned packages (new-user defaults) ==" -ForegroundColor Cyan
  Get-AppxProvisionedPackage -Online | Sort-Object DisplayName | Format-Table DisplayName, PackageName -AutoSize
}

function Remove-InstalledAllUsers([string]$pattern) {
  Write-Host "`n-- Removing INSTALLED packages for pattern: $pattern" -ForegroundColor Yellow
  $pkgs = Get-AppxPackage -AllUsers $pattern -ErrorAction SilentlyContinue
  if (-not $pkgs) { Write-Host "No installed packages matched." -ForegroundColor DarkGray; return }

  foreach ($p in $pkgs) {
    Write-Host "Removing installed: $($p.Name) ($($p.PackageFullName))" -ForegroundColor Yellow
    try {
      # Remove-AppxPackage works best per-user; -AllUsers can be finicky on some builds.
      # This attempts the all-users remove; if it errors, you may need to remove per-user.
      Remove-AppxPackage -Package $p.PackageFullName -AllUsers -ErrorAction Stop
    } catch {
      Write-Warning "Failed Remove-AppxPackage -AllUsers for $($p.Name). Consider removing for the current user or after reboot."
    }
  }
}

function Remove-Provisioned([string]$pattern) {
  Write-Host "`n-- Deprovisioning packages for pattern: $pattern" -ForegroundColor Green
  $prov = Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like $pattern -or $_.PackageName -like $pattern }
  if (-not $prov) { Write-Host "No provisioned packages matched." -ForegroundColor DarkGray; return }

  foreach ($p in $prov) {
    Write-Host "Deprovisioning: $($p.DisplayName)" -ForegroundColor Green
    try {
      Remove-AppxProvisionedPackage -Online -PackageName $p.PackageName -ErrorAction Stop | Out-Null
    } catch {
      Write-Warning "Failed deprovision for $($p.DisplayName): $($_.Exception.Message)"
    }
  }
}

function Show-DeprovisionRegistry {
  $key = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned"
  Write-Host "`n== Deprovisioned registry keys ==" -ForegroundColor Cyan
  if (Test-Path $key) {
    Get-ChildItem $key | Select-Object -ExpandProperty PSChildName
  } else {
    Write-Host "Key not found (this can be normal if nothing is deprovisioned yet)." -ForegroundColor DarkGray
  }
}

Write-Host "Steward UWP Removal + Deprovision" -ForegroundColor Cyan
Show-Provisioned

foreach ($pat in $AppNamePatterns) {
  Remove-InstalledAllUsers -pattern $pat
  Remove-Provisioned -pattern $pat
}

Show-DeprovisionRegistry
Write-Host "`nDone. Reboot, then re-check Installed Apps and provisioned list." -ForegroundColor Cyan
