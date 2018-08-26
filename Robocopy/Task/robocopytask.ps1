param (
	[string]$source,
	[string]$destination,
	[array]$files,
	[string]$copySubDirs,
	[string]$copySubDirsAll,
	[string]$purge,
	[string]$move,
	[string]$createtree,
	[string]$excludeFiles,
	[string]$excludeDirs,
	[string]$retries,
	[string]$copyOptions
)

if ($copySubDirs.ToLower() -eq "true" ) {
	$copyOptions = $copyOptions + " /s"
}

if ($copySubDirsAll.ToLower() -eq "true" ) {
	$copyOptions = $copyOptions + " /e"
}

if ($purge.ToLower() -eq "true" ) {
	$copyOptions = $copyOptions + " /purge"
}

if ($move.ToLower() -eq "true" ) {
	$copyOptions = $copyOptions + " /move"
}

if ($createtree.ToLower() -eq "true" ) {
	$copyOptions = $copyOptions + " /create"
}

if ($excludeFiles -ne "" ) {

	$copyOptions = $copyOptions + " /XF $excludeFiles"
}

if ($excludeDirs -ne "" ) {

	$copyOptions = $copyOptions + " /XD $excludeDirs"
}

if ($retries -ne "" ) {

	$copyOptions = $copyOptions + " /R:$retries"
}

$options = $copyOptions -split "\s+"

if(Test-Path -Path $source) {

	Write-Host "Starting Robocopy with the following options: $copyOptions" 

	if ($files -eq "") {
		
		robocopy $source $destination $options
	} else {

		robocopy $source $destination $files $options
	}

} else {

	Write-Warning "Path $source does not exist"
}

if ($LASTEXITCODE -eq 8)
{
	Write-Error "Some files or directories could not be copied (copy errors occurred and the retry limit was exceeded). Check these errors further."
	exit 1
}

if ($LASTEXITCODE -eq 16)
{
	Write-Error "Serious error. Robocopy did not copy any files. Either a usage error or an error due to insufficient access privileges on the source or destination directories."
	exit 1
}

if ($LASTEXITCODE -gt 16)
{
	Write-Error "Unknown error! Please see log for more details!"
	exit 1
}

if($LASTEXITCODE -le 7) {
	Write-Host "Copying was finished. Please see log for more details."
	exit 0
}
