
# fetching the release assets from the github api
echo "Fetching latest release from github"
$response = Invoke-RestMethod -Uri "https://api.github.com/repos/Aelto/W3_RandomEncounters_Tweaks/releases"

# showing info about the new release
$latestversion = $response[0].name
write-host -nonewline "latest release: "
write-host $latestversion -ForegroundColor green

echo ""
echo "=== CHANGELOG ==="

$body = $response[0].body
write-host $body -ForegroundColor gray -BackgroundColor black 

echo "=== CHANGELOG ==="
echo ""

echo "You can still cancel by closing the window or..."
pause
echo ""

# downloading file
echo "Downloading latest release from github"
Invoke-WebRequest -Uri $response[0].assets[0].browser_download_url -OutFile $response[0].assets[0].name

#extracting the archive
echo "Extracting zip archive"
Expand-Archive -Force -LiteralPath $response[0].assets[0].name -DestinationPath $response[0].name

# installing release
$releaseFolder = (Get-ChildItem -Path $response[0].name | Select-Object -First 1).Name
$releaseFolderChild = (Get-ChildItem -Path $releaseFolder -Force -Recurse | Select-Object -First 1)
$fullpath = "{0}/*" -f $releaseFolderChild

$installMessage = "Installing release {0}" -f $response[0].name

echo $installMessage
copy-item $fullpath "../../" -force -recurse

# cleanup
remove-item $response[0].name -recurse -force
remove-item $response[0].assets[0].name -recurse -force

$installedMessage = "=== release {0} installed ===" -f $latestversion

echo ""
write-host $installedMessage -ForegroundColor green -BackgroundColor black
echo ""

pause