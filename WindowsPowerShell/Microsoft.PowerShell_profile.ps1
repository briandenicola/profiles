[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$MaximumHistoryCount=4096

#Aliases moved to bottom after all functions are defined

if((Test-Path -Path (Join-Path -Path $ENV:USERPROFILE -ChildPath "Contacts" )))       { Remove-Item -Recurse -Force (Join-Path -Path $ENV:USERPROFILE -ChildPath "Contacts" )}
if((Test-Path -Path (Join-Path -Path $ENV:USERPROFILE -ChildPath "onecoremsvsmon" ))) { Remove-Item -Recurse -Force (Join-Path -Path $ENV:USERPROFILE -ChildPath "onecoremsvsmon" )}
if((Test-Path -Path (Join-Path -Path $ENV:USERPROFILE -ChildPath "Searches" )))       { Remove-Item -Recurse -Force (Join-Path -Path $ENV:USERPROFILE -ChildPath "Searches" )}
if((Test-Path -Path (Join-Path -Path $ENV:USERPROFILE -ChildPath "source" )))         { Remove-Item -Recurse -Force (Join-Path -Path $ENV:USERPROFILE -ChildPath "source" )}
if((Test-Path -Path (Join-Path -Path $ENV:USERPROFILE -ChildPath "Saved Games" )))    { Remove-Item -Recurse -Force (Join-Path -Path $ENV:USERPROFILE -ChildPath "Saved Games" )}
if((Test-Path -Path (Join-Path -Path $ENV:USERPROFILE -ChildPath "3D Objects" )))     { Remove-Item -Recurse -Force (Join-Path -Path $ENV:USERPROFILE -ChildPath "3D Objects" )}
if((Test-Path -Path (Join-Path -Path $ENV:USERPROFILE -ChildPath "Favorites" )))      { Remove-Item -Recurse -Force (Join-Path -Path $ENV:USERPROFILE -ChildPath "Favorites" )}
if((Test-Path -Path (Join-Path -Path $ENV:USERPROFILE -ChildPath "Links" )))          { Remove-Item -Recurse -Force (Join-Path -Path $ENV:USERPROFILE -ChildPath "Links" )}

function New-APIMHeader {
  param(
    [string] $key
  )
  $header = @{}
  $header.Add('Ocp-Apim-Subscription-Key', $Key)
  return $header
}

function Get-DefaultEditor {
  $code = Get-ExecutablePath -processName "code.exe"
  if( [string]::IsNullOrEmpty($code) ) {
    return Get-ExecutablePath -processName "notepad.exe"
  }
  return $code  
}

function Get-AllFilesAndDirectories {
  param (
    [string] $Path = $PWD.path
  )
  Get-ChildItemColor -Path $Path -Attributes Hidden
}

function Get-Profile
{
	&$ENV:EDITOR $profile
}

function Edit-HostFile
{
	&$ENV:EDITOR c:\Windows\System32\drivers\etc\hosts
}

function Set-Home {
  Set-Location -Path $home
}

function cd {
    param ( $location ) 

    if ( $location -eq '-' ) {
        Pop-Location
    }
    else {
        Push-Location $PWD.path
        Set-Location $location
    }
}

function Get-ChildItemColor {
  
  $default = $Host.UI.RawUI.ForegroundColor
  function Write-OutputColoriezed {
    param ( 
      [string] $ForeGroundColor,
      [object] $Message
    ) 
    $Host.UI.RawUI.ForegroundColor = $ForeGroundColor
    Write-Output $Message
    $Host.UI.RawUI.ForegroundColor = $default
  }
  
  Invoke-Expression ("Get-ChildItem $args") | ForEach-Object {
    if ($_.PSIsContainer -eq $true) {
      Write-OutputColoriezed -ForeGroundColor 'Blue' -Message $_
    }
    elseif ($_.Extension -match '\.(zip|tar|gz|rar)$') {
      Write-OutputColoriezed -ForeGroundColor 'DarkGray' -Message $_
    }
    elseif ($_.Extension -match '\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg)$') {
      Write-OutputColoriezed -ForeGroundColor 'DarkCyan' -Message $_
    }
    elseif ($_.Extension -match '\.(txt|cfg|conf|ini|csv|sql|xml|config)$') {
      Write-OutputColoriezed -ForeGroundColor 'Cyan' -Message $_
    }
    elseif ($_.Extension -match '\.(cs|asax|aspx.cs)$') {
      Write-OutputColoriezed -ForeGroundColor 'Yellow' -Message $_
    }
    elseif ($_.Extension -match '\.(aspx|spark|master)$') {
      Write-OutputColoriezed -ForeGroundColor 'DarkYellow' -Message $_
    }
    elseif ($_.Extension -match '\.(sln|csproj)$') {
      Write-OutputColoriezed -ForeGroundColor 'Magenta' -Message $_
    }
    elseif ($_.Extension -match '\.(docx|doc|xls|xlsx|pdf|mobi|epub|mpp|)$') {
      Write-OutputColoriezed -ForeGroundColor 'Gray' -Message $_
    }
    else {
      Write-OutputColoriezed -ForeGroundColor $default -Message $_
    }
  }
}

& {
  for ($i = 0; $i -lt 26; $i++) { 
      $funcname = ([System.Char]($i + 65)) + ':'
      $str = "Function global:$funcname { Set-Location $funcname } " 
      Invoke-Expression $str 
  }
}
 
Remove-Item alias:cd
Remove-Item alias:ls

$ENV:EDITOR = Get-DefaultEditor

New-Alias -Name gh    -Value Get-History 
New-Alias -Name i     -Value Invoke-History
New-Alias -Name code  -Value $ENV:EDITOR
New-Alias -Name sudo  -Value Start-ElevatedConsole
New-Alias -Name top   -Value (Join-PATH $ENV:SCRIPTS_HOME "TaskManager\Get-CpuLoad.ps1")
New-Alias -Name ll    -Value Get-AllFilesAndDirectories
New-Alias -Name ls    -Value Get-ChildItemColor
New-Alias -Name hf    -Value Edit-HostFile
New-Alias -Name home  -Value Set-Home

$ChocolateyProfile = "$ENV:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}