# https://github.com/Aelto/tw3-random-encounters-reworked/releases/tag/dependencies-v1.0

cls

echo ""
echo "Installer for the mod Random Encounters Reworked."
echo "This will install Random Encounters and its dependencies based on the mods you have."
echo ""

pause
cls

# Before doing anything we check if the script file is placed in the right
# directory. It expects to be placed right in the witcher 3 root.
if (!(test-path dlc)) {
  write-host -ForegroundColor red "Please make sure the script is placed inside your The Witcher 3 install directly!"
  echo "Place it in your The Witcher 3 root directory and run the script again."
  echo ""

  pause
  exit
}

# First we create the mods folder if it doesn't exist, because in clean installs
# this folder may be missing.
if (!(test-path mods)) {
  mkdir mods | out-null
}

$dependenciesRelease = "https://api.github.com/repos/Aelto/tw3-random-encounters-reworked/releases/52800894"
$dependenciesReleaseResponse = Invoke-RestMethod -Uri $dependenciesRelease

$extractingFolder = "./__install_rer"
$extractingFolderPatches = "./__install_rer_patches"
$assetCommunityPatchBase = $dependenciesReleaseResponse.assets | ? {$_.name.StartsWith("community-patch-base")} | Select -First 1
$assetSharedImport = $dependenciesReleaseResponse.assets | ? {$_.name.StartsWith("sharedimport")} |Select -First 1
$assetBootstrap = $dependenciesReleaseResponse.assets | ? {$_.name.StartsWith("bootstrap")} |Select -First 1
$assetEePatches = $dependenciesReleaseResponse.assets | ? {$_.name.StartsWith("ee-patches")} |Select -First 1
$assetFhudPatches = $dependenciesReleaseResponse.assets | ? {$_.name.StartsWith("fhud-patches")} |Select -First 1

# Do not install community-patch-base if the user already has it or EE.
if (!(test-path mods/modW3EE) -and !(test-path mods/modW3EEMain)) {
  echo ""
  echo "downloading community-patch-base"

  Invoke-WebRequest -Uri $assetCommunityPatchBase.browser_download_url -OutFile $assetCommunityPatchBase.name
  Expand-Archive -Force -LiteralPath $assetCommunityPatchBase.name -DestinationPath ./$extractingFolder
  remove-item $assetCommunityPatchBase.name -recurse -force
}

# Do not install bootstrap if the user already has it.
if (!(test-path mods/modBootstrap-registry)) {
  echo ""
  echo "downloading bootstrap"


  Invoke-WebRequest -Uri $assetBootstrap.browser_download_url -OutFile $assetBootstrap.name
  Expand-Archive -Force -LiteralPath $assetBootstrap.name -DestinationPath ./$extractingFolder
  remove-item $assetBootstrap.name -recurse -force
}

# Do not install sharedimport if the user already has it or EE.
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

# Get the first release that starts with `v2.`, all OldGen releases will be in
# the "2." rang while NextGen ones are "3.".
$latestRelease = $allReleasesResponse | ? {($_.name.StartsWith("v2."))} | Select -First 1
$latestAsset = $latestRelease.assets[0]

write-host "downloading RER $($latestRelease.name)"
Invoke-WebRequest -Uri $latestAsset.browser_download_url -OutFile $latestAsset.name

Expand-Archive -Force -LiteralPath $latestAsset.name -DestinationPath ./$extractingFolder
remove-item $latestAsset.name -recurse -force

# If the user has EE, install the patches for the improved compatibility
# this is done after the RER download because it will overwrite files.
if (test-path mods/modW3EE) {
  echo ""
  echo "downloading W3EE compatibility patches"

  Invoke-WebRequest -Uri $assetEePatches.browser_download_url -OutFile $assetEePatches.name
  Expand-Archive -Force -LiteralPath $assetEePatches.name -DestinationPath ./$extractingFolderPatches
  remove-item $assetEePatches.name -recurse -force
}

# If the user has FHUD, there is a patch for it to display custom 3D map markers.
if (!(test-path mods/modW3EE) -and (test-path mods/modFriendlyHUD)) {
  echo ""
  echo "downloading FHUD compatibility patches"

  Invoke-WebRequest -Uri $assetFhudPatches.browser_download_url -OutFile $assetFhudPatches.name
  Expand-Archive -Force -LiteralPath $assetFhudPatches.name -DestinationPath ./$extractingFolderPatches
  remove-item $assetFhudPatches.name -recurse -force
}

# Print message notifying which mod will be installed.
$children = Get-ChildItem ./$extractingFolder
cls
echo ""
echo "installing the following mods:"
foreach ($child in $children) {
  write-host " - $($child.name)"
}

if (test-path $extractingFolderPatches) {
  echo ""
  echo "installing the following patches:"
  $childrenPatches = Get-ChildItem ./$extractingFolderPatches

  foreach ($child in $childrenPatches) {
    write-host " - $($child.name)"
  }
}

echo ""
pause

# Finally start installing the mods.
foreach ($child in $children) {
  $fullpath = "{0}/{1}/*" -f $extractingFolder, $child
  copy-item $fullpath . -force -recurse

  write-host "$($child) installed"
}

if (test-path $extractingFolderPatches) {
  $childrenPatches = Get-ChildItem ./$extractingFolderPatches

  foreach ($child in $childrenPatches) {
    $fullpath = "{0}/{1}/*" -f $extractingFolderPatches, $child
    copy-item $fullpath . -force -recurse

    write-host "$($child) installed"
  }
}

if (test-path $extractingFolder) {
  remove-item $extractingFolder -recurse -force
}
if (test-path $extractingFolderPatches) {
  remove-item $extractingFolderPatches -recurse -force
}


# Run the update registry script.
echo ""
echo "Updating bootstrap registry for Random Encounters Reworked"
cd ./mods/modRandomEncountersReworked/
./update-registry.bat
cd ../../

# Final message.
cls

if ((test-path ./mods/modImmersiveCam) -or (test-path ./mods/modW3EE)) {
  echo ""
  write-warning "It seems you have Immersive Camera installed."
  echo "Before loading your save, please go in RER's optional features menu and enable the Immersive Camera compatibility"
  echo ""
  echo "Note that if you have Enhanced Edition, EE has a version of Immersive Camera bundled in."
}

if (test-path ./mods/modBootstrap/content/scripts/game/player/player.ws) {
  echo ""
  write-warning "It seems you have Bootstrap Sripthooked installed."
  echo "Before loading your save, please go in RER's optional features menu and enable the Scripthooked compatibility"
}

echo "Opening browser at: https://aelto.github.io/tw3-random-encounters-reworked/rer-bible#success-install"
Start-Process "https://aelto.github.io/tw3-random-encounters-reworked/rer-bible#success-install"