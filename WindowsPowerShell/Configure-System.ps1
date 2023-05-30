Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; 
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

choco install git
choco install vim 
choco install oh-my-posh
choco install powershell-core

New-Item -Path c:\Users\Manager\Documents\ -Name PowerShell -ItemType Directory
cp .\Microsoft.PowerShell_profile.ps1 c:\Users\Manager\Documents\PowerShell\.
. c:\Users\Manager\Documents\PowerShell\Microsoft.PowerShell_profile.ps1

New-Item -Path c:\ -Name code -ItemType Directory
Set-location C:\code

git clone https://github.com/briandenicola/psscripts.git
cd c:\Code\psscripts\Miscellaneous\
.\Update-PSModules.ps1

Update-PathVariable -Path "C:\Program Files\PowerShell\7\pwsh.exe" -Target Machine
Update-PathVariable -Path "C:\Program Files\PowerShell (x86)\7\pwsh.exe" -Target Machine -Remove
Update-PathVariable -Refresh

