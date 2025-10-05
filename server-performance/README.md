# Server Performance Script
## Project URL
[https://github.com/UtopiaWorld/bash-scripts](https://github.com/UtopiaWorld/bash-scripts)

This script provides a user-friendly summary of your Linux system's performance, including CPU, memory, disk usage, and top resource-consuming processes.

## How to Run

1. Open a terminal in the script directory:
   ```bash
   cd /path/to/bashscripts/server-performance
   ```
2. Make the script executable:
   ```bash
   chmod +x server-performance.sh
   ```
3. Run the script:
   ```bash
   ./server-performance.sh
   ```

## Script Breakdown

### 1. Memory Usage
```bash
MEMORY=$(free -m | awk 'NR==2 {printf "Used: %sMB, Free: %sMB, Usage: %.2f%%", $3, $4, $3*100/($3+$4)}')
```
- `free -m`: Shows memory usage in megabytes.
- `awk 'NR==2 {...}'`: Processes the second line (main memory stats).
- `$3`: Used memory.
- `$4`: Free memory.
- `$3*100/($3+$4)`: Calculates usage percentage.
- `printf ...`: Formats output as "Used: ...MB, Free: ...MB, Usage: ...%".

### 2. Disk Usage
```bash
DISK=$(df -h / | awk 'NR==2 {printf "Used: %s, Free: %s, Usage: %s", $3, $4, $5}')
```
- `df -h /`: Shows disk usage for root `/` in human-readable format.
- `awk 'NR==2 {...}'`: Processes the second line (root partition).
- `$3`: Used disk space.
- `$4`: Free disk space.
- `$5`: Usage percentage.

### 3. Top 5 Processes by CPU Usage
```bash
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
```
- `ps -eo pid,comm,%cpu`: Lists all processes with PID, command name, and CPU usage.
- `--sort=-%cpu`: Sorts by CPU usage descending.
- `head -n 6`: Shows header + top 5 processes.

### 4. Top 5 Processes by Memory Usage
```bash
ps -eo pid,comm,%mem --sort=-%mem | head -n 6
```
- `ps -eo pid,comm,%mem`: Lists all processes with PID, command name, and memory usage.
- `--sort=-%mem`: Sorts by memory usage descending.
- `head -n 6`: Shows header + top 5 processes.

### 5. Total CPU Usage
```bash
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | \
            sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | \
            awk '{print 100 - $1}')
```
- `top -bn1`: Runs `top` in batch mode for 1 iteration.
  - `-b`: Batch mode (non-interactive).
  - `-n1`: One iteration.
- `grep "Cpu(s)"`: Finds the line with CPU stats.
- `sed "s/.*, *\([0-9.]*\)%* id.*/\1/"`: Extracts the idle CPU percentage.
  - `.*`: Matches everything before idle value.
  - `*\([0-9.]*\)`: Captures idle percentage.
  - `%* id.*`: Matches the rest of the line.
  - `\1`: Refers to captured value.
- `awk '{print 100 - $1}'`: Calculates CPU usage by subtracting idle from 100.

## Output Example
```
===== Total Memory Usage =====
Used: 1234MB, Free: 567MB, Usage: 68.50%

===== Total Disk Usage =====
Used: 10G, Free: 20G, Usage: 33%

===== Top 5 Processes by CPU Usage =====
  PID COMMAND         %CPU
 1234 myapp          25.0
 ...

===== Top 5 Processes by Memory Usage =====
  PID COMMAND         %MEM
 1234 myapp          10.0
 ...

===== Total CPU Usage =====
Total CPU Usage: 31.5%
```

## Notes
- Run as a regular user; no root required.
- Works on most Linux distributions with standard utilities (`free`, `df`, `ps`, `top`, `awk`, `sed`, `grep`).
- For best results, run in a terminal with sufficient width for output alignment.
