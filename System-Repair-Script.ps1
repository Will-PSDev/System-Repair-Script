#Variable Declaration
$dismClean = 0; #tracks if a clean dism scan was returned 0 means no, 1 means yes
$sfcClean = 0; #tracks if a clean sfc scan was returned 0 means no, 1 means yes

#Functions
function Reboot-Check {  #Checks if a reboot is needed, then asks if the user wants to reboot after first determining that a reboot is needed. If a reboot is not needed this does nothing
    if ((Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending") -eq "True"){
        $reboot = Read-Host "A reboot is pending, reboot now? Y/n";
        if ($reboot -eq "Y"){
            Restart-Computer
        }
    }
}

#Begin Main Code
#Loop recursively runs through system repair until a clean scan is returned by both DISM and SFC
do {
    #DISM Section
    Write-Host "Begininng DISM Scan";
    $result = dism /online /cleanup-image /scanHealth;

    if ($result -match "No component store corruption detected") {
        Write-Host "DISM Complete! No corruption found";
        $dismClean = 1;
    }
    elseif ($result -match "repairable") {
        Write-Host "Corruption detected, running repair";
        DISM /online /cleanup-image /Restore Health;
        Write-Host "DISM Complete!";
        $dismClean = 0;
    }
    elseif ($result -match "not repairable") {
        Write-Host "DISM Complete! Corruption detected and not repairable"
        $dismClean = 0;
    }

    #SFC Section
    Write-Host "Begininng SFC Scan";
    sfc /verifyonly
    switch ($LASTEXITCODE) {
        0 { 
            Write-Host "SFC Complete! No corruption found"; 
            $sfcClean = 1;
    
          }
        1 { 
            Write-Host "Corruption found";
            sfc /scannow;
            Write-Host "SFC Complete!";
            $sfcClean = 0;
          }
        2 { 
            "Pending reboot";
          }
        default { Write-Host "SFC failed with code $LASTEXITCODE" }
    }

    Reboot-Check;
} while (($dismClean -eq 0) -or ($sfcClean -eq 0))

Write-Host "System Scan Completed";
