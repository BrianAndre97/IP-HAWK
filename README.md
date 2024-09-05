# IP_HAWK
## What is IP_HAWK?
:) Consider buying me a coffee! 
https://buymeacoffee.com/brianandrec

IP_HAWK is a powerful OSINT investigation powershell script specifically created to identify web & ip targets (And a few extras). This tool is also designed to assist network admins in an IT environment.

## Overview
Upon load up, this powershell script tells you what your public IP address is, as well as the ip address of your router. You're then presented with a prompt asking you to select one of 9 programs.

 1.) General DNS/Domain Lookup.
 2.) Whois Lookup.
 3.) GeoIP, locate IP address.
 4.) View live connections.
 5.) Test website Connectivity
 6.) Scan all common TCP ports.
 7.) Scan specific TCP ports.
 8.) Benchmark DNS
 9.) View Subdomains

## Breakdown & How-to
All of these integrated programs call external APIs that take the information you entered, and spit out a clean print of your requested information. The objective was to take the most redundant and intricate parts of a network admin role and compile it into a clean command line interface that would be easy to read and use. The information it retrieves is much more detailed than most of the tools I personally came across during my time as a network admin, and the information itself is much more reliable than the other web sources I found.

1.) General DNS Domain lookup: Shows you the public A(Address Record), NS (NAME SERVER), CNAME(Canonical Name), MX(Mail Exchange), TXT and DMARC (DMARC record). It also scans for records used by the following programs & protocols, and if a record returns you can be sure they are using that software/ program (very useful for OSINT reconnaissance); FTP, PARALLELS (Used to run remote connection & Virtual Apps), REMOTE CONNECTION, SIP (voice calls transmitted over a SIP-based VoIP).

2.) Whois Lookup: Gives you a detailed who-is report of the IP Address you put in. This program gives you the subnet information, name of the authority the IP is registered to, range of IP addresses used by the subnet,and the city the IP address is assigned to.

3.) GeoIP, locate IP address: This search gives you the exact location of the ip address. This reports the status of the ip you searched, country, region, city, zip, latitude-longitude, timezone, and ISP of the ip address you sent in. And after using this tool for a while, the lan & lon coordinates are accurate within a city block.

4.) View live connections: This option gives you the print out of active ports on the machine that's running the script. Very useful to pinpoint any bad acting software or general inbound and outbound port information. This gives a print out of the exact IP address the port is connected to, the remote port number, and local port number.

5.) Test website connectivity: This option simply reports the status of a website and prints it out in the prompt. Very useful when you have a few targets to comb through.

6.) Scan all common TCP ports: This is a simple ip port scanner translated to powershell. After submitting your target ip address, the program will check the following ports and tell you if they are open or closed; 
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
7.) Scan specific TCP ports: This option is a port scanner but allows you to scan a specific port. **This type of search will show up on firewall logs.

8.) Benchmark DNS: This tool is especially useful in a network administrator environment. This tool can help greatly when troubleshooting DNS lag, or diagnosing network delay in an environment. The tool will print out the exact millisecond delay to the dns, which is an average of 5 dns pings.

9.) View Subdomains: This tool will enumerate all the subdomains on a target, but only the subdomains that have a registered SSL cert. When using this tool, it's important not to enter "www." before your search because you'd be limiting the search to only find that subdomain.

Hope you have fun using it! It saved me lots of time and scratched that OSINT itch I'd get from time to time ;)
