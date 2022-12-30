# https://github.com/Aelto/tw3-random-encounters-reworked/releases/tag/dependencies-v1.0
# https://github.com/Aelto/tw3-random-encounters-reworked/releases/latest/download/tw3-random-encounters-reworked.zip

cls

echo ""
echo "Installer for the mod Random Encounters Reworked."
echo ""
echo "This will work in major steps:"
echo " - First it will download the mods and its dependencies from GitHub."
echo " - It will remove dependencies you may not need based on your current mods."
echo " - It will list everything it plans to add to your game."
echo " - It will install the listed files."
echo " - It will open a link in your browser to guide you through the merging process and the first steps while in game."

pause
cls

# Before doing anything we check if the script file is placed in the right
# directory. It expects to be placed right in the witcher 3 root.
if (!(test-path dlc)) {
  write-host -ForegroundColor red "Please make sure the script is placed inside your The Witcher 3 install directly"
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



$extractingFolder = "./__install_rer"
$extractingFolderPatches = "./__install_rer_patches"

echo ""
echo "downloading Random Encounters Reworked"

echo "fetching latest release"

$latestAssetUrl = "https://github.com/Aelto/tw3-random-encounters-reworked/releases/latest/download/tw3-random-encounters-reworked.zip"
$latestAssetName = "tw3-random-encounters-reworked.zip"
Invoke-WebRequest -Uri $latestAssetUrl -OutFile $latestAssetName

Expand-Archive -Force -LiteralPath $latestAssetName -DestinationPath ./$extractingFolder
remove-item $latestAssetName -recurse -force

# TODO:
# If the user has EE, install the patches for the improved compatibility
# this is done after the RER download because it will overwrite files.
# if (test-path mods/modW3EE) {
#   echo ""
#   echo "downloading W3EE compatibility patches"

#   Invoke-WebRequest -Uri $assetEePatches.browser_download_url -OutFile $assetEePatches.name
#   Expand-Archive -Force -LiteralPath $assetEePatches.name -DestinationPath ./$extractingFolderPatches
#   remove-item $assetEePatches.name -recurse -force
# }

# TODO:
# If the user has FHUD, there is a patch for it to display custom 3D map markers.
# if (!(test-path mods/modW3EE) -and (test-path mods/modFriendlyHUD)) {
#   echo ""
#   echo "downloading FHUD compatibility patches"

#   Invoke-WebRequest -Uri $assetFhudPatches.browser_download_url -OutFile $assetFhudPatches.name
#   Expand-Archive -Force -LiteralPath $assetFhudPatches.name -DestinationPath ./$extractingFolderPatches
#   remove-item $assetFhudPatches.name -recurse -force
# }

# Print message notifying which mod will be installed.
cls
echo ""
echo "installing the following mods:"
$children = Get-ChildItem ./$extractingFolder/mods
foreach ($child in $children) {
  write-host " - $($child.name)"
}

echo ""
echo "installing the following dlcs:"
$children = Get-ChildItem ./$extractingFolder/dlc
foreach ($child in $children) {
  write-host " - $($child.name)"
}

echo ""
echo "installing the following menus:"
$children = Get-ChildItem ./$extractingFolder/bin/config/r4game/user_config_matrix/pc
foreach ($child in $children) {
  write-host " - $($child.name)"
}

# TODO:
# if (test-path $extractingFolderPatches) {
#   echo ""
#   echo "installing the following patches:"
#   $childrenPatches = Get-ChildItem ./$extractingFolderPatches

#   foreach ($child in $childrenPatches) {
#     write-host " - $($child.name)"
#   }
# }

echo ""
pause

# Finally start installing the mods.
$children = Get-ChildItem ./$extractingFolder
foreach ($child in $children) {
  $fullpath = "{0}/{1}" -f $extractingFolder, $child
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

Start-Process "https://aelto.github.io/tw3-random-encounters-reworked/rer-bible#success-install"