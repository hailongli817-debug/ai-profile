# 校验并保存 GitHub 细粒度令牌
# 用法：powershell -ExecutionPolicy Bypass -File C:\Users\Li\ai-profile\tools\set-github-token.ps1
# 令牌不回显、不落盘、不进 git。

param(
    [string]$Owner = "hailongli817-debug",
    [string]$Repo  = "ai-profile"
)

$ErrorActionPreference = "Stop"
$envName = "GITHUB_PERSONAL_ACCESS_TOKEN"

Write-Host ""
Write-Host "粘贴 fine-grained PAT（输入不回显）:" -ForegroundColor Cyan
$secure = Read-Host -AsSecureString
$plain = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
)

if ([string]::IsNullOrWhiteSpace($plain)) {
    Write-Host "没有输入，退出。" -ForegroundColor Red
    exit 1
}

$headers = @{
    Authorization  = "Bearer $plain"
    "User-Agent"   = "ai-profile-setup"
    Accept         = "application/vnd.github+json"
}

try {
    $me = Invoke-RestMethod -Uri "https://api.github.com/user" -Headers $headers -Method Get
    Write-Host "账号: $($me.login)" -ForegroundColor Green
} catch {
    Write-Host "令牌无效或网络不通: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

try {
    $repoInfo = Invoke-RestMethod -Uri "https://api.github.com/repos/$Owner/$Repo" -Headers $headers -Method Get
    Write-Host "仓库可读: $($repoInfo.full_name)  private=$($repoInfo.private)" -ForegroundColor Green
} catch {
    Write-Host "读不到 $Owner/$Repo。检查令牌的 Repository access 是否勾了这个仓库。" -ForegroundColor Red
    exit 1
}

try {
    $file = Invoke-RestMethod -Uri "https://api.github.com/repos/$Owner/$Repo/contents/AGENTS.md" -Headers $headers -Method Get
    Write-Host "文件可读: AGENTS.md ($($file.size) bytes)" -ForegroundColor Green
} catch {
    Write-Host "读文件失败，Contents 权限可能没给。" -ForegroundColor Red
    exit 1
}

[Environment]::SetEnvironmentVariable($envName, $plain, "User")
$env:GITHUB_PERSONAL_ACCESS_TOKEN = $plain

Write-Host ""
Write-Host "已写入用户环境变量 $envName（当前窗口也已生效）" -ForegroundColor Green
Write-Host "下一步：agy mcp list" -ForegroundColor Cyan
Write-Host ""
Write-Host "注意：写权限不在这里验。真写一次 inbox/ 下的文件，再 git pull 看结果。" -ForegroundColor Yellow
