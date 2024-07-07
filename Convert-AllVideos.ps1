$ErrorActionPreference = "Stop"
Set-PSDebug -Strict;

$logs = "c:\Logs\Tasks\Freq"

$start = Get-Date

function Convert-Files($folder, $newFolder) {
	if (Test-Path $newFolder) {
		Write-Host "Folder Exists"
	}
	else
	{
		New-Item $newFolder -ItemType Directory
		Write-Host "Folder Created successfully"
	}
	$mp4s = Get-ChildItem $folder -Recurse #-Filter "*.mp4"
	$mp4s | %{
		$newfile = "$newFolder\$_.converted.mp4"
		write $newfile
		if ((Test-Path $newfile) -eq $false) {
			D:\torrents\convertVideo\Convert-Video.ps1 "$folder\$_" $newfile
		}
	}
}

try {
	$date = Get-Date -Format "yyyy-MM-dd_HH-mm_ss.fff"
	$logName = [IO.Path]::GetFileNameWithoutExtension($PSCommandPath)
	$log = Join-Path $logs -ChildPath "$($logName)_$date.log"	
	#Start-Transcript -Path ($log)

	Convert-Files "D:\torrents\Futurama DVD\Futurama s5" "D:\torrents\Futurama DVD\Futurama s5Converted" 1
}
catch {
    throw
}
finally {
	Write-Host "Took: " ((Get-Date) - $start)
	#Stop-Transcript	
}