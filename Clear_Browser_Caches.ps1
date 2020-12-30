<#
Write-Host -ForegroundColor yellow "#######################################################"
""
Write-Host -ForegroundColor Green "Powershell commands to delete cache & cookies in Firefox, Chrome & IE browsers"
Write-Host -ForegroundColor Green "By Lee Bhogal, Paradise Computing Ltd - June 2014"
Write-Host -ForegroundColor Green "VERSION: 2"
""
Write-Host -ForegroundColor Green "By Jon Jaques, CoastalData / CNR - December 2020"
Write-Host -ForegroundColor Green "VERSION: 3"
""
Write-Host -ForegroundColor yellow "#######################################################"
""
Write-Host -ForegroundColor Green "CHANGE_LOG:
v3.0:
 - Wrap comments in comment tags so that output is not chatty.
 - Centralize path to CSV using a single variable
 - Move location of CSV from User folder to universally accessible temporary file location
 - Removed extra output "Clearing Mozilla caches"
 - Fixed IE status line from "Clearing Google caches" to "Clearing IE caches"
 - Move System Global Temp and Recycle bins out of Loop, no need to run these for each user.
 - Changed final error message from "Session Cancelled" to "Output CSV file could not be written" to more correctly reflect the error.
 - Disabled blatant delete of cookies. Must be option driven.
 - Reformatted document using VS Code.

TODO: Add Parameters:
 - Allow for manual direction of the CSV file, fall-back to Temp Location
 - Allow for override of Cookies... Can't assume it's OK to delete everybody's cookies.
 - Add locations for other browsers, like Opera


v2.4: - Resolved *.default issue, issue was with the file path name not with *.default, but issue resolved
v2.3: - Added Cache2 to Mozilla directories but found that *.default is not working
v2.2: - Added Cyan colour to verbose output
v2.1: - Added the location 'C:\Windows\Temp\*' and 'C:\`$recycle.bin\'
v2:   - Changed the retrieval of user list to dir the c:\users folder and export to csv
v1:   - Compiled script"
""
Write-Host -ForegroundColor yellow "#######################################################"
""
#########################
#>
# Scheduled Fix for Chrome for Brodie TV Mini PCs
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Set-ExecutionPolicy Bypass -Scope Process -Force

"-------------------"
Write-Host -ForegroundColor Green "SECTION 1: Getting the list of users"
"-------------------"
# Path to Data file containing list of users:
$listPath = [System.IO.Path]::GetTempFileName() # New-TemporaryFile # "C:\users\$env:USERNAME\Documents\users.csv" #################
# Write Information to the screen
Write-Host -ForegroundColor yellow "Exporting the list of users to $listPath"
# List the users in c:\users and export to the local profile for calling later
dir C:\Users | select Name | Export-Csv -Path $listPath -NoTypeInformation
$list = Test-Path $listPath
""
#########################
"-------------------"
Write-Host -ForegroundColor Green "SECTION 2: Beginning Script..."
"-------------------"
if ($list) {
        "-------------------"
        #Clear Mozilla Firefox Cache
        Write-Host -ForegroundColor Green "SECTION 3: Clearing Mozilla Firefox Caches"
        "-------------------"
        Write-Host -ForegroundColor yellow "Clearing Mozilla caches"
        Write-Host -ForegroundColor cyan
        Import-CSV -Path $listPath -Header Name | foreach {
                Remove-Item -path C:\Users\$($_.Name)\AppData\Local\Mozilla\Firefox\Profiles\*.default\cache\* -Recurse -Force -EA SilentlyContinue -Verbose
                Remove-Item -path C:\Users\$($_.Name)\AppData\Local\Mozilla\Firefox\Profiles\*.default\cache\*.* -Recurse -Force -EA SilentlyContinue -Verbose
                Remove-Item -path C:\Users\$($_.Name)\AppData\Local\Mozilla\Firefox\Profiles\*.default\cache2\entries\*.* -Recurse -Force -EA SilentlyContinue -Verbose
                Remove-Item -path C:\Users\$($_.Name)\AppData\Local\Mozilla\Firefox\Profiles\*.default\thumbnails\* -Recurse -Force -EA SilentlyContinue -Verbose
                # Remove-Item -path C:\Users\$($_.Name)\AppData\Local\Mozilla\Firefox\Profiles\*.default\cookies.sqlite -Recurse -Force -EA SilentlyContinue -Verbose
                Remove-Item -path C:\Users\$($_.Name)\AppData\Local\Mozilla\Firefox\Profiles\*.default\webappsstore.sqlite -Recurse -Force -EA SilentlyContinue -Verbose
                Remove-Item -path C:\Users\$($_.Name)\AppData\Local\Mozilla\Firefox\Profiles\*.default\chromeappsstore.sqlite -Recurse -Force -EA SilentlyContinue -Verbose
        }
        Write-Host -ForegroundColor yellow "Done..."
        ""
        "-------------------"
        # Clear Google Chrome 
        Write-Host -ForegroundColor Green "SECTION 4: Clearing Google Chrome Caches"
        "-------------------"
        Write-Host -ForegroundColor yellow "Clearing Google caches"
        Write-Host -ForegroundColor cyan
        Import-CSV -Path $listPath -Header Name | foreach {
                Remove-Item -path "C:\Users\$($_.Name)\AppData\Local\Google\Chrome\User Data\Default\Cache\*" -Recurse -Force -EA SilentlyContinue -Verbose
                Remove-Item -path "C:\Users\$($_.Name)\AppData\Local\Google\Chrome\User Data\Default\Cache2\entries\*" -Recurse -Force -EA SilentlyContinue -Verbose
                # Remove-Item -path "C:\Users\$($_.Name)\AppData\Local\Google\Chrome\User Data\Default\Cookies" -Recurse -Force -EA SilentlyContinue -Verbose
                Remove-Item -path "C:\Users\$($_.Name)\AppData\Local\Google\Chrome\User Data\Default\Media Cache" -Recurse -Force -EA SilentlyContinue -Verbose
                # Remove-Item -path "C:\Users\$($_.Name)\AppData\Local\Google\Chrome\User Data\Default\Cookies-Journal" -Recurse -Force -EA SilentlyContinue -Verbose
                # Comment out the following line to remove the Chrome Write Font Cache too.
                # Remove-Item -path "C:\Users\$($_.Name)\AppData\Local\Google\Chrome\User Data\Default\ChromeDWriteFontCache" -Recurse -Force -EA SilentlyContinue -Verbose
        }

        Write-Host -ForegroundColor yellow "Done..."
        ""
        "-------------------"
        # Clear Internet Explorer
        Write-Host -ForegroundColor Green "SECTION 5: Clearing Internet Explorer Caches"
        "-------------------"
        Write-Host -ForegroundColor yellow "Clearing IE caches"
        Write-Host -ForegroundColor cyan
        Import-CSV -Path $listPath | foreach {
                Remove-Item -path "C:\Users\$($_.Name)\AppData\Local\Microsoft\Windows\Temporary Internet Files\*" -Recurse -Force -EA SilentlyContinue -Verbose
                Remove-Item -path "C:\Users\$($_.Name)\AppData\Local\Microsoft\Windows\WER\*" -Recurse -Force -EA SilentlyContinue -Verbose
                Remove-Item -path "C:\Users\$($_.Name)\AppData\Local\Temp\*" -Recurse -Force -EA SilentlyContinue -Verbose
        }

        Remove-Item -path "C:\Windows\Temp\*" -Recurse -Force -EA SilentlyContinue -Verbose
        Remove-Item -path "C:\`$recycle.bin\" -Recurse -Force -EA SilentlyContinue -Verbose

        Write-Host -ForegroundColor yellow "Done..."
        ""
        Write-Host -ForegroundColor Green "All Tasks Done!"
}
else {
        Write-Host -ForegroundColor Yellow "Output CSV file could not be written"	
        Exit
}
