param(
	[parameter(Mandatory=$true)]		[string]$file,
	[parameter(Mandatory=$true)]		[string]$newfile
)


$ErrorActionPreference = "Stop"
$logs = "c:\Logs\Tasks\Freq"
Set-Alias ffmpeg "c:\Services\utils\ffmpeg\ffmpeg.exe"
Set-Alias ffprobe "c:\Services\utils\ffmpeg\ffprobe.exe"

$start = Get-Date

function Convert-File($file, $newfile) {
	ffmpeg -i $file -c:v libx264 -crf 18 -c:a aac 	-f mp4 -crf 33 -b:a 128k -map_metadata 0 $newfile -y 
	# -map 0:0 -map 0:1 первый это дорожка видео, 2 дорожка аудио, если несколько дорожек
	#ffmpeg -i $file -c:v libx264 -crf 18 -c:a aac 	-f mp4 -crf 33 -b:a 128k -map_metadata 0 -map 0:0 -map 0:1 $newfile -y 
	if($LASTEXITCODE -ne 0)
	{
		throw "Conversion $file to $newfile failed"
	}
}

try
{
	$date = Get-Date -Format "yyyy-MM-dd_HH-mm_ss.fff"
	$logName = [IO.Path]::GetFileNameWithoutExtension($PSCommandPath)
	$log = Join-Path $logs -ChildPath "$($logName)_$date.log"	
	Start-Transcript -Path ($log)
	echo Processing $file
	
	Convert-File $file $newfile
}
catch {
	$_ | Format-List * -Force | Out-String 
    #throw
}
finally {
	Write-Host "Took: " ((Get-Date) - $start)
	Stop-Transcript
}
