#!/bin/bash
baseDir="/change/to/target/directory"


echo "______                         "
echo "| ___ \                      "
echo "| |_/ /___  ___ ___  _ __    "
echo "|    // _ \/ __/ _ \|  _ \  "
echo "| |\ \  __/ (_| (_) | | | | "
echo "\_| \_\___|\___\___/|_| |_| Ranger Automated Recon"
echo "Created by Gh0st"
echo "Github: https://github.com/Gh0stCybersec"

# Check if the base directory exists
if [[ ! -d "$baseDir" ]]; then
    echo "Directory '$baseDir' does not exist."
    exit 1
fi

# Check if required commands are available
required_commands=("subfinder" "dnsx" "httpx" "smap" "nuclei" "anew" "altdns")
missing_commands=()
for cmd in "${required_commands[@]}"; do
    if ! command -v "$cmd" &>/dev/null; then
        missing_commands+=("$cmd")
    fi
done

if [[ ${#missing_commands[@]} -ne 0 ]]; then
    echo "Error: The following required tools are not installed or not in your PATH:"
    for missing_cmd in "${missing_commands[@]}"; do
        echo "  - $missing_cmd"
    done
    exit 1
fi

# Iterate through subdirectories in the base directory
for dir in "$baseDir"/*/; do
    if [[ -f "${dir}/roots.txt" ]]; then
        programName=$(basename "$dir")
        echo "Recon for $programName:"
        # Perform reconnaissance and vulnerability scanning
        subfinder -dL "${dir}/roots.txt" | dnsx | anew "${dir}/resolveddomains.txt" || { echo "Error in subfinder or dnsx command"; exit 1; }
        httpx -l "${dir}/resolveddomains.txt" -t 75 | anew "${dir}/webservers.txt" || { echo "Error in httpx command"; exit 1; }
        smap -iL "${dir}/resolveddomains.txt" | anew "${dir}/openports.txt" || { echo "Error in smap command"; exit 1; }
        #permutate the list of resolved domains using given list (permutations.txt)
        altdns -i "${dir}/resolveddomains.txt" -o "${dir}/alt_output_dump" -w permutations.txt -r -s "${dir}/altresolveddomains.txt" | anew "${dir}/altresolveddomains.txt" || { echo "Error in altdns command"; exit 1; }
        #perform run of nuclei and all default templates
        nuclei -l "${dir}/resolveddomains.txt" -rl 5 -c 5 -o "${dir}/nuclei_results.txt" || { echo "Error in nuclei command"; exit 1; }
    else
        programName=$(basename "$dir")
        echo "No root domains found for $programName!"
    fi
done


# to do 
# add amass?
# add nuclei templates 
# directory brute force - for loop , loop each line in domains.txt and send to gobuster

   

   
