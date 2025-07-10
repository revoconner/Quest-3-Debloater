# Quest 3 Debloater - Self-Contained Remote Script
# Usage: iex (iwr "https://raw.githubusercontent.com/yourusername/yourrepo/main/debloater.ps1").Content

param(
    [switch]$SkipDownload,
    [string]$TempPath = $null
)

$ErrorActionPreference = "Stop"

# Configuration
$GitHubUser = "revoconner"  # Replace with actual username
$RepoName = "Quest-3-Debloater"
$Branch = "main"
$PlatformToolsUrl = "https://dl.google.com/android/repository/platform-tools-latest-windows.zip"

function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

function Test-AdbConnection {
    param([string]$AdbPath)
    
    try {
        $devices = & "$AdbPath" devices 2>$null
        return $devices -match "device$"
    }
    catch {
        return $false
    }
}

function Disable-QuestApps {
    param([string]$AdbPath)
    
    $appsToDisable = @(
        @{Name="Facebook Messenger"; Package="com.facebook.orca"},
        @{Name="Facebook for Oculus"; Package="com.oculus.facebook"},
        @{Name="WhatsApp"; Package="com.whatsapp"},
        @{Name="Meta Worlds"; Package="com.meta.worlds"},
        @{Name="Oculus Updater"; Package="com.oculus.updater"},
        @{Name="Oculus Social Platform"; Package="com.oculus.socialplatform"},
        @{Name="Meta Horizon Ad ID Service"; Package="com.meta.horizonadidservice"},
        @{Name="Oculus IGVR"; Package="com.oculus.igvr"}
    )

    Write-ColorOutput "=== Quest 3 App Debloater ===" "Cyan"
    Write-ColorOutput ""

    # Check devices
    Write-ColorOutput "Checking connected devices..." "Yellow"
    & "$AdbPath" devices
    
    if (-not (Test-AdbConnection -AdbPath $AdbPath)) {
        Write-ColorOutput "Warning: No Quest device detected!" "Red"
        Write-ColorOutput "Please ensure:" "Yellow"
        Write-ColorOutput "  1. Quest is connected via USB" "Yellow"
        Write-ColorOutput "  2. Developer mode is enabled" "Yellow"
        Write-ColorOutput "  3. USB debugging is authorized" "Yellow"
        Read-Host "Press Enter to continue anyway, or Ctrl+C to exit"
    }

    Write-ColorOutput "Waiting 15 seconds for device initialization..." "Yellow"
    Start-Sleep -Seconds 15

    Write-ColorOutput ""
    Write-ColorOutput "Starting to disable Quest 3 apps..." "Green"
    Write-ColorOutput ""

    $successCount = 0
    foreach ($app in $appsToDisable) {
        Write-ColorOutput "Disabling $($app.Name)..." "Cyan"
        
        try {
            $result = & "$AdbPath" shell pm disable-user --user 0 $app.Package 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-ColorOutput "Success: $($app.Name) disabled successfully" "Green"
                $successCount++
            } else {
                Write-ColorOutput "Failed to disable $($app.Name): $result" "Red"
            }
        }
        catch {
            Write-ColorOutput "Error disabling $($app.Name): $($_.Exception.Message)" "Red"
        }
        
        Start-Sleep -Seconds 1
        Write-ColorOutput ""
    }

    Write-ColorOutput "Process completed! $successCount/$($appsToDisable.Count) apps disabled successfully." "Green"
    Write-ColorOutput ""
}

# Main execution
try {
    Write-ColorOutput "=== Quest 3 Debloater Remote Installer ===" "Cyan"
    Write-ColorOutput ""

    # Determine temp directory
    if (-not $TempPath) {
        $TempPath = Join-Path $env:TEMP "Quest3Debloater_$(Get-Random)"
    }
    
    New-Item -ItemType Directory -Path $TempPath -Force | Out-Null
    Write-ColorOutput "Using directory: $TempPath" "Green"

    if (-not $SkipDownload) {
        # Download ADB platform tools
        Write-ColorOutput "Downloading ADB platform tools from Google..." "Yellow"
        $PlatformToolsZip = Join-Path $TempPath "platform-tools.zip"
        
        try {
            Invoke-WebRequest -Uri $PlatformToolsUrl -OutFile $PlatformToolsZip -UseBasicParsing -TimeoutSec 60
            Write-ColorOutput "Download completed" "Green"
        }
        catch {
            Write-ColorOutput "Failed to download ADB tools: $($_.Exception.Message)" "Red"
            throw
        }

        # Extract platform tools
        Write-ColorOutput "Extracting ADB tools..." "Yellow"
        try {
            Expand-Archive -Path $PlatformToolsZip -DestinationPath $TempPath -Force
            Write-ColorOutput "Extraction completed" "Green"
        }
        catch {
            Write-ColorOutput "Failed to extract: $($_.Exception.Message)" "Red"
            throw
        }
    }

    # Find ADB executable
    $AdbPath = Join-Path $TempPath "platform-tools\adb.exe"
    if (-not (Test-Path $AdbPath)) {
        Write-ColorOutput "ADB executable not found at: $AdbPath" "Red"
        throw "ADB not found"
    }

    Write-ColorOutput "ADB found at: $AdbPath" "Green"
    Write-ColorOutput ""

    # Run the debloater
    Disable-QuestApps -AdbPath $AdbPath

} catch {
    Write-ColorOutput "Error: $($_.Exception.Message)" "Red"
    Write-ColorOutput "Please try again or check your internet connection." "Yellow"
} finally {
    # Optional cleanup
    $cleanup = Read-Host "Delete temporary files? (y/N)"
    if ($cleanup -eq 'y' -or $cleanup -eq 'Y') {
        Write-ColorOutput "Cleaning up temporary files..." "Yellow"
        if (Test-Path $TempPath) {
            Remove-Item $TempPath -Recurse -Force -ErrorAction SilentlyContinue
            Write-ColorOutput "Cleanup complete!" "Green"
        }
    } else {
        Write-ColorOutput "Files kept at: $TempPath" "Yellow"
    }
    
    Read-Host "Press Enter to exit"
}