#!/bin/bash
baseDir="/change/to/target/directory"

if [[ -d "$baseDir" ]]; then
    for dir in "$baseDir"/*/; do
        if [[ -f "${dir}/roots.txt" ]]; then
            programName=$(basename "$dir")
            echo "Recon for $programName:"
            subfinder -dL "${dir}/roots.txt" | dnsx | anew "${dir}/resolveddomains.txt"
            httpx -l "${dir}/resolveddomains.txt" -t 75 | anew "${dir}/webservers.txt" #| notify  -bulk
            smap -iL "${dir}/resolveddomains.txt" | anew "${dir}/openports.txt"
            nuclei -l "${dir}/resolveddomains.txt" -rl 5 -c 5 -o "${dir}/nuclei_results.txt"
        else
            programName=$(basename "$dir")
            echo "No root domains found for $programName!"
        fi
    done
else
    echo "Directory '$baseDir' does not exist."
fi
