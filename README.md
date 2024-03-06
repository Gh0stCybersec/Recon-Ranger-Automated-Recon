# Automated-Recon
```bash
                        

______                      ______                            
| ___ \                     | ___ \                           
| |_/ /___  ___ ___  _ __   | |_/ /__ _ _ __   __ _  ___ _ __ 
|    // _ \/ __/ _ \| '_ \  |    // _` | '_ \ / _` |/ _ \ '__|
| |\ \  __/ (_| (_) | | | | | |\ \ (_| | | | | (_| |  __/ |   
\_| \_\___|\___\___/|_| |_| \_| \_\__,_|_| |_|\__, |\___|_|   
                                               __/ |          
                                              |___/           

```
This script is an attempt at automating some of the first steps for bug bounty hunting.

To use this tool , create a directory for all your targets in the following format. The roots file will contain your chosen subdomains.
```bash

│   ├── Hackerone
│   │   ├── roots.txt 
│   ├── Bugcrowd
│   │   ├── roots.txt
│   ├── Intigriti
│   │   ├── roots.txt 
```
Recon script will create folders in the same location as roots with the output results. 
