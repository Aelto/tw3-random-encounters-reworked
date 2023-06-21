# https://github.com/Aelto/tw3-random-encounters-reworked/releases/tag/dependencies-v1.0

cls

echo ""
echo "Installer for the mod Random Encounters Reworked"
echo "This will install Random Encounters and its dependencies based on the mods you have"
echo ""

pause
cls

# before doing anything we check if the script file is placed in the right
# directory. It expects to be placed right in the witcher 3 root.
if (!(test-path dlc)) {
  write-host -ForegroundColor red "Please make sure the script is placed inside your The Witcher 3 install directly"
  echo "Place it in your The Witcher 3 root directory and run the script again."
  echo ""

  pause
  exit
}

# first we create the mods folder if it doesn't exist, because in clean installs
# this folder may be missing.
if (!(test-path mods)) {
  mkdir mods | out-null
}

$dependenciesRelease = "https://api.github.com/repos/Aelto/tw3-random-encounters-reworked/releases/52800894"
$dependenciesReleaseResponse = Invoke-RestMethod -Uri $dependenciesRelease

$extractingFolder = "./__install_rer"
$assetCommunityPatchBase = $dependenciesReleaseResponse.assets | ? {$_.name.StartsWith("community-patch-base")} | Select -First 1
$assetSharedImport = $dependenciesReleaseResponse.assets | ? {$_.name.StartsWith("sharedimport")} |Select -First 1

# do not install community-patch-base if the user already has it or if has EE
if (!(test-path mods/modW3EE) -and !(test-path mods/modW3EEMain)) {
  echo ""
  echo "downloading community-patch-base"

  Invoke-WebRequest -Uri $assetCommunityPatchBase.browser_download_url -OutFile $assetCommunityPatchBase.name
  Expand-Archive -Force -LiteralPath $assetCommunityPatchBase.name -DestinationPath ./$extractingFolder
  remove-item $assetCommunityPatchBase.name -recurse -force
}

# do not install sharedimport if the user already has it or if he has EE
if (!(test-path mods/modSharedImports) -and !(test-path mods/modW3EE) -and !(test-path mods/modW3EEMain)) {
  echo ""
  echo "downloading shared import"

  Invoke-WebRequest -Uri $assetSharedImport.browser_download_url -OutFile $assetSharedImport.name
  Expand-Archive -Force -LiteralPath $assetSharedImport.name -DestinationPath ./$extractingFolder
  remove-item $assetSharedImport.name -recurse -force
}

echo ""
echo "downloading Random Encounters Reworked for 1.32 Old-Gen"

echo "fetching latest v2 release"

$allReleases = "https://api.github.com/repos/Aelto/tw3-random-encounters-reworked/releases"
$allReleasesResponse = Invoke-RestMethod -Uri $allReleases

# get the first release that starts with `v2.`, all OldGen releases will be in
# the "2." rang while NextGen ones are "3."
$latestRelease = $allReleasesResponse | ? {($_.name.StartsWith("v2."))} | Select -First 1
$latestAsset = $latestRelease.assets[0]

write-host "downloading RER $($latestRelease.name)"
Invoke-WebRequest -Uri $latestAsset.browser_download_url -OutFile $latestAsset.name

Expand-Archive -Force -LiteralPath $latestAsset.name -DestinationPath ./$extractingFolder
remove-item $latestAsset.name -recurse -force

# print message notifying which mod will be installed
$children = Get-ChildItem ./$extractingFolder
cls
echo ""
echo "installing the following mods:"
foreach ($child in $children) {
  write-host " - $($child.name)"
}

echo ""
pause

# finally start installing the mods
foreach ($child in $children) {
  $fullpath = "{0}/{1}/*" -f $extractingFolder, $child
  copy-item $fullpath . -force -recurse

  write-host "$($child) installed"
}

if (test-path $extractingFolder) {
  remove-item $extractingFolder -recurse -force
}


# final message
cls


echo "Opening browser at: https://aelto.github.io/tw3-random-encounters-reworked/rer-bible#success-install"
Start-Process "https://aelto.github.io/tw3-random-encounters-reworked/rer-bible#success-install"