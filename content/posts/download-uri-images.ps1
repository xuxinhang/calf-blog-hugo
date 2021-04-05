
Get-ChildItem |	Where-Object { $_.Name -match ".*?\.md" } |	ForEach-Object {
	$bn = $_.BaseName
	New-Item -Name $bn -Path . -ItemType "directory" -Force
	$pattern = [regex]"!\[.*?\]\((.+?)\)"
	$text = $_ | Get-Content
	$pattern.Matches($text) | ForEach-Object {
		$uri = [Uri][string]$_.Groups[1]
		Write-Host $uri #, $uri.Segments[-1]
		$HttpStream = (New-Object Net.WebClient).OpenRead($uri)
		$FilePath = "$(pwd)/$bn/$($uri.Segments[-1])"
		$FileStream = New-Object System.IO.FileStream($FilePath, [System.IO.FileMode]::OpenOrCreate)
		$HttpStream.CopyTo($FileStream)
		$HttpStream.Dispose()
		$FileStream.Dispose()
	}
}
