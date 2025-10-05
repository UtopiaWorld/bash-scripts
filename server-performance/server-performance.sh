#!/bin/bash

# Display total CPU usage using top
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | \
            sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | \
            awk '{print 100 - $1}')
echo -e "\n===== Total CPU Usage ====="
echo "Total CPU Usage: $CPU_USAGE%"

# Display total memory usage
MEMORY=$(free -m | awk 'NR==2 {printf "Used: %sMB, Free: %sMB, Usage: %.2f%%", $3, $4, $3*100/($3+$4)}')
echo -e "\n===== Total Memory Usage ====="
echo "$MEMORY"

# Display total disk usage
DISK=$(df -h / | awk 'NR==2 {printf "Used: %s, Free: %s, Usage: %s", $3, $4, $5}')
echo -e "\n===== Total Disk Usage ====="
echo "$DISK"

# Display top 5 processes by CPU usage
echo -e "\n===== Top 5 Processes by CPU Usage ====="
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6

# Display top 5 processes by memory usage
echo -e "\n===== Top 5 Processes by Memory Usage ====="
ps -eo pid,comm,%mem --sort=-%mem | head -n 6\
