#!/bin/bash

dir=$1

# Function to display usage information
usage() {
    echo "Usage: $0 <directory_path>"
    exit 1
}
    
# Check if no arguments are passed
if [ $# -eq 0 ]; then
    usage
fi


# Step 1: Decompiling APKs in the main folder
for apkfile in "$dir"/*.apk; do
    if [ -f "$apkfile" ]; then
        filename=$(basename -- "$apkfile")
        foldername="${filename%.*}"
        apktool d "$apkfile"

        # Step 2: Running nuclei on decompiled folders
        nuclei -t mobileTemplates/ -o "$foldername"_nuclei < <(echo "$foldername")

        # Step 3: Running apkleaks on APK files
        python3 /home/cyrusop/tools/apkleaks/apkleaks.py -f "$apkfile" -o "${filename%.*}"_apkleaks
    fi
done
