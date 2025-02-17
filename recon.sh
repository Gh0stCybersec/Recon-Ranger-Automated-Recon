#!/bin/bash
# Base Directory for root domains
baseDir="${1:-/home/gh0st/Documents/BugBounty}"


echo "______                         "
echo "| ___ \                      "
echo "| |_/ /___  ___ ___  _ __    "
echo "|    // _ \/ __/ _ \|  _ \  "
echo "| |\ \  __/ (_| (_) | | | | "
echo "\_| \_\___|\___\___/|_| |_| Ranger Automated Recon"
echo "Created by Daniel Jennings"
echo "Github: https://github.com/Gh0stCybersec"

if  [[ -d "$baseDir" ]]; then
    for dir in "$baseDir"/*/; do    
        if [[ -f "${dir}/roots.txt" ]]; then
            programName=$(basename "$dir")
            echo "$(date): Recon for $programName...." | notify

             # subdomain enumeration"
            subfinder -dL "${dir}/roots.txt" | dnsx | anew -q "${dir}/resolveddomains.txt" || {
                echo "$(date): Subdomain discovery failed for $programName"
                continue
            }

             # HTTP probing ensure to do sudo apt remove python3-httpx
              httpx -l "${dir}/resolveddomains.txt" -t 75 | anew "${dir}/webservers.txt" | notify -bulk || {
                echo "$(date): Http probing failed for $programName"
                continue
            } 
              # Port Scanning
              nmap -sS -sV -O -iL "${dir}/resolveddomains.txt" | anew -q "${dir}/openports.txt" | notify -bulk || {
                echo "$(date): Port scanning failed for $programName"
                continue
            } 
              # Vulnerability Scanning
              nuclei -l "${dir}/resolveddomains.txt" -severity critical,high,medium | anew -q "${dir}/nucleiresults.txt" | notify  || {
                echo "$(date): Nuclei scan failed for $programName"
                continue
            } 
        else
            echo  "$(data): No root domains found for $programName!"
        fi
    done
else
    echo "$(date): Directory '$baseDir' does not exist."
fi


#permutate the list of resolved domains using given list (permutations.txt)
        
        #altdns -i "${dir}/resolveddomains.txt" -o "${dir}/alt_output_dump" -w permutations.txt -r -s "${dir}/altresolveddomains.txt" | anew "${dir}/altresolveddomains.txt" 



##add run on katana? 
#add gungir run?







