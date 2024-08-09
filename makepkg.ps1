$basePath = "AutoLoot"
$tp2Name = "AutoLoot"
$modPath = $basePath + "/" + $tp2Name 
$archive = $basePath + ".zip"
$exePath = "setup-" + $tp2Name + ".exe"
$testDir = "F:\Baldur's Gate EE\00783\"
$folders = @(
'copy',
'tra',
'work',
'lua_ext'
)

Remove-Item -LiteralPath $archive -Force
Remove-Item -LiteralPath $modPath -Force -Recurse

foreach($folder in $folders){
	Copy-Item -Path $folder -Destination ($modPath + "/" + $folder) -Recurse	
}

& $PSScriptRoot/d_compactor.ps1 -dPath $modPath

Copy-Item -Path ("bubb_lib.tph") -Destination $modPath 
Copy-Item -Path ($tp2Name + ".tp2") -Destination $modPath 
Copy-Item -Path "weidu.exe" -Destination ($basePath + "/" + $exePath)
Copy-Item -Path "readme.md" -Destination ($basePath + "/ReadMe.md")
Copy-Item -Path "Release Notes.txt" -Destination ($basePath + "/Release Notes - AutoLoot.txt")

$7zipPath = "$env:ProgramFiles/7-Zip/7z.exe"

if (-not (Test-Path -Path $7zipPath -PathType Leaf)) {
	$7zipPath = "F:/Program Files/7-Zip/7z.exe"
}

Set-Alias Start-SevenZip $7zipPath

$Source = "./" + $basePath + "/*"
$Target = "./" + $archive

Start-SevenZip a -mx=9 $Target $Source

Remove-Item -LiteralPath $basePath -Force -Recurse
Get-FileHash $archive -Algorithm SHA256 > SHA256.txt

Copy-Item -Path $archive -Destination ("\\192.168.1.88\smbuser\Home\Installers\" + $archive)