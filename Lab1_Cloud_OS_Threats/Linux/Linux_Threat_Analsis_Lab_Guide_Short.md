### Customized Linux Knowledge Assessment Plan for Job Interview Preparation

This plan is tailored to test and enhance your Linux fundamentals, OS internals, and cloud security knowledge in preparation for the Palo Alto Networks and Meta interviews. It focuses on the job-specific requirements as well as the technical tasks and scenarios you're likely to encounter.




# Lab 1: Linux Threat Analysis
## Questions
1. Explain the difference between user and kernel space in Linux.
2. What are zombie processes? How would you identify and handle them?
3. Describe the purpose of the /proc directory.
4. How do attackers use SUID files to escalate privileges? How can these be detected?
#### Questions
1. Explain the difference between user and kernel space in Linux.
2. What are zombie processes? How would you identify and handle them?
3. Describe the purpose of the /proc directory.
4. How do attackers use SUID files to escalate privileges? How can these be detected?
5. How to view different types of memory? (cached, buffered, free) - `free -m`
6. How to monitor memory swapping? - `vmstat`


#### Technical Questions
Practical Tasks:
1. List all processes consuming the highest CPU and memory (top, ps aux).
2. Simulate a zombie process and clean it up using kill.
3. Inspect the routing table using ip route and identify potential misconfigurations.
4. Set a SUID on a test script and detect it using find (find / -perm -4000).
5. Which processes have the highest CPU and memory usage?
6. Identify processes with root privileges.
9. Trace the system calls of an active process and find the process that is using the most memory.
10. Create a 2 zombie process, 1 root process, and 1 normal process.
11. Send signals using kill and pkill to kill the zombie processes.


## Technical Questions (Command as Result)

1
. How to view running processes? 
2. How to trace system calls of a running process?
3. How to monitor memory usage?
4. How to list files and permissions in a directory?
5. How to search for configuration files in a directory?
6. How to monitor disk usage?
7. How to list network interfaces?
8. How to capture network traffic?
9. How to list firewall rules?

<!-- Context:
## System Information (Attacker’s Perspective)
- **System Information**: Attackers leverage knowledge of processes, users, and configurations to plan and escalate attacks.
- **Temporary Files**: Inspect `/dev/shm` or `/tmp` using `ls -la` for potential leftover files or active processes.

| **Topic**                              | **Attacker’s Perspective**                                                                                                                                       |
|------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Linux Processes**                    | Attackers can hide malicious processes among normal system processes, or target high-privilege processes (like daemons) to gain root access or persist in memory.                                 |
| **Memory Management**                  | Attackers may exploit memory vulnerabilities to execute code, escalate privileges, or bypass security controls.                                                                                   |

### File Descriptors and Redirections
| **File Descriptor**               | **Description**                                                                                  | **Attacker’s Perspective**                                                                                                   |
|---------------------------|--------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------|
| **`STDOUT (FD 1)`**        | Standard output, used for sending normal command output.                                         | Capture or redirect the output of commands to files or other commands for further processing.                               |
| **`\|` (Pipe)**          | Redirects STDOUT from one command to another for further processing. | Chain commands to filter, process, or manipulate output efficiently. |

### File Permissions and Ownership

| **Character**        | **Description**                             | **Attacker’s Perspective**                                                                                         |
|----------------------|---------------------------------------------|--------------------------------------------------------------------------------------------------------------------|
| **First Character**  | File Type                                   | Identify the type of file for reconnaissance or manipulation.                                                      |
| | **`c`**            | Character Device                            | Interact with hardware or system processes for low-level exploitation.                                             |
| | **`s`**            | Socket                                      | Locate and exploit interprocess communication mechanisms.                                                          |
| | **`p`**            | Named Pipe (FIFO)                          | Intercept or manipulate interprocess communication for data exfiltration or privilege escalation.                   |

### Service and Process Management

- **Core Functionality**: Service and process management is a fundamental aspect of Linux administration, involving the monitoring, starting, stopping, and restarting of services and processes.
- **Services (Daemons)**: Background programs, often ending in `d` (e.g., `sshd`), that perform system tasks or provide services without user interaction.
- **Processes**: Active programs that can be managed using signals or commands to control their behavior (e.g., running, stopping, or killing them).
- **Tools and Techniques**: Tools like `systemctl`, `ps`, `kill`, and `journalctl` help administrators and attackers manage services and processes effectively.
- **Importance for Attackers**: Attackers leverage service and process management for persistence (starting malicious services), evasion (killing monitoring processes), and exploration (identifying running services for exploitation).
- **Importance for Attackers**: Exploiting backup misconfigurations can provide access to sensitive data or backup systems themselves. Automated scripts and credentials in backup processes are often key targets.



### Process Commands
This are process commands for attackers to understand the process, the process ID, the process name, the process status, the process owner, the process group, the process start time, the process end time, the process memory usage, the process CPU usage, the process command line, and the process arguments.


| **Command**   | **Description**                      | **Attacker’s Perspective**                                                                                           |
|---------------|--------------------------------------|----------------------------------------------------------------------------------------------------------------------|
| **`ps`**      | Displays process status.             | Enumerate running processes for reconnaissance, identifying root or high-privilege processes to target.              |
| | **1. `ps aux`**: Show all processes with details.     | Quickly identify resource-heavy or suspicious processes.                                                             |
| | **2. `ps -ef`**: Display full-format listing.         | Analyze parent-child process relationships for injection or privilege escalation opportunities.                      |
| | **3. `ps -eo pid,ppid,cmd,%mem,%cpu`**: Show custom fields for process monitoring. | Focus on high CPU/memory-consuming processes for potential exploits or disruptions.                                 |
| | **4. `ps -C sshd`**: Show specific processes by name. | Locate critical services like SSH for monitoring or attack.                                                          |
| **`top` / `htop`** | Monitors system resources in real-time. | Track high-priority targets or identify suspicious system activity to blend in with.                                 |
| | **1. `htop`**: Interactive process viewer.             | Provides easier navigation and filtering for live reconnaissance.                                                    |
| | **2. `top -p <PID>`**: Monitor specific processes by PID. | Focus on particular processes for detailed observation.                                                              |
| **`kill`**     | Sends signals to processes.         | Terminate security tools or restart malicious processes stealthily.                                                  |
| | **1. `kill -9 <PID>`**: Forcefully kill a process.   | Stop critical processes like IDS or monitoring daemons.                                                              |
| | **2. `kill -SIGSTOP <PID>`**: Suspend a process.     | Temporarily halt processes without leaving traces.                                                                   |
| **`pkill`**    | Kills processes by name.            | Stop all instances of a target process (e.g., antivirus or SSH).                                                     |
| | **1. `pkill -f sshd`**: Kill all SSH daemon processes. | Disrupt remote access services or replace with malicious counterparts.                                               |
| **`jobs`**     | Lists background jobs.              | Monitor and manage active tasks during multi-step operations.                                                        |
| **`bg`**       | Resumes a stopped process in the background. | Maintain stealth by running tasks in the background while continuing other activities.                               |
| **`fg`**       | Brings a background process to the foreground. | Regain control of critical tasks for interaction or monitoring.                                                      |
| **`nice / renice`** | Adjusts process priority.       | Reduce priority of security tools or increase priority of malicious processes for stealth.                           |
| | **1. `renice -n -5 <PID>`**: Increase priority of a process. | Ensure uninterrupted execution of payloads or critical tools.                                                        |
| | **2. `renice -n 10 <PID>`**: Decrease priority of a process. | Throttle performance of monitoring tools or competing processes.                                                     |
| **`strace`**   | Traces system calls and signals.    | Monitor process behavior, including file and network operations, for reconnaissance or evasion.                     |
| | **1. `strace -p <PID>`**: Attach to a running process. | Investigate activity of target processes to identify weaknesses or gain insights into their operation.               |
| **`lsof`**    | Lists open files/sockets.              | Spot which processes hold open files or ports—potential pivot points or logs to tamper with.             |
| **`netstat`**            | Displays network connections, routing tables, and port usage.                                         | Identify open ports, active connections, and potential backdoors or C2 channels.                                      |
| | **1. `netstat -tuln`**: Lists listening TCP/UDP ports.                                   | Locate services running on non-default ports for exploitation or reconnaissance.                                       |
| | **2. `netstat -ano`**: Shows active connections with associated PIDs.                   | Map processes to network activity for identifying critical targets.                                                    |
| **`sed`**                 | Stream editor for filtering and transforming text.                                                            | Automate replacing sensitive log entries with benign data or remove traces of activity.                                 |
| | **1. `sed`**: `sed -i '/malicious_command/d' /var/log/auth.log`                                                 | Remove malicious activity traces from authentication logs to evade detection.                                           |
| | **2. `sed 's/bash/secure_shell/g' /etc/passwd`**: Replaces occurrences of "bash" with "secure_shell".| Modify system configurations to redirect legitimate processes, obfuscate system details, or disrupt functionality.   |
| **`awk`**               | Processes text using pattern matching and field extraction.                    | Automate advanced RegEx-based filtering for extracting or manipulating data.                                         |
| **`deja-dup`**                       | Simplifies the backup process with a graphical interface for local or remote backups.                | Exploit default configurations to access backup files or manipulate data.                                           |
| **`chmod`**                          | Modifies permissions for backup scripts or files.                                                    | Grant executable permissions to malicious scripts hidden in backup processes.                                       |
| **`lsof`**              | Lists open files by processes.                                                                    | Identify processes holding files or drives in use to understand system activity or kill blocking processes.       |
| | **1. `lsof | grep /mnt/usb`** | Lists processes accessing `/mnt/usb`.                                                   | Ensure safe unmounting of drives or detect active usage of targeted directories.                                   |
| **`vncserver -list`**             | Lists active VNC sessions with ports and process IDs.                                           | Identify existing sessions for hijacking or enumeration.                                                             |
 -->








## Tasks

---

### **1. Environment Validation**
Before starting the assessment, validate your **Ubuntu VM on GCP** environment:

- Step 1: **SSH Test**: Confirm access using:
  ```bash
  gcloud compute ssh cloud-sec-xdr-vm-1 --zone us-central1-a
  ```
- Step 2: **Ensure these tools are installed**:
   - **strace**: Traces system calls and signals.
   - **lsof**: Lists open files and the processes that opened them.
   - **htop**: Interactive process viewer.
   - **net-tools**: Provides network configuration tools like ifconfig.
   - **tcpdump**: Network packet analyzer.
   - **nmap**: Network scanner.
   - **iproute2**: Utilities for controlling networking and traffic (includes ip command).
   - **sysstat**: System performance tools.
   - **iotop**: Interactive I/O monitor.
   - **Command**: `sudo apt update && sudo apt install -y strace lsof htop net-tools tcpdump nmap iproute2 sysstat iotop`
  

- Step 2.2: **Ensure the following tools are installed**:
   - **strace**: `strace --version`
   - **lsof**: `lsof -v`
   - **htop**: `htop --version`
   - **net-tools**: `ifconfig --version`
   - **tcpdump**: `tcpdump --version`
   - **nmap**: `nmap --version`
   - **iproute2**: `ip --version`
   - **sysstat**: `sysstat --version`
   - **iotop**: `iotop --version`


- Step 3: **Install Python 3.11**:
  ```bash 
  sudo add-apt-repository ppa:deadsnakes/ppa
  sudo apt update -y
  sudo apt install -y python3.11 python3.11-venv python3.11-distutils
  python3.11 --version
```

- Step 4: **Update alternatives**: # Python 3.11.11
```bash 
   sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 2
   sudo update-alternatives --config python3
   python3 --version
```


- Step 5: **Create a virtual environment**:
```bash 
   python3 -m venv ~/Envs/L1_Process_Analysis_venv
   source ~/Envs/L1_Process_Analysis_venv/bin/activate
```

- Step 6: **Install pandas, numpy, scipy**:
```bash 
   pip3 install pandas numpy scipy
  ```
- Step 6.2: **Ensure the following packages are installed**:
   - **pandas**: `pandas --version`
   - **numpy**: `numpy --version`
   - **scipy**: `scipy --version`

### Step 7: **Create a Test Process**
#### Step 7.1: **Create a Normal User Process: `normal_process.sh`**
```bash
echo '#!/bin/bash
sleep 600' > normal_process.sh
chmod +x normal_process.sh
./normal_process.sh &
```

#### Step 7.2: **Create a Root Process: `root_process.sh`**
```bash
echo '#!/bin/bash
sleep 600' > root_process.sh
chmod +x root_process.sh
sudo ./root_process.sh &
```

#### Step 7.3: **Create a Zombie Process: `zombie_process.sh`**
A zombie process occurs when a child process completes execution but its parent process does not call wait() to retrieve its status.
The parent script (zombie_process.sh) will finish execution but leave its child processes (created via bash -c "sleep 300") in a "zombie" state because the parent script does not explicitly manage or wait for the children to terminate.
```bash
echo '#!/bin/bash
for i in {1..2}
do
    bash -c "sleep 300" &
done
' > zombie_process.sh
chmod +x zombie_process.sh
./zombie_process.sh &
```

### Step 8: **Set Up SUID Test File**
To explore SUID privilege escalation, create a test script, make it executable, and set the SUID bit:

```bash
echo '#!/bin/bash
echo "This is a test script with SUID."
' > suid_test.sh
chmod +x suid_test.sh
sudo chown root:root suid_test.sh
sudo chmod u+s suid_test.sh
```

### Step 9: **Configure Network Interfaces**
- Ensure your network interfaces are active for network monitoring tasks.
- Check interface statuses using `ip addr` or `ifconfig`.
- Check if `ufw` (Uncomplicated Firewall) is enabled using.
   - Enable / Disable `sudo ufw enable` / `sudo ufw disable`.
   - If Disabled Keep it disabled - `sudo ufw status` - `Status: inactive`
   - If Enabled - add firewall rules to allow traffic on relevant ports. (**80, 22, 8080, etc.**)
   - `sudo ufw allow 80/tcp`
   - `sudo ufw allow 22/tcp`
   - `sudo ufw allow ssh`
   - `sudo ufw allow 8080/tcp`

### Step 10: **Create a Test File for Memory Analysis**
```bash
echo '#!/bin/bash
while true; do
    echo "Memory Test"
    sleep 1
done' > memory_test.sh
chmod +x memory_test.sh
./memory_test.sh &
```

# Step 11: **Start some services as root and some as normal user**
```bash
sudo apt install -y apache2
sudo systemctl start apache2
python3 -m http.server 8080 &
mkdir -p ~/.config/systemd/user
echo '
[Unit]
Description=My Custom User Service (GM)
After=network.target

[Service]
ExecStart=/usr/bin/python3 -m http.server 9090
WorkingDirectory=/home/galmoshkovitz/L1_Process_Analysis
Restart=on-failure

[Install]
WantedBy=default.target
' > ~/.config/systemd/user/gm_service.service

systemctl --user daemon-reload
systemctl --user enable gm_service.service
systemctl --user start gm_service.service























---

### **2. Linux OS Internals Knowledge Test**

#### **2.1 Process and Memory Management**
1. **Analyze Running Processes**:
   - Use `ps aux` to view running processes and answer:
     - Which processes have the highest CPU and memory usage?
     - Identify processes with root privileges.

2. **Process Signals**:
   - Practice sending signals using `kill` and `pkill`.
   - Use `strace` to trace system calls of an active process.

3. **Memory Analysis**:
   - Run `free -m` and explain the difference between **cached**, **buffered**, and **free** memory.
   - Use `vmstat` to monitor memory swapping.

#### **2.2 File System and Storage**
1. **File Permissions**:
   - List files in `/etc` and explain the meaning of permissions (`ls -l`).
   - Create a file with `chmod 777`, then explain why it is insecure.

2. **File System Navigation**:
   - Search for `.conf` files in `/etc` using `find` and `locate`.
   - Explore and explain the importance of `/var`, `/bin`, `/dev`, and `/home`.

3. **Disk Usage**:
   - Use `df -h` and `du -sh` to monitor storage usage.
   - Explain how to identify and clean up large files.

#### **2.3 Network Configuration and Monitoring**
1. **Interface Management**:
   - Use `ip addr` or `ifconfig` to identify network interfaces.
   - Assign a static IP to an interface (use a dummy IP for the exercise).

2. **Traffic Monitoring**:
   - Capture packets on a specific interface using `tcpdump`:
     ```bash
     sudo tcpdump -i eth0 -c 10
     ```

3. **Firewall Rules**:
   - List existing `iptables` rules.
   - Add a rule to allow traffic on port `8080` and delete it afterward.

---

### **3. Cloud-Specific Tasks**

#### **3.1 GCP Resource Configuration**
1. Confirm the firewall rules:
   - Check rules using `gcloud compute firewall-rules list`.
   - Test rules using `nc` or `curl` to verify allowed and blocked ports.

2. Verify the VPC network:
   - Use `gcloud compute networks describe cloud-sec-xdr-vpc`.

3. Simulate a scenario:
   - Host a simple Python web server on your VM:
     ```bash
     python3 -m http.server 8080
     ```
   - Verify accessibility from an external IP.

#### **3.2 Cloud Security**
1. **IAM Permissions**:
   - List service account permissions:
     ```bash
     gcloud iam service-accounts list
     ```
   - Identify potential privilege escalation scenarios.

2. **Cloud Storage**:
   - Create a bucket using `gcloud storage buckets create` and simulate uploading sensitive data.

---

### **4. Host-Based Threat Analysis**

#### **4.1 Log Analysis**
1. **System Logs**:
   - Extract recent SSH login attempts from `/var/log/auth.log` or `journalctl`.
   - Filter out failed login attempts using `grep`.

2. **Audit Daemons**:
   - Install and configure `auditd` to track sensitive file access.
   - Test with:
     ```bash
     ausearch -f /etc/passwd
     ```

#### **4.2 Endpoint Security**
1. Simulate a threat:
   - Create a cron job that runs a reverse shell script.
   - Analyze and remove the malicious job after discovery.

2. **Kernel Modules**:
   - List active modules using `lsmod`.
   - Research and remove an unused or malicious module.

---

### **5. Malware Simulation**

1. **Simulate Malware Behavior**:
   - Write a harmless script mimicking malicious activity:
     ```bash
     while true; do echo "Simulating Malware"; sleep 60; done
     ```
   - Run it in the background, then use `ps` and `top` to analyze its behavior.

2. **Memory Dump**:
   - Create and analyze a memory dump of a process using `gcore`.

3. **Network Behavior**:
   - Monitor connections of the script using `netstat` or `ss`.

---

### **6. Review and Feedback**
After completing these tasks, summarize:
1. What challenges did you face?
2. Were there any concepts/tools that you struggled with?
3. List three topics for deeper exploration.

---

### Next Steps:
- Share your results or questions for targeted feedback.
- Continue with coding challenges using Python (data parsing, log correlation).
- Simulate advanced APT scenarios with MITRE ATT&CK techniques.
