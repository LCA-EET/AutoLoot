$weiduApps		= @("weidu.exe", "weidu_linux")
$weiduExts		= @(".exe", "")
$weiduArchives 	= @("_(win)", "_(linux)")

$basePath = "AutoLoot"
$tp2Name = "AutoLoot"
$modPath = $basePath + "/" + $tp2Name 
$exePath = "setup-" + $tp2Name
$testDir = "F:\Baldur's Gate EE\00783\"
$folders = @(
'bam',
'tra',
'lua_ext'
)

foreach($weiduArchive in $weiduArchives){
	Remove-Item -LiteralPath ($basePath + $weiduArchive + ".zip") -Force

}
Remove-Item -LiteralPath $basePath -Force -Recurse

foreach($folder in $folders){
	Copy-Item -Path $folder -Destination ($modPath + "/" + $folder) -Recurse	
}

Copy-Item -Path ($tp2Name + ".tp2") -Destination $modPath 

Copy-Item -Path "readme.md" -Destination ($modPath + "/ReadMe.md")
Copy-Item -Path "Discord Server.url" -Destination ($modPath + "/Discord Server.url")
Copy-Item -Path "Beamdog Forum Post.url" -Destination ($modPath + "/Beamdog Forum Post.url")
Copy-Item -Path "Venmo.url" -Destination ($modPath + "/Venmo.url")
Copy-Item -Path "Release Notes.txt" -Destination ($modPath + "/Release Notes.txt")

for ($i = 0; $i -lt $weiduApps.Length; $i++) {
	if($i -gt 0){
		Write-Output "Deleting " ($basePath + "/" + $exePath + $weiduExts[$i-1])
		Remove-Item -LiteralPath ($basePath + "/" + $exePath + $weiduExts[$i-1])
	}
    Copy-Item -Path $weiduApps[$i] -Destination ($basePath + "/" + $exePath + $weiduExts[$i])
	
	$7zipPath = "$env:ProgramFiles/7-Zip/7z.exe"

	if (-not (Test-Path -Path $7zipPath -PathType Leaf)) {
		$7zipPath = "F:/Program Files/7-Zip/7z.exe"
	}

	Set-Alias Start-SevenZip $7zipPath

	$archive = $basePath + $weiduArchives[$i] + ".zip"
	$Source = "./" + $basePath + "/*"
	$Target = "./" + $archive

	Start-SevenZip a -mx=9 $Target $Source

	#Remove-Item -LiteralPath $basePath -Force -Recurse
	#Get-FileHash $archive -Algorithm SHA256 > SHA256.txt

	Copy-Item -Path $archive -Destination ("\\nas.home.lan\smbuser\Home\Installers\" + $archive)
}



