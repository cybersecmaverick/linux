#!/bin/bash

################################################################################
# Author: CyberSecMaverick
# Date: 13-07-2023
#
# Description: Test SSH connection with a key file for a list of IP addresses.
# Usage: ./ssh-keyfile-cred-test.sh
#
# Required Files:
#   - Input IP Addresses File: input.txt
#     Format: Each line contains a single IP address
#
#   - SSH Key File: filename.pem
#     Update the 'keyfile' variable in the script to specify the correct key file name
#
# Output:
#   - Results File: output.txt
#     Format: Each line contains the IP address and the test result
#     Example:
#     10.0.1.1: Success
#     10.0.1.6: Password prompt
#     10.0.1.3: Failure
################################################################################

# Configuration Variables
username="user"  			# CHANGE THIS
keyfile="filename.pem"  	# CHANGE THIS
input_ips="input.txt" 		# Make sure this matches your IP address file
results="output.txt"  		# Your desired results file name		

# Check if the input file exists
if [[ ! -f "$input_ips" ]]; then
  echo "Error: Input file '$input_ips' not found."
  exit 1
fi

# Iterate over each IP in the input file and test SSH connection
while read -r ip; do
  echo "Testing SSH connection to $ip ..."

  # Use ssh-keyscan to add the host to known hosts without prompting
  ssh-keyscan -H "$ip" >> ~/.ssh/known_hosts 2>/dev/null

  # Test SSH connection with automatic 'yes' answer
  echo "yes" | ssh -o "StrictHostKeyChecking=yes" -o "BatchMode=yes" -i "$keyfile" "$username@$ip" echo "SSH connection successful" > /dev/null 2>&1

  # Check the exit status of the SSH command
  if [[ $? -eq 0 ]]; then
    echo "SSH connection successful for $ip"
    echo "$ip: Success" >> "$results"
  elif [[ $? -eq 255 ]]; then
    echo "SSH connection failed for $ip"
    echo "$ip: Password prompt" >> "$results"
  else
    echo "SSH connection failed for $ip"
    echo "$ip: Failure" >> "$results"
  fi

  echo
done < "$input_ips"
