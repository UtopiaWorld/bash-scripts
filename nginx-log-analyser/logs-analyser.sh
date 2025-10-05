
#!/bin/bash

# Path to the nginx log file
LOGFILE="nginx.log"

# Top 5 IP addresses with the most requests
echo -e "\nTop 5 IP addresses with the most requests:"
awk '{print $1}' "$LOGFILE" | sort | uniq -c | sort -nr | head -5 | awk '{printf "%s - %s requests\n", $2, $1}'

# Top 5 most requested paths
echo -e "\nTop 5 most requested paths:"
# Extract the request path from the log (second quoted field, then second word)
awk -F"\"" '{print $2}' "$LOGFILE" | awk '{print $2}' | sort | uniq -c | sort -nr | head -5 | awk '{printf "%s - %s requests\n", $2, $1}'

# Top 5 response status codes
echo -e "\nTop 5 response status codes:"
awk '{print $9}' "$LOGFILE" | grep -E '^[0-9]+$' | sort | uniq -c | sort -nr | head -5 | awk '{printf "%s - %s requests\n", $2, $1}'

# Top 5 user agents
echo -e "\nTop 5 user agents:"
# Extract the user agent (sixth quoted field)
awk -F"\"" '{print $6}' "$LOGFILE" | sort | uniq -c | sort -nr | head -5 | awk '{printf "%s - %s requests\n", $2, $1}'
