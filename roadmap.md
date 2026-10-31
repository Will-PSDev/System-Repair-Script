## Project Roadmap

## Implemented Before Roadmap was created
- [X] Repair-Volume
- [X] SFC and DISM Loops recursively
- [X] Script prompts for a reboot if it detects one is needed
- [X] Transcript of terminal data
- [X] Optimize-volume
- [X] Cleanup component store 

## Short-Term
- [X] State Tracking (Fully Implimented on 10/31/26)
- [ ] Improvements to how data is dumped to the terminal and log (Partially Implimented)
- [ ] Conditions to catch if the filesystem and image scan is looping indefinitely
- [ ] File to Persist Script State through reboot

## Mid-Term
- [ ] Checking for updates (This will likely require the end user to install an extra powershell module
- [ ] Logic to restore script state based on json file
- [ ] logic to automatically retrigger script after reboot
- [ ] Progress Bar

## Long-Term
- [ ] script automatically resumes after reboot
