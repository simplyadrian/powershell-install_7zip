# Powershell 2.0


# Stop and fail script when a command fails.
$errorActionPreference = "Stop"

# load library functions
$rsLibDstDirPath = "$env:rs_sandbox_home\RightScript\lib"
. "$rsLibDstDirPath\tools\PsOutput.ps1"
. "$rsLibDstDirPath\tools\ResolveError.ps1"
. "$rsLibDstDirPath\win\Version.ps1"

try
{
    # detects if server OS is 64Bit or 32Bit 
    # Details http://msdn.microsoft.com/en-us/library/system.intptr.size.aspx
    if (Is32bit)
    {                        
        Write-Host "32 bit operating system"   
        $7zip_path = join-path $env:programfiles "7-Zip"
    } 
    else
    {                        
        Write-Host "64 bit operating system"     
        $7zip_path = join-path ${env:programfiles(x86)} "7-Zip"
    }

    if (test-path $7zip_path)
    {
        Write-Output "7-Zip already installed. Skipping installation."
        exit 0
    }

    Write-Host "Installing 7-Zip to $7zip_path"

    $7zip_binary = "7z465.exe"
    cd "$env:RS_ATTACH_DIR"
    mv 7z465 7z465.exe
    cmd /c $7zip_binary /S

    #Permanently update windows Path
    if (Test-Path $7zip_path) {
        [environment]::SetEnvironmentvariable("PATH", $env:PATH+";"+$7zip_path, "Machine")
    } 
    Else 
    {
        throw "Failed to install 7-Zip. Aborting."
    }

}
catch
{
    ResolveError
    exit 1
}
