# Nginx Log Analyser

## Project URL
[https://github.com/UtopiaWorld/bash-scripts](https://github.com/UtopiaWorld/bash-scripts)

## Reference Project
https://roadmap.sh/projects/nginx-log-analyser

This script analyzes an nginx access log and provides:
- Top 5 IP addresses with the most requests
- Top 5 most requested paths
- Top 5 response status codes
- Top 5 user agents

## How to Run

1. Place your nginx log file in this directory and name it `nginx.log` (or edit the script to use your filename).
2. Make the script executable:
   ```bash
   chmod +x logs-analyser.sh
   ```
3. Run the script:
   ```bash
   ./logs-analyser.sh
   ```


## Key Command Explanations

- `uniq -c`: Counts the number of consecutive duplicate lines and prefixes each with the count. For example, if an IP appears 10 times in a row, it outputs `10 IP`.
- `sort -nr`: Sorts lines numerically (`-n`) and in reverse order (`-r`), so the highest counts appear first. This is useful for showing the most frequent items at the top.

## Script Breakdown

### 1. Top 5 IP addresses with the most requests
```bash
awk '{print $1}' "$LOGFILE" | sort | uniq -c | sort -nr | head -5 | awk '{printf "%s - %s requests\n", $2, $1}'
```
- `awk '{print $1}' "$LOGFILE"`: Extracts the first field (IP address) from each log line.
- `sort`: Sorts the IPs alphabetically.
- `uniq -c`: Counts occurrences of each unique IP.
- `sort -nr`: Sorts by count, highest first.
- `head -5`: Shows the top 5 IPs.
- Second `awk`: Formats output as "IP - N requests".

### 2. Top 5 most requested paths
```bash
awk -F"\"" '{print $2}' "$LOGFILE" | awk '{print $2}' | sort | uniq -c | sort -nr | head -5 | awk '{printf "%s - %s requests\n", $2, $1}'
```
- `awk -F"\"" '{print $2}' "$LOGFILE"`: Splits each line by double quotes, extracts the request string (e.g., GET /path HTTP/1.1).
- `awk '{print $2}'`: Extracts the path from the request string.
- Remaining steps: Same as above, but for paths.

### 3. Top 5 response status codes
```bash
awk '{print $9}' "$LOGFILE" | sort | uniq -c | sort -nr | head -5 | awk '{printf "%s - %s requests\n", $2, $1}'
```
- `awk '{print $9}' "$LOGFILE"`: Extracts the status code (9th field) from each log line.
- Remaining steps: Same as above, but for status codes.

### 4. Top 5 user agents
```bash
awk -F"\"" '{print $6}' "$LOGFILE" | sort | uniq -c | sort -nr | head -5 | awk '{printf "%s - %s requests\n", $2, $1}'
```
- `awk -F"\"" '{print $6}' "$LOGFILE"`: Splits each line by double quotes, extracts the user agent string (6th field).
- Remaining steps: Same as above, but for user agents.

## Notes
- The script assumes the log format is the default nginx combined log format.
- If your log format is different, you may need to adjust field numbers in the `awk` commands.
- All commands use standard Linux utilities: `awk`, `sort`, `uniq`, `head`.
- Output is formatted for easy reading.
