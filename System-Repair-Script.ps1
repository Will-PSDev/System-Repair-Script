#DISM Section
Write-Host "Begininng DISM Scan";
$result = dism /online /cleanup-image /scanHealth;

if ($result -match "No component store corruption detected") {
    Write-Host "DISM Complete! No corruption found";
}
elseif ($result -match "repairable") {
    Write-Host "Corruption detected, running repair";
    DISM /online /cleanup-image /Restore Health;
    Write-Host "DISM Complete!";
}
elseif ($result -match "not repairable") {
    Write-Host "DISM Complete! Corruption detected and not repairable"
}
#SFC Section
Write-Host "Begininng SFC Scan";
sfc /verifyonly
switch ($LASTEXITCODE) {
    0 { "SFC Complete! No corruption found" }
    1 { 
        "Corruption found";
        sfc /scannow;
        Write-Host "SFC Complete!";
      }
    2 { "Pending reboot" }
    default { "SFC failed with code $LASTEXITCODE" }
}