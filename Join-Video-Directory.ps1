param(	
	[parameter(Mandatory=$true)]		[string]$dir
)


$ErrorActionPreference = "Stop"
$logs = "c:\Logs\Tasks\Freq"
Set-Alias ffmpeg "c:\Services\utils\ffmpeg\ffmpeg.exe"
Set-Alias ffprobe "c:\Services\utils\ffmpeg\ffprobe.exe"

$outputFile = Join-Path -Path $dir -ChildPath "join_content.txt" 

$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllLines(
    $outputFile,
    (Get-ChildItem -Path $dir -Filter "*.mp4" | 
        ForEach-Object { "file '$($_.FullName.Replace('\', '/'))'" }),
    $utf8NoBom
)

$outputVideo = Join-Path -Path $dir -ChildPath "output.mkv" 

$start = Get-Date

try
{
	ffmpeg -f concat -safe 0 -i $outputFile -c copy -y $outputVideo
	Remove-Item -Path $outputFile -Force -ErrorAction Stop
}
catch {
	$_ | Format-List * -Force | Out-String 
    #throw
}
finally {
	Write-Host "Took: " ((Get-Date) - $start)
}
