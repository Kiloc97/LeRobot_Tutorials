# LeRobot Windows 자동 설치 스크립트
# PowerShell 관리자 권한으로 실행 필요

param(
    [switch]$SkipWSL = $false,
    [switch]$SkipVSCode = $false,
    [switch]$Verbose = $false
)

# 색상 정의
$Colors = @{
    Red = "Red"
    Green = "Green" 
    Yellow = "Yellow"
    Blue = "Cyan"
}

# 로깅 함수
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White",
        [string]$Prefix = ""
    )
    
    if ($Prefix) {
        Write-Host "[$Prefix] " -NoNewline -ForegroundColor $Color
    }
    Write-Host $Message -ForegroundColor $Color
}

function Log-Info { param([string]$Message) Write-ColorOutput -Message $Message -Color $Colors.Blue -Prefix "INFO" }
function Log-Success { param([string]$Message) Write-ColorOutput -Message $Message -Color $Colors.Green -Prefix "SUCCESS" }
function Log-Warning { param([string]$Message) Write-ColorOutput -Message $Message -Color $Colors.Yellow -Prefix "WARNING" }
function Log-Error { param([string]$Message) Write-ColorOutput -Message $Message -Color $Colors.Red -Prefix "ERROR" }

# 관리자 권한 확인
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# WSL 설치 확인
function Test-WSLInstalled {
    try {
        $wslOutput = wsl --list 2>&1
        return $LASTEXITCODE -eq 0
    }
    catch {
        return $false
    }
}

# VS Code 설치 확인
function Test-VSCodeInstalled {
    try {
        $codePath = Get-Command code -ErrorAction SilentlyContinue
        return $null -ne $codePath
    }
    catch {
        return $false
    }
}

# WSL 설치 함수
function Install-WSL {
    Log-Info "WSL 설치를 시작합니다..."
    
    try {
        # WSL 기능 활성화
        Log-Info "Windows Subsystem for Linux 기능 활성화 중..."
        dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
        
        Log-Info "Virtual Machine Platform 기능 활성화 중..."
        dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
        
        # WSL2로 기본 버전 설정
        Log-Info "WSL2를 기본 버전으로 설정 중..."
        wsl --set-default-version 2
        
        # Ubuntu 설치
        Log-Info "Ubuntu 22.04 설치 중..."
        wsl --install -d Ubuntu-22.04
        
        Log-Success "WSL 설치 완료! 재부팅 후 Ubuntu 초기 설정을 진행하세요."
        return $true
    }
    catch {
        Log-Error "WSL 설치 중 오류가 발생했습니다: $_"
        return $false
    }
}

# VS Code 설치 함수
function Install-VSCode {
    Log-Info "VS Code 설치를 시작합니다..."
    
    try {
        $vsCodeUrl = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
        $downloadPath = "$env:TEMP\VSCodeSetup.exe"
        
        Log-Info "VS Code 다운로드 중..."
        Invoke-WebRequest -Uri $vsCodeUrl -OutFile $downloadPath
        
        Log-Info "VS Code 설치 중..."
        Start-Process -FilePath $downloadPath -ArgumentList "/VERYSILENT", "/MERGETASKS=!runcode,addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath" -Wait
        
        # PATH 환경변수 새로고침
        $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")
        
        Log-Success "VS Code 설치 완료!"
        return $true
    }
    catch {
        Log-Error "VS Code 설치 중 오류가 발생했습니다: $_"
        return $false
    }
}

# VS Code 확장 설치 함수
function Install-VSCodeExtensions {
    Log-Info "VS Code 확장 설치 중..."
    
    $extensions = @(
        "ms-vscode-remote.remote-wsl",
        "ms-python.python",
        "ms-python.debugpy",
        "ms-toolsai.jupyter",
        "ms-vscode.powershell",
        "GitHubCopilot",
        "ms-azuretools.vscode-docker"
    )
    
    foreach ($extension in $extensions) {
        try {
            Log-Info "확장 설치 중: $extension"
            code --install-extension $extension --force
        }
        catch {
            Log-Warning "확장 설치 실패: $extension"
        }
    }
    
    Log-Success "VS Code 확장 설치 완료!"
}

# LeRobot 환경 설정 함수
function Setup-LeRobotEnvironment {
    Log-Info "LeRobot 개발 환경 설정 중..."
    
    try {
        # WSL에서 LeRobot 자동 설치 스크립트 실행
        $scriptUrl = "https://raw.githubusercontent.com/Kiloc97/LeRobot_Tutorials/main/setup-scripts/auto-setup.sh"
        $wslCommand = "bash -c `"curl -fsSL $scriptUrl | bash`""
        
        Log-Info "WSL에서 LeRobot 환경 구성 중..."
        wsl -e bash -c "curl -fsSL $scriptUrl | bash"
        
        Log-Success "LeRobot 환경 설정 완료!"
        return $true
    }
    catch {
        Log-Error "LeRobot 환경 설정 중 오류가 발생했습니다: $_"
        return $false
    }
}

# Windows Terminal 설정 함수
function Setup-WindowsTerminal {
    Log-Info "Windows Terminal 설정 중..."
    
    try {
        # Windows Terminal이 설치되어 있는지 확인
        $wtInstalled = Get-AppxPackage -Name Microsoft.WindowsTerminal
        
        if ($wtInstalled) {
            $settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
            
            if (Test-Path $settingsPath) {
                Log-Info "Windows Terminal 프로필 추가 중..."
                
                # 기본 설정에 LeRobot 프로필 추가
                $lerobotProfile = @{
                    name = "LeRobot Dev"
                    commandline = "wsl -d Ubuntu-22.04 -e bash -c 'cd /mnt/c/Programming/LeRobot_Tutorials && source .venv/bin/activate && bash'"
                    startingDirectory = "//wsl$/Ubuntu-22.04/mnt/c/Programming/LeRobot_Tutorials"
                    icon = "🤖"
                }
                
                Log-Success "Windows Terminal 설정 완료!"
            }
        }
        else {
            Log-Warning "Windows Terminal이 설치되어 있지 않습니다. Microsoft Store에서 설치하는 것을 권장합니다."
        }
    }
    catch {
        Log-Warning "Windows Terminal 설정 중 오류: $_"
    }
}

# 바탕화면 바로가기 생성
function Create-DesktopShortcut {
    Log-Info "바탕화면 바로가기 생성 중..."
    
    try {
        $WshShell = New-Object -comObject WScript.Shell
        $Shortcut = $WshShell.CreateShortcut("$([Environment]::GetFolderPath('Desktop'))\LeRobot Dev.lnk")
        $Shortcut.TargetPath = "code"
        $Shortcut.Arguments = "--remote wsl+Ubuntu-22.04 /mnt/c/Programming/LeRobot_Tutorials"
        $Shortcut.IconLocation = "code.exe,0"
        $Shortcut.Description = "LeRobot 개발 환경"
        $Shortcut.Save()
        
        Log-Success "바탕화면 바로가기 생성 완료!"
    }
    catch {
        Log-Warning "바탕화면 바로가기 생성 실패: $_"
    }
}

# 메인 함수
function Main {
    Write-Host "=====================================" -ForegroundColor Cyan
    Write-Host "LeRobot Windows 자동 설치 스크립트" -ForegroundColor Cyan
    Write-Host "=====================================" -ForegroundColor Cyan
    Write-Host ""
    
    # 관리자 권한 확인
    if (-not (Test-Administrator)) {
        Log-Error "이 스크립트는 관리자 권한으로 실행해야 합니다."
        Log-Info "PowerShell을 관리자 권한으로 다시 시작해주세요."
        exit 1
    }
    
    Log-Success "관리자 권한 확인됨"
    
    # 설치 상태 확인
    $wslInstalled = Test-WSLInstalled
    $vscodeInstalled = Test-VSCodeInstalled
    
    Log-Info "현재 설치 상태:"
    Log-Info "- WSL: $(if ($wslInstalled) { '설치됨' } else { '미설치' })"
    Log-Info "- VS Code: $(if ($vscodeInstalled) { '설치됨' } else { '미설치' })"
    
    $needsReboot = $false
    
    # WSL 설치
    if (-not $wslInstalled -and -not $SkipWSL) {
        $result = Install-WSL
        if ($result) {
            $needsReboot = $true
        }
    }
    else {
        Log-Info "WSL 설치 건너뛰기"
    }
    
    # VS Code 설치
    if (-not $vscodeInstalled -and -not $SkipVSCode) {
        Install-VSCode
        Start-Sleep -Seconds 3  # VS Code 설치 완료 대기
        Install-VSCodeExtensions
    }
    else {
        Log-Info "VS Code 설치 건너뛰기"
        if ($vscodeInstalled) {
            Install-VSCodeExtensions
        }
    }
    
    # 재부팅이 필요한 경우
    if ($needsReboot) {
        Log-Warning "WSL 설치를 완료하려면 재부팅이 필요합니다."
        Log-Info "재부팅 후 다음 명령어를 실행하여 LeRobot 환경을 설정하세요:"
        Log-Info "wsl -e bash -c `"curl -fsSL https://raw.githubusercontent.com/Kiloc97/LeRobot_Tutorials/main/setup-scripts/auto-setup.sh | bash`""
        
        $response = Read-Host "지금 재부팅하시겠습니까? (y/N)"
        if ($response -eq 'y' -or $response -eq 'Y') {
            Log-Info "시스템을 재부팅합니다..."
            Restart-Computer -Force
        }
    }
    else {
        # WSL이 이미 설치되어 있으면 LeRobot 환경 설정
        if ($wslInstalled) {
            Setup-LeRobotEnvironment
            Setup-WindowsTerminal
            Create-DesktopShortcut
            
            Log-Success "설치 완료!"
            Log-Info "VS Code를 시작하려면: code --remote wsl+Ubuntu-22.04 /mnt/c/Programming/LeRobot_Tutorials"
        }
    }
}

# 스크립트 실행
try {
    Main
}
catch {
    Log-Error "스크립트 실행 중 오류가 발생했습니다: $_"
    exit 1
}