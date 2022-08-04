Import-Module -Name bjd.Common.Functions

# Uncomment for macOS
#Set-EnvironmentVariable -Key PUBKEY  -Value "/Users/briandenicola/.ssh/id_rsa.pub"
#Set-EnvironmentVariable -Key EDITOR  -Value "/opt/homebrew/bin/code"
#Set-EnvironmentVariable -Key PATH    -Value "/usr/local/microsoft/powershell/7:/Users/briandenicola/bin:/usr/local/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/share/dotnet:~/.dotnet/tools"
#
#Invoke-Expression (oh-my-posh --init --shell pwsh --config /opt/homebrew/opt/oh-my-posh/themes/hotstick.minimal.omp.json)
#

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$MaximumHistoryCount=4096

Set-PSReadLineKeyHandler -Key UpArrow   -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Tab       -Function TabCompleteNext
Set-PSReadLineOption     -PredictionSource History

#Aliases moved to bottom after all functions are defined

if((Test-Path -Path (Join-Path -Path $ENV:USERPROFILE -ChildPath "Contacts" )))       { Remove-Item -Recurse -Force (Join-Path -Path $ENV:USERPROFILE -ChildPath "Contacts" )}
if((Test-Path -Path (Join-Path -Path $ENV:USERPROFILE -ChildPath "onecoremsvsmon" ))) { Remove-Item -Recurse -Force (Join-Path -Path $ENV:USERPROFILE -ChildPath "onecoremsvsmon" )}
if((Test-Path -Path (Join-Path -Path $ENV:USERPROFILE -ChildPath "Searches" )))       { Remove-Item -Recurse -Force (Join-Path -Path $ENV:USERPROFILE -ChildPath "Searches" )}
if((Test-Path -Path (Join-Path -Path $ENV:USERPROFILE -ChildPath "source" )))         { Remove-Item -Recurse -Force (Join-Path -Path $ENV:USERPROFILE -ChildPath "source" )}
if((Test-Path -Path (Join-Path -Path $ENV:USERPROFILE -ChildPath "Saved Games" )))    { Remove-Item -Recurse -Force (Join-Path -Path $ENV:USERPROFILE -ChildPath "Saved Games" )}
if((Test-Path -Path (Join-Path -Path $ENV:USERPROFILE -ChildPath "3D Objects" )))     { Remove-Item -Recurse -Force (Join-Path -Path $ENV:USERPROFILE -ChildPath "3D Objects" )}
if((Test-Path -Path (Join-Path -Path $ENV:USERPROFILE -ChildPath "Favorites" )))      { Remove-Item -Recurse -Force (Join-Path -Path $ENV:USERPROFILE -ChildPath "Favorites" )}
if((Test-Path -Path (Join-Path -Path $ENV:USERPROFILE -ChildPath "Links" )))          { Remove-Item -Recurse -Force (Join-Path -Path $ENV:USERPROFILE -ChildPath "Links" )}

function New-AzureWin2K19Server 
{
  param(
    [switch] $destroy
  )

  Set-Variable -Name terraform_location -Value "c:\code\github\packer-windows2019-azure\terraform\"

  Set-EnvironmentVariable -Key ARM_SUBSCRIPTION_ID  -Value "bfafbd89-a2a3-43a5-af72-fb4ef0c514c1"
  Set-EnvironmentVariable -Key ARM_TENANT_ID        -Value "72f988bf-86f1-41af-91ab-2d7cd011db47"
  Set-EnvironmentVariable -Key ARM_CLIENT_ID        -Value "4e565daf-621d-48d3-b010-1208da519cbe"
  Set-EnvironmentVariable -Key ARM_CLIENT_SECRET    -Value (spn)

  $cwd = $PWD.Path
  Set-location -Path $terraform_location

  $opts = @{
    ResourceGroupName           = "CORE_INFRA_TEMPLATES_RG"
    GalleryName                 = "BjdAzureDemoGallery"
    GalleryImageDefinitionName  = "bjdWin2k19.core"
  }
  $latest_version = Get-AzGalleryImageVersion @opts | Select-Object -ExpandProperty Name | Sort-Object -Descending -Top 1

  if($destroy) {
    terraform destroy -var-file azure.tfvars -var "image_version=$latest_version"
  }
  else {
    terraform apply -var-file azure.tfvars -var "image_version=$latest_version"
  }
  Set-Location -Path $cwd

  Remove-EnvironmentVariable -Key ARM_SUBSCRIPTION_ID -Force
  Remove-EnvironmentVariable -Key ARM_TENANT_ID -Force     
  Remove-EnvironmentVariable -Key ARM_CLIENT_ID -Force     
  Remove-EnvironmentVariable -Key ARM_CLIENT_SECRET -Force

}

function prompt
{
  if(Get-IsAdminConsole) {
    $Role = "(Admin)"
  } 
  else {
    $Role = ""
  }

  $prompt = "[{0}] {4} {1}@{2} | {3}>" -f (Get-Date).Tostring("HH:mm:ss"), $ENV:USERNAME, $ENV:COMPUTERNAME, $PWD.Path, $Role
  Write-Host $prompt -NoNewline -ForegroundColor Gray
  return " "
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
  (Get-ChildItem -Path $Path -Attributes Hidden) + (Get-ChildItem -Path $Path) |
   Sort-Object -Property Type,Name |
   Set-ChildItemColor
}

function Get-FilesAndDirectories {
  param (
    [string] $Path = $PWD.path
  )
  Get-ChildItem -Path $Path | Set-ChildItemColor
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

function Set-ChildItemColor {
  
  param(
    [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
    [object[]] $items
  )

  begin {
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
  }
  process { 
    foreach( $item in $items ){
      if ($item.PSIsContainer -eq $true) {
        Write-OutputColoriezed -ForeGroundColor 'Blue' -Message $item
      }
      elseif ($item.Extension -match '\.(zip|tar|gz|rar)$') {
        Write-OutputColoriezed -ForeGroundColor 'DarkGray' -Message $item
      }
      elseif ($item.Extension -match '\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg)$') {
        Write-OutputColoriezed -ForeGroundColor 'DarkCyan' -Message $item
      }
      elseif ($item.Extension -match '\.(txt|cfg|conf|ini|csv|sql|xml|config)$') {
        Write-OutputColoriezed -ForeGroundColor 'Cyan' -Message $item
      }
      elseif ($item.Extension -match '\.(cs|asax|aspx.cs)$') {
        Write-OutputColoriezed -ForeGroundColor 'Yellow' -Message $item
      }
      elseif ($item.Extension -match '\.(aspx|spark|master)$') {
        Write-OutputColoriezed -ForeGroundColor 'DarkYellow' -Message $item
      }
      elseif ($item.Extension -match '\.(sln|csproj)$') {
        Write-OutputColoriezed -ForeGroundColor 'Magenta' -Message $item
      }
      elseif ($item.Extension -match '\.(docx|doc|xls|xlsx|pdf|mobi|epub|mpp|)$') {
        Write-OutputColoriezed -ForeGroundColor 'Gray' -Message $item
      }
      else {
        Write-OutputColoriezed -ForeGroundColor $default -Message $item
      }
    }
  }
  end {}
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

New-Alias -Name gh        -Value Get-History 
New-Alias -Name i         -Value Invoke-History
New-Alias -Name code      -Value $ENV:EDITOR
New-Alias -Name sudo      -Value Start-ElevatedConsole
New-Alias -Name ll        -Value Get-AllFilesAndDirectories
New-Alias -Name ls        -Value Get-FilesAndDirectories
New-Alias -Name hf        -Value Edit-HostFile
New-Alias -Name home      -Value Set-Home
New-Alias -Name vi        -Value vim
New-Alias -Name Get-Hash  -Value Get-FileHash
New-Alias -Name rdp       -Value (Join-Path -Path $ENV:windir -ChildPath "system32\mstsc.exe")
New-Alias -Name vm        -Value New-AzureVM
New-Alias -Name vpn       -Value Connect-ToAzureVPN
New-Alias -Name top       -Value (Join-PATH $ENV:SCRIPTS_HOME "TaskManager\Get-CpuLoad.ps1")
New-Alias -Name pgrep     -Value Select-String 
New-Alias -Name nslookup  -Value Resolve-DnsName
New-Alias -Name ipconfig  -Value Get-NetIPAddress

oh-my-posh --init --shell pwsh --config C:\Users\brdenico\code\profiles\oh-my-posh\ohmyposh.json | Invoke-Expression