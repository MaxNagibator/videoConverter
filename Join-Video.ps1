param(
)


$ErrorActionPreference = "Stop"
$logs = "c:\Logs\Tasks\Freq"
Set-Alias ffmpeg "c:\Services\utils\ffmpeg\ffmpeg.exe"
Set-Alias ffprobe "c:\Services\utils\ffmpeg\ffprobe.exe"

$start = Get-Date

try
{
	ffmpeg -f concat -safe 0 -i Join-Video.txt -c copy -y output.mkv
}
catch {
	$_ | Format-List * -Force | Out-String 
    #throw
}
finally {
	Write-Host "Took: " ((Get-Date) - $start)
}
