#General ART for the script


function TCP {

    $targetip = Read-Host "Target IP Address/ Domain"
    $TCPPORT = @(443,22,80,1723,53,5060,8080,21,25,3389,8081,110,23,445,143,578,111,389)

    Write-Host "Scanning Target IP Address $targetip"
    Write-Host "CAUTION, your firewall will show up on thier logs."
    Write-Host "
    Scanning Common TCP Ports:
    443:   HTTPS
    22:    SSH
    80:    HTTP
    1723:  PPTP VPN (Point-to-Point Tunneling Protocol Virtual Private Networking)
    53:    DNS
    5060:  SIP VoIP
    8080:  HTTP
    21:    FTP
    25:    SMTP
    3389:  RDP
    8081:  HTTP
    110:   POP3
    23:    Telnet
    445:   Microsoft-DS (Used in NetBIOS)
    143:   IMAP
    578:   SMTP (Outgoing)
    111:   SunRPC (Used with Unix Systems)
    389:   LDAP
    53:    DNS
    "
    foreach ($TCPPORTS in $TCPPORT){
        Test-NetConnection $targetip -Port $TCPPORTs | Select-object -Property RemoteAddress, RemotePort,TCPTestSucceeded | select-string "True"
    }
}

function MANUAL {
    $targetmanip = Read-Host "Target IP Address/ Domain"
    $TGTPORT = Read-Host "Enter target Port #"
    Write-Host "Scanning Port $TGTPORT on IP Address $targetmanip"
    Write-Host "----------------------WARNING----------------------"
    Write-Host "CAUTION, your firewall will show up on thier logs."
    Write-Host "----------------------RUNNING----------------------"
    Test-NetConnection $targetmanip -Port $TGTPORT | Select-object -Property RemoteAddress, RemotePort,TCPTestSucceeded | select-string "True"
}

function webtester {
    $site = Read-Host "Target Website"

    $execute = Invoke-WebRequest -uri $site


    $status = $execute.StatusCode
    Write-Host "Status Code:"$execute.StatusCode
    
    Write-Host "Status Description:"$execute.StatusDescription


}


function domain {
Write-Host -ForegroundColor blue "

███████████████████████████████████████████████████████████████████████████
█▄─▄▄▀█─▄▄─█▄─▀█▀─▄██▀▄─██▄─▄█▄─▀█▄─▄███▄─▄███─▄▄─█─▄▄─█▄─█─▄█▄─██─▄█▄─▄▄─█
██─██─█─██─██─█▄█─███─▀─███─███─█▄▀─█████─██▀█─██─█─██─██─▄▀███─██─███─▄▄▄█
▀▄▄▄▄▀▀▄▄▄▄▀▄▄▄▀▄▄▄▀▄▄▀▄▄▀▄▄▄▀▄▄▄▀▀▄▄▀▀▀▄▄▄▄▄▀▄▄▄▄▀▄▄▄▄▀▄▄▀▄▄▀▀▄▄▄▄▀▀▄▄▄▀▀▀
"
    $input = Read-Host "Target Domain/Host"

    $A = Resolve-DnsName -Name $input -server 8.8.8.8 -type A 
        $Alog = $A | format-table | out-string

    $NS = Resolve-DnsName -Name $input -server 8.8.8.8 -type NS
        $NSlog = $NS | format-table | out-string

    $CNAME = Resolve-DnsName -Name $input -server 8.8.8.8 -type CNAME
        $CNAMElog = $CNAME | format-table | out-string

    $MX = Resolve-DnsName -Name $input -server 8.8.8.8 -type MX
        $MXlog = $MX | format-table | out-string

    $TXT = Resolve-DnsName -Name $input -server 8.8.8.8 -type TXT
        $TXTlog = $TXT | format-table | out-string

    $DMARC = (nslookup -q=txt _dmarc.$input | Select-String "DMARC1" ) -replace "`t", ""
    $ftp = (nslookup ftp.$input)
    $parallels = (nslookup t parallels.$input)
    $remote = (nslookup remote.$input)
    $sip = (nslookup -a=txt sip.$input)



    Write-Host -Separator "`n" -BackgroundColor DarkRed "A Record /IPv4 Address--:" ($A).IPAddress
    Write-Host -Separator "`n" -BackgroundColor Blue "NS Record---------------:" ($NS ).NameHost
    Write-Host -Separator "`n" -BackgroundColor DarkGray "CNAME Record------------:" ($CNAME).PrimaryServer
    Write-Host -Separator "`n" -BackgroundColor Black "MX Record---------------:" ($MX).NameExchange
    Write-Host -Separator "`n" -BackgroundColor DarkGreen "TXT Record--------------:" ($TXT).Strings
    Write-Host -Separator "`n" -BackgroundColor darkblue "DMARC Record--------------:" ($DMARC)
    Write-Host -Separator "`n" -BackgroundColor black "FTP Record--------------:" ($ftp)
    Write-Host -Separator "`n" -BackgroundColor darkgray "Parallels Record--------------:" ($parallels)
    Write-Host -Separator "`n" -BackgroundColor black "Remote Record--------------:" ($remote)
    Write-Host -Separator "`n" -BackgroundColor darkgray "SIP Record--------------:" ($sip)
}

function whois {
Write-Host -ForegroundColor black "
█░█░█ █░█ █▀█ █ █▀
▀▄▀▄▀ █▀█ █▄█ █ ▄█
"
$targetip = Read-Host "Target IPAddress"
if ($targetip -clike '*.*.*.*') {
    $whoisip = $targetip
    $baseURL = 'http://whois.arin.net/rest'
    
    #default is XML anyway
    
    $header = @{"Accept" = "application/xml"}
    
    $url = "$baseUrl/ip/$whoisip"
    $r = Invoke-Restmethod $url -Headers $header -ErrorAction stop

    $listofinfo = @{
    IP                     = $whoisip
    Name                   = $r.net.name
    RegisteredOrganization = $r.net.orgRef.name
    City                   = (Invoke-RestMethod $r.net.orgRef.'#text').org.city
    StartAddress           = $r.net.startAddress
    EndAddress             = $r.net.endAddress
    NetBlocks              = $r.net.netBlocks.netBlock | foreach-object {"$($_.startaddress)/$($_.cidrLength)"}
    Updated                = $r.net.updateDate -as [datetime]
    }
    
    $whoisip = $listofinfo | format-table -AutoSize | Out-String | Write-Host -BackgroundColor black -ForegroundColor white
    } else {
    $whoisip = (Resolve-DnsName $targetip -Type A).IPAddress
    
    $baseURL = 'http://whois.arin.net/rest'
    
    #default is XML anyway
    
    $header = @{"Accept" = "application/xml"}
    
    $url = "$baseUrl/ip/$whoisip"
    $r = Invoke-Restmethod $url -Headers $header -ErrorAction stop

    $listofinfo = @{
    IP                     = $whoisip
    Name                   = $r.net.name
    RegisteredOrganization = $r.net.orgRef.name
    City                   = (Invoke-RestMethod $r.net.orgRef.'#text').org.city
    StartAddress           = $r.net.startAddress
    EndAddress             = $r.net.endAddress
    NetBlocks              = $r.net.netBlocks.netBlock | foreach-object {"$($_.startaddress)/$($_.cidrLength)"}
    Updated                = $r.net.updateDate -as [datetime]
    }
    
    $whoisip = $listofinfo | format-table -AutoSize | Out-String  | Write-Host -BackgroundColor black -ForegroundColor white
  }
}

function geoip {
Write-Host -ForegroundColor Green "

▒█▀▀█ ▒█▀▀▀ ▒█▀▀▀█ ░░ ▀█▀ ▒█▀▀█ 
▒█░▄▄ ▒█▀▀▀ ▒█░░▒█ ▀▀ ▒█░ ▒█▄▄█ 
▒█▄▄█ ▒█▄▄▄ ▒█▄▄▄█ ░░ ▄█▄ ▒█░░░
"
$ipaddress = Read-Host "Target IPAddress"
    
    $baseURL = 'http://ip-api.com'
    
    #default is XML anyway
    
    $header = @{"Accept" = "application/xml"}
    
    $url = "$baseUrl/xml/$ipaddress"
    
    $r = Invoke-WebRequest $url
    $Status = [xml]$r | Select-XML -XPath "//status" |foreach {$_.node.InnerXML}
    Write-Host "Status:" $Status
        $statuslog = $Status | out-string

    $Country = [xml]$r | Select-XML -XPath "//country" |foreach {$_.node.InnerXML}
    Write-Host "Country:" $Country
        $countrylog = $Country | out-string

    $countryCode = [xml]$r | Select-XML -XPath "//countryCode" |foreach {$_.node.InnerXML}
    Write-Host "CountryCode:" $countryCode
        $countryCodelog = $countryCode | out-string

    $region = [xml]$r | Select-XML -XPath "//region" |foreach {$_.node.InnerXML}
    Write-Host "Region:" $region
        $regionlog = $region | out-string

    $regionName = [xml]$r | Select-XML -XPath "//regionName" |foreach {$_.node.InnerXML}
    Write-Host "RegionName:" $regionName
        $regionNamelog = $regionName | out-string

    $city = [xml]$r | Select-XML -XPath "//city" |foreach {$_.node.InnerXML}
    Write-Host "City:" $city
        $citylog = $city | out-string

    $zip = [xml]$r | Select-XML -XPath "//zip" |foreach {$_.node.InnerXML}
    Write-Host "Zip:" $city
        $ziplog = $zip | out-string
        
    $lat = [xml]$r | Select-XML -XPath "//lat" |foreach {$_.node.InnerXML}
    Write-Host "Lat:" $lat
        $latlog = $lat | out-string

    $lon = [xml]$r | Select-XML -XPath "//lon" |foreach {$_.node.InnerXML}
    Write-Host "Lon:" $lon
        $lonlog = $lon | out-string

    $timezone = [xml]$r | Select-XML -XPath "//timezone" |foreach {$_.node.InnerXML}
    Write-Host "TimeZone:" $timezone
        $timezonelog = $timezone | out-string

    $isp = [xml]$r | Select-XML -XPath "//isp" |foreach {$_.node.InnerXML}
    Write-Host "isp:" $isp
        $isplog = $isp | out-string

    $as = [xml]$r | Select-XML -XPath "//as" |foreach {$_.node.InnerXML}
    Write-Host "as:" $as
        $aslog = $as | out-string


}

function liveconnection {
Write-Host -ForegroundColor RED "

█░░ █ █░█ █▀▀   █▀▀ █▀█ █▄░█ █▄░█ █▀▀ █▀▀ ▀█▀ █ █▀█ █▄░█
█▄▄ █ ▀▄▀ ██▄   █▄▄ █▄█ █░▀█ █░▀█ ██▄ █▄▄ ░█░ █ █▄█ █░▀█
"
$owning = @(get-nettcpconnection -State Established)

foreach ($owning in $owning){
    $RemotePort = $IP = $owning.RemotePort | out-string
        $RemotePortlog = $RemotePort | Out-String

    $LocalPort = $IP = $owning.LocalPort | out-string
        $LocalPortlog = $LocalPort | out-string

    $IP = $owning.RemoteAddress | out-string
        $IPlog = $IP | out-string
       
    $program = $owning.OwningProcess | out-string
        $programlog = $program | out-string


    $IPtoName = (Get-Process -id $program | select-object -Property ProcessName).ProcessName | Format-List | out-string
        $IPtoNamelog = $IPtoName | out-string


    Write-Host "Process =" $IPtoName  "External IP =" $IP "Remote Port =" $RemotePort "Local Port =" $LocalPort
   

    }
}

function BENCHMARK {
Write-Host "

██████╗░███╗░░██╗░██████╗  ██████╗░███████╗███╗░░██╗░█████╗░██╗░░██╗███╗░░░███╗░█████╗░██████╗░██╗░░██╗
██╔══██╗████╗░██║██╔════╝  ██╔══██╗██╔════╝████╗░██║██╔══██╗██║░░██║████╗░████║██╔══██╗██╔══██╗██║░██╔╝
██║░░██║██╔██╗██║╚█████╗░  ██████╦╝█████╗░░██╔██╗██║██║░░╚═╝███████║██╔████╔██║███████║██████╔╝█████═╝░
██║░░██║██║╚████║░╚═══██╗  ██╔══██╗██╔══╝░░██║╚████║██║░░██╗██╔══██║██║╚██╔╝██║██╔══██║██╔══██╗██╔═██╗░
██████╔╝██║░╚███║██████╔╝  ██████╦╝███████╗██║░╚███║╚█████╔╝██║░░██║██║░╚═╝░██║██║░░██║██║░░██║██║░╚██╗
╚═════╝░╚═╝░░╚══╝╚═════╝░  ╚═════╝░╚══════╝╚═╝░░╚══╝░╚════╝░╚═╝░░╚═╝╚═╝░░░░░╚═╝╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚═╝
"

Get-NetIPConfiguration -InterfaceAlias "Ethernet"
$GetIP = Read-Host "IP/Domain Address to Benchmark"
$count = 1..5 | Measure-Command {nslookup $GetIP}
$measure = ($count.Milliseconds / 5)
        
    If ($measure.Milliseconds  -lt 200){
        Write-Host -BackgroundColor green -ForegroundColor Black "GOOD: Avg Delay is less than 200 milliseconds! Millisecond Delay:" $measure
        }
        elseif (($measure.Milliseconds -gt 200) -and ($measure.Milliseconds -lt 300)) {
        Write-Host -BackgroundColor Yellow -ForegroundColor Black "AVG: Avg Delay is over 200 ms, but under 300 ms, Millisecond Delay:" $measure
        }
        elseif ($measure.Milliseconds  -gt 300){
        Write-Host -BackgroundColor Red -ForegroundColor Black "FAIL: Clear Cache or invesitgate DNS issues, Millisecond Delay:" $measure
        }
}

function SUBDOMAIN {
Write-Host -BackgroundColor White -ForegroundColor black "Enumerating DNS Subdomains:"
Write-Host -BackgroundColor black -ForegroundColor red "Will only find subdomains with SSL cert registered"
$targetip = Read-Host "Enter Domain Name"


if ($targetip -clike '*.*.*.*') {
    Write-Host "Entry is ip address, please enter Domain name"
    $dnsip = Read-Host
    $dnssubdomain = Invoke-WebRequest -uri "https://api.hackertarget.com/hostsearch/?q=$dnsip" | select Content | format-list
    $dnssubdomain | out-string | Write-Host -BackgroundColor black -ForegroundColor white
    } else {
    $dnsip = $targetip
    $dnssubdomain = Invoke-WebRequest -uri "https://api.hackertarget.com/hostsearch/?q=$dnsip" | select Content | format-list *
    $dnssubdomain | out-string | Write-Host -BackgroundColor black -ForegroundColor white
    }
}

function RUN {
#Gathering all the local infomration
$yourip = $(Resolve-DnsName -Name myip.opendns.com -Server 208.67.222.220).IPAddress
$localrouterip = ((Get-NetIPConfiguration).IPv4DefaultGateway).NextHop
$localdnsserver = ((Get-NetIPConfiguration).DNSServer).ServerAddresses
Write-Host -ForegroundColor white -backgroundcolor black "

_______________     ______  ___________       _______ _________
____  _/__  __ \    ___  / / /__    |_ |     / /__  //_/---------
 __  / __  /_/ /    __  /_/ /__  /| |_ | /| / /__  ,<--------------
__/ /  _  ____/     _  __  / _  ___ |_ |/ |/ / _  /| |--------------
/___/  /_/          /_/ /_/  /_/  |_|___/|__/  /_/ |_|----------------
--------------------------------------------------------Prod.-of-BJY.--
                   |_
                  /   |__________
                 /     /
                /      >-----------
               (      >---------------
              /      /
             /     /
            /      /
         __/      \_____________
        /'             |
         /     /-\     /
        /      /  \--/
       /     /
      /      /
     (      >------------------------
    /      >---------------------
   /     _|
  /  __/
 /_/______________
:) Consider buying me a coffee! 
https://buymeacoffee.com/brianandrec

 "
write-Host -foregroundcolor white -backgroundcolor black "
WAN Router IP Address---- $yourip
Local Router IP Address-- $localrouterip"

$read = Read-Host  "

 -----<> Select From the Following <>----
 1.) Type '1' General DNS/Domain Lookup.
 2.) Type '2' Whois Lookup.
 3.) Type '3' GeoIP, locate IP address.
 4.) Type '4' View live connections. 
 5.) Type '5' Test website Connectivity
 6.) Type '6' Scan all common TCP ports.
 7.) Type '7' Scan specific TCP ports.
 8.) Type '8' Benchmark DNS
 9.) Type '9' View Subdomains
 
 ---<> What would you like to run? <>----
 "

    if ( $read  -eq "1"){
    domain
    RUN


    } elseif ( $read  -eq "2") {
        whois
        RUN
    } elseif ( $read  -eq "3") {
        geoip
        RUN
    } elseif ( $read -eq "4") {
        liveconnection
        RUN
    } elseif ($read -eq "5") {
        webtester
        RUN
    } elseif ($read -eq "6") {
        TCP
        RUN
    } elseif ($read -eq "7") {
        MANUAL
        RUN
    } elseif ($read -eq "8") {
        BENCHMARK
        RUN
    } elseif ($read -eq "9") {
        SUBDOMAIN
        RUN
    } else { RUN }


}

RUN