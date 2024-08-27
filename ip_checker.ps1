
wsl.exe -e exit
Start-Sleep -Seconds 5
$ips = (wsl hostname -I).Trim().split()
$ip = $ips[0]
netsh interface portproxy delete v4tov4 listenaddress=0.0.0.0 listenport=11434
netsh interface portproxy delete v4tov4 listenaddress=0.0.0.0 listenport=22

netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=11434 connectaddress=$ip connectport=11434
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=22 connectaddress=$ip connectport=22


# to check port forwarding
# netsh interface portproxy show all
