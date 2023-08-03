$CHOCO_URL = 'https://chocolatey.org/install.ps1'
$ANDROID_SDK_PATH = "C:\Android\Sdk"
$ANDROID_HOME = "ANDROID_HOME"
$JAVA_HOME = "JAVA_HOME"
$ENV_MACHINE = "Machine"

function Show-Intro {
    Write-Host @"
.------------------..------------------..------------------.
| .--------------. || .--------------. || .--------------. |
| |  _______     | || | ____    ____ | || |  _______     | |
| | |_   __ \    | || ||_   \  /   _|| || | |_   __ \    | |
| |   | |__) |   | || |  |   \/   |  | || |   | |__) |   | |
| |   |  __ /    | || |  | |\  /| |  | || |   |  __ /    | |
| |  _| |  \ \_  | || | _| |_\/_| |_ | || |  _| |  \ \_  | |
| | |____| |___| | || ||_____||_____|| || | |____| |___| | |
| |              | || |              | || |              | |
| '--------------' || '--------------' || '--------------' |
'------------------''------------------''------------------'
    Hello, My name is Rodolfo, take a coffee and relax!
            We are setting up your computer...
"@
}

function Install-Chocolatey {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString($CHOCO_URL))
}

function Install-Packages {
    param(
        [string[]]$packages
    )

    foreach ($package in $packages) {
        choco install $package --ignore-checksums -y
    }
}

function New-Directories {
    param(
        [string]$dirPath
    )
    
    New-Item -ItemType Directory -Force -Path $dirPath
}

function Set-EnvironmentVariables {
    param(
        [string]$javaPath,
        [string]$androidPath
    )

    [Environment]::SetEnvironmentVariable($ANDROID_HOME, $androidPath, $ENV_MACHINE)
    [Environment]::SetEnvironmentVariable($JAVA_HOME, $javaPath, $ENV_MACHINE)
}
    
function Update-Path {
    param(
        [string]$androidPath
    )
        
    $path = [Environment]::GetEnvironmentVariable("Path", $ENV_MACHINE)
    $newPath = $path + ";%$androidPath%\emulator;%$androidPath%\tools;%$androidPath%\tools\bin;%$androidPath%\platform-tools"
    [Environment]::SetEnvironmentVariable("Path", $newPath, $ENV_MACHINE)
}

function EXECUTE {
    Show-Intro
    Install-Chocolatey
    
    $packages = @(
        "notepadplusplus",
        "nodejs.install",
        "python3",
        "golang",
        "dbeaver",
        "spotify",
        "yarn",
        "7zip",
        "warp --version=22.8.857.0",
        "visualstudio2019community",
        "vscode",
        "postman",
        "git.install",
        "openjdk11",
        "androidstudio",
        "docker-desktop",
        "docker-compose"
    )

    Install-Packages -packages $packages
    New-Directories -dirPath $ANDROID_SDK_PATH
        
    Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
    Update-SessionEnvironment
    
    $javaPath = ((Get-Command java).Source -split '\\bin')[0]
    Set-EnvironmentVariables -javaPath $javaPath -androidPath $ANDROID_SDK_PATH
    
    Update-Path -androidPath $ANDROID_SDK_PATH
}

EXECUTE
