# quick11
Script to setup windows 11 quickly

```powershell
powershell -Command "Invoke-WebRequest 'https://raw.githubusercontent.com/howzitcal/quick11/refs/heads/main/run.bat' -OutFile '$env:TEMP\temp_script.bat'; Start-Process '$env:TEMP\temp_script.bat'"
```