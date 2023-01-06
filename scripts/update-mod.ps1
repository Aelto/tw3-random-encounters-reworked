
# Showing a link to RER.
echo ""
write-host -ForegroundColor yellow "If you enjoy the mod, the script and everything that goes with RER. Please consider endorsing my mod!"
echo ""
write-host -ForegroundColor yellow "                      https://www.nexusmods.com/witcher3/mods/5018"
echo ""

# Fetching the release assets from the github api.
echo "Fetching latest release from github"
$response = Invoke-RestMethod -Uri "https://api.github.com/repos/Aelto/W3_RandomEncounters_Tweaks/releases"

# Showing info about the new release.
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

# Downloading file.
echo "Downloading latest release from github"
Invoke-WebRequest -Uri $response[0].assets[0].browser_download_url -OutFile $response[0].assets[0].name

# Extracting the archive.
echo "Extracting zip archive"
Expand-Archive -Force -LiteralPath $response[0].assets[0].name -DestinationPath ./RER_NEW_RELEASE

# Installing release.
$releaseFolder = "./RER_NEW_RELEASE"
$releaseFolderChild = (Get-ChildItem -Path $releaseFolder -Force -Recurse | Select-Object -First 1).Name
$fullpath = "{0}/{1}/*" -f $releaseFolder, $releaseFolderChild

$installMessage = "Installing release {0}" -f $response[0].name

echo $installMessage
copy-item $fullpath "../../" -force -recurse

# Cleanup.
remove-item $releaseFolder -recurse -force
remove-item $response[0].assets[0].name -recurse -force

$installedMessage = "=== release {0} installed ===" -f $latestversion

echo ""
write-host $installedMessage -ForegroundColor green -BackgroundColor black
echo ""

pause
