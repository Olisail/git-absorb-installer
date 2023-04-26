$githubRepository = "tummychow/git-absorb"
$latestVersion = "$(curl -s "https://github.com/$githubRepository/releases/latest" -w "%{redirect_url}")" -replace '.*/',''
$downloadReferenceName = "git-absorb-$latestVersion-x86_64-pc-windows-gnu"
$downloadUri = "https://github.com/$githubRepository/releases/download/$latestVersion/$downloadReferenceName.tar.gz"

$resourcesPath = "c:/tools/git-absorb/$latestVersion"
$downloadPath = "$resourcesPath/$latestVersion"

Write-Host "Setting up $resourcesPath..."
if (Test-Path $resourcesPath) {
    Remove-Item -Recurse -Force $resourcesPath -Verbose
}

New-Item "$downloadPath" -ItemType Directory -Verbose

$outputPath = "$downloadPath/latest-git-absorb.tar.gz"
Write-Host "Downloading $downloadUri..."
Invoke-WebRequest -Uri $downloadUri -OutFile $outputPath -Verbose

Write-Host "Extracting files..."
tar -xvzf $outputPath -C $resourcesPath

# Move content to be able to find the app by its friendly name
Move-Item -Path "$resourcesPath/$downloadReferenceName/*" -Destination "$resourcesPath" -Verbose
Remove-Item -Recurse -Force "$resourcesPath/$downloadReferenceName/" -Verbose
Remove-Item -Recurse -Force "$downloadPath/" -Verbose

Write-Host "Setting up git alias..."
git config --global alias.absorb "!$resourcesPath/git-absorb.exe"

if ($?) {
    Write-Host "All done!`nEnded without error."
    exit 0
} 

exit 1
