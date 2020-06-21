:: Вытащить значение ключа реестра
For /F "Tokens=2*" %I In ('Reg Query "HKEY_LOCAL_MACHINE\SOFTWARE\7-Zip" /V Path') Do Set InstallPath=%J

