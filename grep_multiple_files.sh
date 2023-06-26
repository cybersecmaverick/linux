#!/bin/bash

# Date: 26-06-2023
# Author: CyberSecMaverick
#
# Description:
# =============
# This script searches multiple files for a regex pattern that matches an IP address.
# If you want to repurpose and re-use the script, change the Extended Grep pattern variable in PATTERN.
# For now, it is set to match any file that contains an IP address.
# The list of files is in files.txt and contains the full path and filename.
#
# Examples are:
# $ cat files.txt
# /etc/file1
# /mnt/c/file2
# /etc/ssh/file3
# /var/log/file4
# /home/user/file5

PATTERN="([0-9]{1,3}\.){3}[0-9]{1,3}"
FILE="files.txt"

while IFS= read -r filepath; do
    echo "Searching in file: $filepath"
    grep -Eo "$PATTERN" "$filepath"
done < "$FILE"


# Additional notes:
# ==================
#
# "([0-9]{1,3}\.){3}[0-9]{1,3}"  is the regex pattern that matches the format of an IP anywhere in the file.
# ([0-9]{1,3}\.){3} matches a sequence of three groups of one to three digits followed by a dot (e.g., 192.168.0.).
# [0-9]{1,3} matches a group of one to three digits (e.g., 255).
# Overall, the pattern matches an IP address in the format of XXX.XXX.XXX.XXX, where each XXX is a number ranging from 0 to 255.
# If the IP needds to be on its down with spaces separating it from other text use "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"
# \b represents a word boundary, which ensures that the IP address is matched as a separate word and not as part of a larger string. This helps avoid partial matches.
