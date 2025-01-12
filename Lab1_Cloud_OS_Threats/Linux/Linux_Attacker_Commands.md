# Linux Attacker Commands
- **Tools & Commands**: Almost any built-in command can be weaponized—from simple listing utilities (ls, cat) to network (curl, netstat) and package management (apt, pip).

## Attacker Commands Cheat Sheet
Below is a **comprehensive Attacker Commands Cheat Sheet** in the style of your example. Where helpful, common sub-commands or flags have been included under each primary command (numbered), mirroring the **“Command / Description / Attacker’s Perspective”** format. Duplicates have been removed or consolidated.
- Commands that **administrators** use daily can be weaponized by attackers to **enumerate**, **exploit**, and **maintain** access.  
- Many of these commands have **sub-commands/flags** that reveal additional system details or **bypass** typical checks, making them invaluable for **stealthy operations**.  
- By thinking about each command from an **Attacker’s Perspective**, you can better understand how to **secure** and **monitor** your Linux environment.




### Helpful Commands
This are helpful commands for attackers to understand the system and the tools that are available and how to use them.

| **Command**                    | **Description**                                     | **Attacker’s Perspective**                                                                                     |
|--------------------------------|-----------------------------------------------------|----------------------------------------------------------------------------------------------------------------|
| **`man <tool>`**              | Opens manual pages for the specified tool.          | Study system utilities and flags to identify overlooked functionality or edge-case usage for exploits.         |
| **`<tool> -h`**               | Prints the help page of the tool.                   | Quickly discover command flags, unexpected features, or side effects for malicious use.                        |
| **`apropos <keyword>`**       | Searches man-page descriptions for a keyword.       | Locate commands (e.g., network or file utilities) to facilitate reconnaissance or tailor exploit paths.        |

---

### System Information Commands
This are system information commands for attackers to understand the system, the kernel, the architecture, the hostname, the build details, the OS type, and the architecture.

| **Command**         | **Description**                           | **Attacker’s Perspective**                                                                                                                 |
|---------------------|-------------------------------------------|------------------------------------------------------------------------------------------------------------------------                    |
| **`uname`**           | Prints OS and hardware info.              | Tailor exploits to kernel/architecture or confirm if the system is virtualized.                                                            |
| | **1. `uname -a`**: Show all system info.                     | Identify **kernel name & version**, **hostname**, **Build Details**, **OS type**, and **architecture** to match with known vulnerabilities.|
| |**2. `uname -r`**: Display the kernel release version.       | Pinpoint kernel-specific privilege escalation exploits.                                                                                    |
| |**3. `uname -m`**: Show machine hardware name.               | Check if it’s 32-bit or 64-bit to load the right exploit binaries.                                                                         |

---

### User Information Commands
This are user information commands for attackers to understand the user, the group, the user ID, the group ID, the user's home directory, the user's shell, the user's login history, and the user's groups.
| **Command**  | **Description**             | **Attacker’s Perspective**                                                                              |
|--------------|-----------------------------|---------------------------------------------------------------------------------------------------------|
| **`whoami`**   | Displays current username. | Verify if you have escalated to `root` or confirm which user context you’re operating under.           |
| **`id`**       | Returns user ID info.      | Identify group memberships; spotting `sudo` or other privileged groups is crucial for escalation paths. |
| **`hostname`** | Prints/sets system name.   | Helps map or rename a host in multi-target scenarios, possibly to confuse defenders or logs.           |

---

### Directory Navigation Commands
This are directory navigation commands for attackers to understand the directory, the file, the permissions, the owner, the group, the size, the modification time, the inode number, the color-coded output, the symbols, and the hidden files.

| **Command**   | **Description**                            | **Attacker’s Perspective**                                                                                       |
|---------------|--------------------------------------------|------------------------------------------------------------------------------------------------------------------|
| **`pwd`**       | Prints working directory.                  | Ensures correct file-system navigation, especially after pivoting or using chroot/jail escapes.                 |
| **`tree`**      | Lists directory contents recursively.       | Rapidly visualize the entire filesystem layout, searching for “interesting” files or directories<br>- Quickly confirm file placements.<br>- Quickly identify high-value targets or hidden directories. |
| | **1. `tree /opt/backups/`**: Lists directory contents recursively.       | Verify if files are hidden properly. |
| **`mkdir`**     | Creates a directory.                       | Create hidden or nested directories to stash tools or exfiltration data.                                        |
| | **1. `mkdir -p <path>`**: Creates a directory and all necessary parent directories. | Establish deep structures for hiding payloads.<br>- Mimic legitimate directory trees for stealth. |
| | **2. `mkdir -p /opt/backups/secrets/configs`**: Creates a directory and all necessary parent directories. | Hide sensitive or malicious files in complex, nested directories. |
| **`ls / cd / clear`** | Basic directory navigation commands.        | Standard ways to move through the system and keep the attacker’s terminal output tidy.                           |
| **`ls`**                       | Lists only files and directories in the current folder.                                               | - Identify available files and directories for reconnaissance.<br>- Establish targets for further exploration.<br>- Initial reconnaissance of the directory structure      |
| | **1. `ls -l`**: Displays files and directories in long format with details.                                      | - Analyze permissions, ownership, and modification times.<br>- Detect misconfigurations or weak permissions.<br>- Identify permissions (`drwxr-xr-x`), owner (`user`), group (`group`), and size (`4096` bytes) of each file or directory.         |
| | **2. `ls -la`**: Lists all files, including hidden ones, in long format.                                          | - Discover hidden files like `.bashrc` or `.bash_history` that may contain sensitive information <br>- Find hidden files or misconfigured permissions <br>- Spot potential privilege escalation vectors.                    |
| | **3. `ls -l /path/to/dir`**: Lists contents of a specified directory. | - Enumerate directories without navigating to them.<br>- Identify sensitive directories (e.g., `/var/log`).          |
| | **4. `ls -la /dev/shm`**: Lists all files in `/dev/shm` with permissions and ownership.                                    | - Locate temporary files left by applications.<br>- Identify opportunities for memory-based exploitation.            |
| | **5. `ls -lh`**: Displays file sizes in human-readable format.                                                   | - Understand file sizes to estimate data of interest for exfiltration or analysis.<br>- Understand file sizes for exfiltration or to prioritize large files.                                  |
| | **6. `ls -lt`**: Lists files sorted by modification time, most recently modified first.                          | - Quickly spot recently changed or accessed files, indicating potential logs or recent activity.<br>- Find the most recently accessed or modified files, often indicating active use or logs.                     |
| | **7. `ls -R`**: Recursively lists all files and directories within a directory structure.                       | - Map out entire directory trees to locate valuable data.<br>- Enumerate nested directories in a single command.<br>- Enumerate directory structures in-depth to locate hidden or deeply nested files.      |
| | **8. `ls -ld`**: Displays information about a directory itself instead of its contents.                          | - Check permissions and ownership on directories to identify privilege escalation opportunities.                     |
| | **9. `ls -i`**: Displays the inode number of each file.                                                         | - Use inode numbers to access files indirectly (useful in forensic evasion).                                        |
| | **10. `ls --color=auto`**: Displays files with color-coded output for easier visual parsing.                               | - Quickly distinguish file types (e.g., executables, directories, symlinks) to prioritize targets.                   |
| | **11. `ls -F`**: Appends symbols to entries (`/` for directories, `*` for executables, `@` for symlinks).        | - Instantly identify directories, executables, and symbolic links for further analysis.                              |

---

### Network Commands
This are network commands for attackers to understand the network, the interfaces, the routes, the TCP/UDP ports, the connections, the sockets, the web server, and the web server port.

| **Command**           | **Description**                                         | **Attacker’s Perspective**                                                                                                             |
|-----------------------|---------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------|
| **`ifconfig`**          | Views or configures a network interface. (Legacy)      | Reconfigure interfaces, enable promiscuous mode, or disable interfaces to evade detection.                                            |
| **`ip`**                | Shows/manipulates routing, interfaces, and tunnels.    | Advanced network recon—lists routes, subnets, or sets up tunnels for lateral movement.                                                |
| | **1. `ip link show`**: Display network interfaces.                          | Identify interfaces, their states, and their statistics.                                                                            |
| | **2. `ip -o link show \| awk '/mtu 1500/ {print $2}' \| tr -d ':'`**: Display interfaces with a MTU of 1500.       | Identify interfaces, their states, and their statistics.<br>- `-o`: Single-line output<br>- `awk '/mtu 1500/ {print $2}'`: Filters interface names with a MTU of 1500 and extracts the second field<br>- `tr -d ':'`: Removes colons (`:`) from the interface names. |
| | **3. `ip route show`**: Display routing table.                          | Identify routes, their metrics, and their destinations.                                                                            |
| **`netstat`**           | Shows network connections and status.                  | Identify open ports, listening services, or suspicious connections for infiltration or exfiltration.                                  |
| | **1. `netstat -tuln`**: Lists TCP/UDP ports listening without DNS resolution.   | Quickly pinpoint potential entry points or crucial services.                                                                          |
| | **2. `netstat -ano`**: Displays connections with associated PIDs.             | Map processes to ports—useful for targeting vulnerable services or stealthy backdoors.                                                |
| **`ss`**                | Socket statistics tool (netstat alternative).          | Similar usage to netstat; can list open sockets or connected endpoints more efficiently.                                              |
| **`curl`**       | Transfers data from/to a server.                       | Download malicious payloads or exfiltrate data over HTTP/HTTPS.                                                                       |
| **`wget`**       | Transfers data from/to a server.                       | Download malicious payloads or exfiltrate data over HTTP/HTTPS.                                                                       |
| **`python3 -m http.server`** | Spins up a simple web server on port 8000.          | Host malicious files or stolen data for quick retrieval from another compromised system.                                              |

---

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


---

### Environment Information Commands
This are environment information commands for attackers to understand the environment, the environment variables, the environment path, the environment user, the environment group, the environment start time, the environment end time, the environment memory usage, the environment CPU usage, the environment command line, and the environment arguments.

| **Command** | **Description**                        | **Attacker’s Perspective**                                                                               |
|-------------|----------------------------------------|----------------------------------------------------------------------------------------------------------|
| **`who`**     | Lists users logged in.                 | Identify active admin sessions to hijack or observe for timing stealth attacks.                          |
| **`env`**     | Prints environment variables.          | Look for credentials or token leaks in environment variables; manipulate `PATH` for malicious binaries.  |
| **`lsof`**    | Lists open files/sockets.              | Spot which processes hold open files or ports—potential pivot points or logs to tamper with.             |
| **`lsblk`**   | Lists block devices.                   | Discover hidden partitions or mounted disks that might store sensitive data.                             |
| **`lsusb`**   | Lists USB devices.                     | Check for potential data exfil USB devices or hardware keyloggers.                                      |
| **`lspci`**   | Lists PCI devices.                     | Understand physical hardware (e.g., GPUs, NICs) for advanced or driver-based exploits.                   |
| **`lscpu`**   | Lists CPU information.                     | Understand physical hardware (e.g., GPUs, NICs) for advanced or driver-based exploits.                   |


---

### Privilege Escalation Commands
This are privilege escalation commands for attackers to understand the privilege escalation, the privilege escalation user, the privilege escalation group, the privilege escalation start time, the privilege escalation end time, the privilege escalation memory usage, the privilege escalation CPU usage, the privilege escalation command line, and the privilege escalation arguments.

| **Command** | **Description**                                           | **Attacker’s Perspective**                                                                                 |
|-------------|-----------------------------------------------------------|------------------------------------------------------------------------------------------------------------|
| **`sudo`**    | Executes commands as another user (often root).           | If misconfigured or accessible, it’s a direct route to privilege escalation.                               |
| **`su`**      | Switches user accounts.                                   | Attempt to become `root` or another privileged user if credentials are known or guessed.                   |
| **`useradd`** / **userdel** / **usermod** | Manage user accounts.                         | Create backdoor users, remove legitimate ones to sabotage admins, or modify accounts for persistence.     |
| **`addgroup`** / **delgroup**          | Manage groups.                               | Hide malicious accounts in custom groups or remove critical groups to break normal user access.           |
| **`passwd`**  | Changes user passwords.                                    | Lock out admins or set trivial passwords on newly created accounts.                                       |

---


### System Management Commands
This are system management commands for attackers to understand the system management, the system management user, the system management group, the system management start time, the system management end time, the system management memory usage, the system management CPU usage, the system management command line, and the system management arguments.
| **Command**       | **Description**                             | **Attacker’s Perspective**                                                                                  |
|-------------------|---------------------------------------------|-------------------------------------------------------------------------------------------------------------|
| **`systemctl`**   | Manages services and system states.         | Start/stop malicious services or disable security tools for persistence or evasion.                        |
| | **1. `systemctl start <service>`**: Starts a service.           | Activate legitimate or malicious services to establish persistence.                                         |
| | **2. `systemctl stop <service>`**: Stops a service.             | Disable critical services to disrupt system operations or security monitoring.                              |
| | **3. `systemctl enable <service>`**: Enables a service at boot. | Ensure persistence by auto-starting malicious services.                                                     |
| | **4. `systemctl mask <service>`**: Masks a service.             | Prevent critical services like firewalls or security tools from being started.                              |
| | **5. `systemctl list-units --type=service`**: Lists active services. | Identify running services for reconnaissance or exploitation.                                               |
| **`journalctl`**  | Queries systemd logs.                       | Review logs for reconnaissance, tamper logs to hide malicious activity, or analyze security events.         |
| | **1. `journalctl -u <service>`**: Shows logs for a specific service. | Investigate service logs for configuration errors or vulnerabilities.                                       |
| | **2. `journalctl --since "1 hour ago"`**: View recent logs.    | Analyze recent events for signs of attack detection or system changes.                                      |
| **`uptime`**      | Displays system uptime.                     | Check how long the system has been running to gauge activity patterns or plan reboots.                      |
| **`dmesg`**       | Prints kernel messages.                     | Analyze kernel logs for hardware issues, driver exploits, or evidence of tampering.                         |
| | **1. `dmesg | grep error`**: Filters kernel errors.            | Locate potential kernel-level vulnerabilities or misconfigurations.                                         |
| **`uname`**       | Displays system information.                | Gather OS details for selecting tailored exploits or privilege escalation methods.                          |
| | **1. `uname -a`**: Displays all system information.            | Identify kernel version, architecture, and hostname for targeted attacks.                                   |
| | **2. `uname -r`**: Shows the kernel release version.           | Pinpoint kernel vulnerabilities for exploitation.                                                           |
| **`shutdown` / `reboot`** | Shuts down or restarts the system.  | Force system reboots to disrupt incident response or test persistence mechanisms.                           |
| **`who` / `w`**   | Displays logged-in users.                   | Identify active users and potential targets for credential harvesting or social engineering.                |
| | **1. `who`**: Lists current users.                            | Check for admin accounts or identify idle sessions for exploitation.                                        |
| | **2. `w`**: Shows user activity.                              | Monitor user activity to avoid detection during operations.                                                 |

### Service Management Commands
This are service management commands for attackers to understand the service management, the service management user, the service management group, the service management start time, the service management end time, the service management memory usage, the service management CPU usage, the service management command line, and the service management arguments.
| **Command**              | **Description**                                                                                       | **Attacker’s Perspective**                                                                                               |
|--------------------------|-------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------|
| **`service`**            | Manages services (SysVinit).                                                                          | Start, stop, or restart services for reconnaissance, disruption, or persistence.                                       |
| | **1. `service <service> start`**: Starts a service.                                      | Activate legitimate or malicious services.                                                                             |
| | **2. `service <service> stop`**: Stops a service.                                        | Disable critical services like firewalls or IDS.                                                                       |
| **`chkconfig`**          | Configures services for startup.                                                                      | Enable or disable services to manipulate startup behavior.                                                             |
| | **1. `chkconfig <service> on`**: Enables a service at boot.                              | Ensure persistence by enabling malicious services.                                                                     |
| **`update-rc.d`**        | Updates SysVinit scripts.                                                                             | Modify startup scripts to add persistence mechanisms or disable security services.                                     |
| **`netstat`**            | Displays network connections, routing tables, and port usage.                                         | Identify open ports, active connections, and potential backdoors or C2 channels.                                      |
| | **1. `netstat -tuln`**: Lists listening TCP/UDP ports.                                   | Locate services running on non-default ports for exploitation or reconnaissance.                                       |
| | **2. `netstat -ano`**: Shows active connections with associated PIDs.                   | Map processes to network activity for identifying critical targets.                                                    |

---

### File Search Commands
This are file search commands for attackers to understand the file search, the file search user, the file search group, the file search start time, the file search end time, the file search memory usage, the file search CPU usage, the file search command line, and the file search arguments.
The **Find**, **Updatedb/Locate**, and **Which** commands are essential for reconnaissance in Linux systems. They help attackers uncover sensitive files, verify tool availability, and streamline post-exploitation activities. These tools, combined with filtering and execution options, allow for precise targeting and efficient enumeration.

| **Command**        | **Description** | **Attacker’s Perspective**                                                                                                   |
|--------------------|------------------------------|--------------------------------------|
| **`find`**         | Locates files and directories using extensive filtering options like size, owner, and type | - Discover sensitive files (e.g., `.conf`, `.ssh` keys, credentials) hidden across the filesystem.<br>- Identify SUID binaries for privilege escalation. <br>`-type` (Specify file type, e.g., `f` for files, `d` for directories) <br>`-exec` (Execute a command on search results)|
| | **1. `find / -type f -name "*.conf" -size +20k -user root 2>/dev/null`**: Locate large configuration files owned by root for potential misconfigurations. |
| | **2. `find / -perm -4000 -exec ls -l {} \; 2>/dev/null`**: Search for all SUID binaries and list their details to identify privilege escalation opportunities. |
| **`locate`**       | Quickly searches for files using a prebuilt database, enabling faster but less granular searches compared to find | - Enumerate files with common extensions like `.conf` for sensitive configurations.<br>- Search for backup or temp files <br>`--database` (Specify a custom database for searching) <br>`--regex` (Use regular expressions to refine search results)|
| | **1. `locate *.conf`**: Quickly list all configuration files. | Identify configuration files for exploitation. |
| | **2. `locate *~`**: Search for backup files created by editors or administrators. | Searching for backup files to identify potential sensitive data. |
| **`updatedb`**     | Updates the `locate` command’s database with the latest file and directory changes.| - Prepare for faster searches after creating new files.<br>- Keep track of newly added sensitive files in real time <br> `--prunepaths` (Exclude specified directories) <br> `--prunefs` (Exclude specific file systems|
| | **1. `sudo updatedb`**: Update the file database for accurate results with `locate`. | Update the database to reflect the latest changes in the filesystem. |
| | **2. `updatedb --prunepaths=/mnt --prunefs=tmpfs`**: Exclude paths or file systems from the updated database for faster updates. | Exclude paths or file systems from the updated database for faster updates. |
| **`which`**        | Shows the path to an executable binary. | - Verify if useful binaries (e.g., `nc`, `python`, `gcc`) are installed.<br>- Identify potential attack tools available on the target system. <br>`--all` (Display all matching executables) <br>`--skip-alias` (Ignore aliases while searching) |
| | **1. `which nc`**: Locate the path of `netcat` to use for reverse shells or port scanning. | Identify the location of the nc binary for exploitation. |
| | **2. `which gcc`**: Determine if the target system has a compiler available for compiling exploits. | Determine if the target system has a compiler available for compiling exploits. |
| | **3. `which --all python`**: Display all matching executables. | Display all matching executables. |
| | **4. `which --skip-alias python`**: Ignore aliases while searching. | Ignore aliases while searching. |

---

### File Viewing Commands
This are file viewing commands for attackers to understand the file viewing, the file viewing user, the file viewing group, the file viewing start time, the file viewing end time, the file viewing memory usage, the file viewing CPU usage, the file viewing command line, and the file viewing arguments.
| **Command**                             | **Description**                                                 | **Attacker’s Perspective**                                                                               |
|-----------------------------------------|-----------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|
| **`cat`**                 | View file contents (entire or partial).                                                                       | Read sensitive info (configs, logs, secrets) without modifying timestamps; partial reads can be stealthier.            |
| | **1. `cat /etc/passwd`**: Displays user account information.                                                                             | Enumerate system users and identify potential targets for brute-force or privilege escalation attacks.                  |
| | **2. `cat /etc/shadow`**| Displays hashed passwords (requires root).                                                                    | Extract password hashes for offline cracking or credential reuse attacks.                                              |
| | **3. `cat /etc/group`** | Shows user group memberships.                                                                                 | Identify privileged groups like `sudo` or `docker` for potential privilege escalation.                                  |
| | **4. `cat /etc/hosts`** | Lists local hostname-to-IP mappings.                                                                          | Discover internal systems and services mapped to IP addresses.                                                         |
| | **5. `cat /etc/hostname`**| Displays the system hostname.                                                                               | Verify the identity of the target system; spoof hostname to mislead defenders.                                         |
| | **6. `cat /etc/fstab`** | Lists mounted filesystems and options.                                                                        | Locate NFS shares, remote mounts, or misconfigured filesystems for lateral movement.                                    |
| | **7. `cat /etc/issue`** | Displays pre-login message or system identifier.                                                              | Identify the operating system or distribution for targeted exploits.                                                    |
| | **8. `cat /etc/os-release`** | Provides detailed OS information.                                                                     | Pinpoint the distribution version for vulnerabilities or kernel exploits.                                               |
| | **9. `cat /etc/lsb-release`**| Contains additional OS details for Debian-based systems.                                                | Similar to `/etc/os-release`, used for better targeting of attacks.                                                     |
| | **10. `cat /etc/debian_version`**| Displays the Debian version of the OS.                                                              | Validate the OS version for compatibility with known exploits.                                                          |
| | **11. `cat ~/.bash_history`**| Displays the history of shell commands.                                                                | Find sensitive commands, credentials, or paths used by administrators.                                                  |
| | **12. `cat /proc/cpuinfo`**: Provides detailed CPU information.                                                                         | Determine the hardware architecture for compiling tailored exploits.                                                    |
| **`sort`**| Sort lines of text. | Organize large output files for easier analysis, such as sorting logs or lists of credentials. |
| | **1. `sort usernames.txt`**: Alphabetize user lists to identify patterns or duplicates in accounts. | Alphabetize user lists to identify patterns or duplicates in accounts.                                                 |


### File Content Filtering Commands
This are file content filtering commands for attackers to understand the file content filtering, the file content filtering user, the file content filtering group, the file content filtering start time, the file content filtering end time, the file content filtering memory usage, the file content filtering CPU usage, the file content filtering command line, and the file content filtering arguments.

| **Command** | **Description** | **Attacker’s Perspective** |
| **`grep`**             | Searches for patterns in text.                                                 | Extract credentials, tokens, or sensitive data from logs, configs, or command output.                                |
| | **1. `grep password /etc/passwd`**: Searches for the term "password" in files.                        | Quickly locate hardcoded passwords in configuration files.                                                           |
| | **2. `grep -i "error" /var/log/syslog`**: Case-insensitive search for "error" in system logs.          | Locate error messages indicating misconfigurations or vulnerabilities.                                               |
| | **3. `grep -v "nologin\|false" /etc/passwd`**: Excludes lines with "nologin" or "false".              | Identify active user accounts for further exploitation.                                                              |
| | **4. `grep -E "root\|admin" /etc/group`**: Uses extended regex to find specific groups.                | Enumerate privileged groups for potential privilege escalation.                                                      |
| **`cut`**              | Removes sections from each line of input.                                       | Extract specific fields from log entries or configs, e.g., usernames or IP addresses.                                |
| | **1. `cut -d':' -f1 /etc/passwd`**: Extracts usernames from `/etc/passwd`.                            | Identify user accounts for brute-force attacks or privilege escalation attempts.                                      |
| | **2. `cut -d':' -f3 /etc/passwd`**: Extracts UIDs from `/etc/passwd`.                                  | Identify user privileges and target high-value accounts.                                                             |
| **`tr`**                  | Translates or deletes characters.                                                                             | Clean or manipulate text data, e.g., replacing newline characters for formatting output.                               |
| | **1. `tr`**: `echo "text" | tr '[:lower:]' '[:upper:]'`                                                       | Convert sensitive output to uppercase for easier comparison or manipulation.                                            |
| | **2. `echo "admin,root" \| tr ',' '\n'`**: Replaces commas with newlines.                             | Format lists for easier processing or automation.                                                                    |
| | **3. `cat /etc/passwd \| tr ':' ' '`**: Replaces colons with spaces.                                  | Simplify formatting for readability or compatibility with custom tools.                                              |
| **`column`**              | Formats text fields into columns.                                                                             | Display data in a structured, readable format for analysis or reporting.                                                |
| | **1. `column`**: `cat data.txt | column -t`                                                                         | Display tabulated output for better readability when reviewing log files or data dumps.                                |
| | **2. `cat /etc/passwd \| tr ':' ' ' \| column -t`**: Formats `/etc/passwd` into aligned columns.      | Quickly visualize key data points for analysis.                                                                      |
| **`awk`**                 | Pattern scanning and processing language.                                                                     | Extract specific fields, filter data, and manipulate text in complex configurations or logs.                            |
| | **1. `awk`**: `awk '/root/ {print $1}' /etc/passwd`                                                             | Extract and display lines containing "root" to investigate elevated privileges.                                         |
| | **2. `awk -F':' '{print $1}' /etc/passwd`**: Extracts usernames from `/etc/passwd`.                   | Enumerate users efficiently without additional tools.                                                                |
| | **3. `awk -F':' '{print $1, $3}' /etc/passwd`**: Extracts usernames and UIDs.                        | Combine critical fields to identify privileged accounts or vulnerabilities.                                          |
| | **4. `awk -F':' '$3 == 0 {print $1}' /etc/passwd`**: Extracts users with UID 0 (root).                | Identify root-level accounts for privilege escalation opportunities.                                                 |
| **`sed`**                 | Stream editor for filtering and transforming text.                                                            | Automate replacing sensitive log entries with benign data or remove traces of activity.                                 |
| | **1. `sed`**: `sed -i '/malicious_command/d' /var/log/auth.log`                                                 | Remove malicious activity traces from authentication logs to evade detection.                                           |
| | **2. `sed 's/bash/secure_shell/g' /etc/passwd`**: Replaces occurrences of "bash" with "secure_shell".| Modify system configurations to redirect legitimate processes, obfuscate system details, or disrupt functionality.   |
| | **3. `sed -i '/nologin/d' /etc/passwd`**: Deletes lines containing "nologin".                        | Filter out system accounts to focus solely on interactive user accounts for privilege escalation or lateral movement. |
| **`wc`**                  | Counts lines, words, and bytes in input.                                                                      | Calculate data size for exfiltration or verify completeness of stolen files.                     
| | **1. `wc`**: `wc -l /var/log/syslog`                                                                           | Count the number of lines in a log file to estimate data size for exfiltration.                                         |                        |
| | **2. `wc -l /etc/passwd`**: Counts the number of lines in `/etc/passwd`.                              | Determine the number of user accounts or entries quickly.                                                            |
| | **3. `cat logs.txt \| wc -c`**: Counts the number of characters in a file.                           | Estimate file size for efficient data transfer or staging.                                                           |
| **`nano / vim`**                | Powerful editor for making extensive changes, running regex replacements, or automating edits via scripting.            | Modify system files or scripts for persistence, obfuscation, or privilege escalation. |
| | **1. `nano / vim`**: `nano /etc/cron.d/persistence` or `vim /etc/cron.d/persistence`                                   | Insert a cron job to establish persistent access to the system.                                                         |
| **`less`**             | Displays file contents one screen at a time with navigation features.          | Analyze large files stealthily without leaving output in the terminal history.                                       |
| | **1. `less /var/log/auth.log`**: Opens the authentication log for analysis.                          | Investigate recent logins, SSH attempts, or suspicious activity.                                                     |
| | **2. `cat /etc/passwd \| less`**: Paginates the `/etc/passwd` file.                                  | Review user accounts incrementally without overwhelming the terminal.                                                |
| **`head`**             | Displays the first few lines of a file.                                        | Preview files to locate sensitive data quickly or confirm file relevance.                                            |
| | **1. `head -n 5 /etc/passwd`**: Displays the first 5 lines of `/etc/passwd`.                         | Identify initial entries, such as system and root accounts.                                                          |
| | **2. `head -n 10 /var/log/syslog`**: Displays the first 10 lines of the system log.                  | Review the start of logs for system initialization or errors.                                                        |
| **`tail`**             | Displays the last few lines of a file.                                         | Examine recent log entries or monitor live data updates.                                                             |
| | **1. `tail -n 10 /var/log/syslog`**: Displays the last 10 lines of the system log.                   | Investigate recent system activity or responses to an ongoing attack.                                                |
| | **2. `tail -f /var/log/auth.log`**: Monitors the authentication log in real-time.                   | Observe login attempts or SSH connections as they occur.                                                             |
| **`sort`**             | Sorts lines of text in a file or output.                                       | Organize data for better analysis, e.g., sorting user lists or log entries.                                          |
| | **1. `cat /etc/passwd \| sort`**: Sorts the `/etc/passwd` file alphabetically.                       | Identify patterns, duplicates, or anomalies in user account configurations.                                          |
| | **2. `cat logs.txt \| sort -n`**: Sorts log entries numerically.                                     | Analyze data with numerical values, such as timestamps or IDs, for trends or inconsistencies.                        |


#### Regex Filtering Commands 
This are regex filtering commands for attackers to understand the regex filtering, the regex filtering user, the regex filtering group, the regex filtering start time, the regex filtering end time, the regex filtering memory usage, the regex filtering CPU usage, the regex filtering command line, and the regex filtering arguments.
| **Command** | **Description** | **Attacker’s Perspective** |
| **`grep`** | Searches for patterns in text using regular expressions. | Leverage RegEx to extract specific data, validate inputs, or locate misconfigurations in files. |
| | **1. `grep -E "(my\|false)" /etc/passwd`**: Searches for lines containing "my" or "false". | Identify specific patterns in files for analysis or exploitation, e.g., misconfigured services or accounts. |
| | **2. `grep -E "(my.*false)" /etc/passwd`**: Searches for lines containing both "my" and "false". | Locate entries where multiple conditions overlap, useful for narrowing down potential vulnerabilities. |
| | **3. `grep -E "Permit.*" /etc/ssh/sshd_config`**: Searches for lines starting with "Permit". | Quickly identify SSH configuration parameters for validation or targeting misconfigurations. |
| | **4. `grep -E "Authentication$" /etc/ssh/sshd_config`**: Searches for lines ending with "Authentication". | Focus on specific configuration lines related to authentication mechanisms. |
| | **5. `grep -E "^Password.*yes$" /etc/ssh/sshd_config`**: Finds lines beginning with "Password" and ending with "yes". | Pinpoint insecure configurations like password authentication enabled in SSH settings. |
| | **6. `grep -v "#" /etc/ssh/sshd_config`**: Displays all non-commented lines. | Filter out comments to focus on active configuration entries for analysis or exploitation. |
| **`awk`**               | Processes text using pattern matching and field extraction.                    | Automate advanced RegEx-based filtering for extracting or manipulating data.                                         |
| | **1. `awk '/^Password.*yes$/' /etc/ssh/sshd_config`**: Finds lines starting with "Password" and ending with "yes". | Detect weak password-based authentication in SSH configurations.                                                     |
| | **2. `awk '/^[^#]/' /etc/ssh/sshd_config`**: Extracts lines that do not start with `#`.               | Quickly identify uncommented active configuration settings in target files.                                          |
| **`sed`**               | Stream editor for applying regular expressions to text.                        | Edit or transform text dynamically for obfuscation, persistence, or configuration manipulation.                      |
| | **1. `sed -n '/Permit/p' /etc/ssh/sshd_config`**: Prints lines containing "Permit".                   | Target specific SSH options to identify or exploit insecure settings.                                                |
| | **2. `sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config`**: Replaces "yes" with "no" for `PermitRootLogin`. | Exploit or fix insecure configurations dynamically during post-exploitation.                                         |
| **Regex Patterns**      | Standalone regular expressions for text searching or validation.               | Analyze complex data or extract information directly using patterns without relying on specific commands.            |
| | **1. `/^Permit.*$/`**: Matches lines starting with "Permit".                                          | Useful for analyzing configurations or policy files like `sshd_config`.                                              |
| | **2. `/yes$/`**: Matches lines ending with "yes".                                                     | Identify configurations that explicitly allow specific actions or permissions.                                        |
| | **3. `/^[^#]/`**: Matches lines that do not start with `#`.                                           | Filter active lines from configuration files by excluding comments.                                                  |
| | **4. `/[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+/`**: Matches email addresses.                  | Extract email addresses from files or logs for phishing campaigns or OSINT operations.                               |
| | **5. `/\b\d{3}-\d{2}-\d{4}\b/`**: Matches social security numbers (e.g., 123-45-6789).                | Locate sensitive data like SSNs in compromised datasets for further exploitation.                                     |
| **`find`**              | Uses regex-like patterns to locate files.                                       | Search for specific files or directories based on naming patterns or extensions.                                     |
| | **1. `find /etc -regex '.*\.conf$'`**: Finds all `.conf` files in `/etc`.                              | Locate configuration files that may contain sensitive information or misconfigurations.                              |
| | **2. `find / -regex '.*(shadow\|passwd)$' 2>/dev/null`**: Searches for files named `shadow` or `passwd`. | Enumerate critical system files for privilege escalation or data extraction.                                         |
| **`egrep`**             | Extended version of `grep` supporting more complex regex.                      | Simplify the use of advanced RegEx patterns in search operations.                                                    |
| | **1. `egrep -i "(error\|failed)" /var/log/syslog`**: Searches for lines containing "error" or "failed". | Quickly identify logs indicating vulnerabilities or attack surfaces.                                                 |
| | **2. `egrep "^\s*[^#]" /etc/ssh/sshd_config`**: Matches active lines ignoring leading whitespace.      | Focus on uncommented active configurations, even with irregular formatting.                                           |
| **Python Regex**        | Leverages Python for advanced regex processing.                                | Automate filtering, validation, or manipulation of large datasets programmatically.                                  |
| | **1. `re.findall(r'[0-9a-fA-F]{32}', text)`**: Finds 32-character MD5 hashes in a string.             | Extract potential credentials, API keys, or sensitive data from dumps or logs.                                       |
| | **2. `re.sub(r'(password: )\w+', r'\1REDACTED', text)`**: Replaces passwords with "REDACTED".         | Sanitize sensitive data in logs or outputs during post-exploitation.                                                 |


---

### File Manipulation Commands
This are file manipulation commands for attackers to understand the file manipulation, the file manipulation user, the file manipulation group, the file manipulation start time, the file manipulation end time, the file manipulation memory usage, the file manipulation CPU usage, the file manipulation command line, and the file manipulation arguments.

| **Command**   | **Description**                                                 | **Attacker’s Perspective**                                                                                      |
|---------------|---------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------|
| **`mv`**   | Move or rename files/directories.                               | Rename malicious binaries to blend in |
| | **1. `mv <src> <dest>`**: Move or rename a file or directory. |  <br> -Rename files for obfuscation.<br>- Relocate sensitive files to attacker-controlled directories. |
| | **2. `mv -r <src> <dest>`**: Recursively move or rename directories. | <br>- Move entire directories to attacker-controlled directories. |
| | **3. `mv -i <src> <dest>`**: Move or rename files, prompting before overwriting existing files. | <br>- Move files to attacker-controlled directories, prompting before overwriting existing files. |
| | **4. `mv /etc/passwd /etc/passwd.bak`**: Move or rename the passwd file. | <br>- Move Passwd file to attacker-controlled directories. |
| **`cp`** | Copy files/directories. | <br>- Duplicate sensitive files for exfiltration.<br>- Create backups of modified configs to revert changes later. |
| | **1. `cp /etc/passwd /etc/passwd.bak`**: Copy the passwd file. | <br>- Copy Passwd file to attacker-controlled directories. |
| | **2. `cp -r /etc/passwd /etc/passwd.bak`**: Recursively copy the passwd file. | <br>- Copy entire directories to attacker-controlled directories. |
| **`tar`**       | Archive and extract files (e.g., `.tar`, `.tar.gz`).          | Bundle data for exfiltration or create archives that appear benign but contain malicious payloads.              |
| | **1. `tar -czf secret.tar.gz /path/to/data`**: Create a gzipped tar archive.                      | Prepare large data sets (credentials, logs) for exfiltration or staging.                                        |
| **`nc (netcat)`**| Networking utility for reading/writing data across networks. | Create reverse shells, conduct port scans, or transfer files—often used as a quick backdoor or data exfil tool. |
| | **1. `nc -lvnp 4444`**: Start a listener on port 4444.                               | Establish a reverse shell from a compromised host for persistent remote access.                                |
| | **2. `nc -w 3 target 22`**: Test connectivity to target on port 22 (SSH).         | Quickly check if an SSH service is reachable or detect partial firewall blocks.                                |
| | **`touch <file>`**: Creates an empty file.                                                                                          | - Quickly create placeholder files for testing or to craft malicious payloads.<br>- Simulate legitimate activity.|
| | **1. `touch .hidden_payload`**: Creates an hiddent empty file. | Create hidden files with a leading dot to avoid casual detection. |
| **`rm` <file>** | Deletes a file. | - Remove traces of malicious activity.<br>- Delete legitimate files to disrupt the target system. |
| | **2. `rm -r <dir>`**: Recursively deletes a directory and its contents.                                                              | - Destroy evidence or disrupt services by removing critical directories.                                       |
| | **3. `rm -rf <dir>`**: Recursively deletes a directory and its contents.                                                              | - Destroy evidence or disrupt services by removing critical directories.                                       |
| | **4. `rm -rf /`**: Recursively deletes a directory and its contents.                                                              | - Destroy evidence or disrupt services by removing critical directories.                                       |
| | **5. `rm -rf /etc/passwd`**: Recursively deletes a directory and its contents.                                                              | - Destroy evidence or disrupt services by removing critical directories.                                       |

---

### File Permissions Commands
This are file permissions commands for attackers to understand the file permissions, the file permissions user, the file permissions group, the file permissions start time, the file permissions end time, the file permissions memory usage, the file permissions CPU usage, the file permissions command line, and the file permissions arguments.

| **Command**            | **Description**                                                    | **Attacker’s Perspective**                                                                                          |
|------------------------|--------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------|
| **`chmod`**            | Modify file permissions.                                          | Adjust permissions to facilitate attacks or prevent detection.                                                     |
| | **1. `chmod 777 /path/to/file`**: Grants read, write, and execute permissions to all users. | Allow universal access to files or directories, useful for staging tools or exfiltration points.                   |
| | **2. `chmod u+s /path/to/binary`**: Sets the SUID bit on a binary.                        | Create or exploit SUID binaries to execute commands as the file owner, often root, for privilege escalation.        |
| | **3. `chmod -x /path/to/script`**: Removes execute permissions from a script.            | Disable legitimate scripts temporarily to disrupt system functions or investigations.                              |
| | **4. `chmod o-w /etc/passwd`**: Removes write permissions for others on the passwd file. | Prevent unauthorized modifications by other users, maintaining control over sensitive files.                       |
| | **5. `chmod g+rwx /path/to/dir`**: Grants group read, write, and execute permissions on a directory. | Share directories with controlled access among specific users.                                                     |
| | **6. `chmod a+t /path/to/dir`**: Sets the sticky bit on a directory.                     | Prevent non-owners from deleting or renaming files in shared directories, ensuring persistence of important files.  |
| **`chown`**            | Change file or directory ownership.                               | Modify ownership to obscure traces or enable malicious activities under a different user context.                   |
| | **1. `chown root:root /path/to/file`**: Changes ownership to root user and group.         | Set files to appear legitimate or gain control over privileged files.                                              |
| | **2. `chown hacker:staff /path/to/binary`**: Changes ownership to the attacker’s user.    | Take ownership of critical binaries to ensure exclusive control.                                                   |
| | **3. `chown -R hacker:hacker /opt/malicious/`**: Recursively changes ownership of a directory. | Consolidate control over an entire directory structure for hiding tools or sensitive files.                        |
| **`umask`**            | Set default permissions for newly created files or directories.   | Adjust default permissions to create files with restrictive or overly permissive access based on attacker needs.     |
| | **1. `umask 000`**: Sets default permissions to allow full access to all users.          | Ensure that all newly created files are world-readable, writable, and executable for staging or exploitation.        |
| | **2. `umask 077`**: Sets default permissions to restrict access to the owner only.       | Secure attacker-controlled files to avoid discovery or interference by legitimate users.                            |
| **`ls -l`**            | Displays file permissions and ownership.                         | Analyze the permission and ownership of files to identify misconfigurations or escalation opportunities.             |
| | **1. `ls -l /etc/passwd`**: Checks permissions on the passwd file.                       | Identify if the passwd file is writable by unauthorized users.                                                      |
| | **2. `ls -la /var/www/html`**: Lists permissions for all files in a web server directory. | Locate files with weak permissions, such as upload directories or configuration files.                              |
| **`find`**             | Search for files based on permissions.                           | Locate files with exploitable permissions, SUID binaries, or sensitive data.                                        |
| | **1. `find / -perm -4000 2>/dev/null`**: Finds all files with the SUID bit set.          | Identify potential targets for privilege escalation.                                                                |
| | **2. `find /var/www/ -type f -perm 777 2>/dev/null`**: Finds world-writable files in the web root. | Exploit writable files for webshells or data injection.                                                             |
| | **3. `find /etc/ -type f -user root -perm -o+w 2>/dev/null`**: Finds files writable by others but owned by root. | Locate critical files with insecure permissions for tampering or exploitation.                                       |
| | **4. `find /tmp -type f -name "*.sh" -perm -u+x`**: Finds executable shell scripts in the `/tmp` directory. | Identify temporary scripts that could be leveraged for privilege escalation or persistence.                        |
| **`getfacl`**          | View Access Control List (ACL) for files and directories.        | Identify additional permissions set for specific users or groups.                                                   |
| | **1. `getfacl /path/to/file`**: Displays ACL for a file.                                 | Analyze ACLs to discover over-privileged users or exploitable configurations.                                        |
| **`setfacl`**          | Modify Access Control List (ACL) for files and directories.      | Add or remove permissions for specific users or groups.                                                             |
| | **1. `setfacl -m u:attacker:rwx /path/to/file`**: Grants read, write, and execute permissions to the attacker. | Establish direct access to files without modifying global permissions.                                               |
| | **2. `setfacl -x u:targetuser /path/to/file`**: Removes specific user's access to a file. | Disrupt legitimate access to secure persistence.                                                                     |
| **`stat`**             | Display detailed file information, including permissions.        | Gather detailed metadata on files, such as ownership, size, and access times.                                       |
| | **1. `stat /etc/passwd`**: Displays ownership, permissions, and timestamps for the passwd file. | Identify sensitive files and analyze for privilege escalation vectors.                                              |
| **`tune2fs`**          | Adjust filesystem settings, including reserved blocks.           | Manipulate reserved space or other filesystem settings for persistence or disruption.                               |
| | **1. `tune2fs -l /dev/sda1`**: Lists filesystem information, including owner and reserved blocks. | Identify filesystem settings that can be exploited or manipulated.                                                  |
| **`touch`**            | Create or update timestamps of files.                            | Quickly generate or modify files to manipulate access times and obscure activity.                                    |
| | **1. `touch /tmp/newfile`**: Creates an empty file.                                      | Create placeholder files for staging or persistence.                                                                |
| | **2. `touch -t 202201010101 /path/to/file`**: Sets a file's timestamp to a specific time. | Obfuscate activity by backdating or forward-dating files.                                                           |
| **`sticky bit`**       | Sets sticky bit on directories to secure file deletion.          | Prevent unauthorized deletion of files in shared directories.                                                       |
| | **1. `chmod +t /path/to/dir`**: Adds a sticky bit to a directory.                       | Protect critical files from being deleted by non-owners.                                                            |
| | **2. `ls -ld /tmp`**: Verifies if the sticky bit is set (indicated by `t`).             | Ensure shared directories like `/tmp` are secure for multi-user environments.                                       |

---


### File Descriptors and Redirections Commands
This are file descriptors and redirections commands for attackers to understand the file descriptors and redirections, the file descriptors and redirections user, the file descriptors and redirections group, the file descriptors and redirections start time, the file descriptors and redirections end time, the file descriptors and redirections memory usage, the file descriptors and redirections CPU usage, the file descriptors and redirections command line, and the file descriptors and redirections arguments.


| **Command**            | **Description**  | **Attacker’s Perspective** |
|------------------------|------------------|--------------------------|
| **`>`**                   | Redirects STDOUT to a file, overwriting it.                                                      | Capture standard output for documentation or exfiltration purposes.                                                         |
| | **1. `find /etc/ -name shadow > results.txt`**: Redirects STDOUT to a file.                                                | Store results from enumeration commands for further analysis.                                                               |
| **`>>`**                  | Redirects STDOUT to a file, appending the output.                                                | Append enumeration results or log activities without overwriting existing data.                                             |
| | **1. `find /etc/ -name passwd >> stdout.txt`**: Appends output to a file.                                                  | Maintain a continuous log of system exploration for persistence or later reference.                                         |
| **`2>`**                  | Redirects STDERR to a file.                                                                      | Suppress or isolate errors to avoid detection or clutter in output.                                                         |
| | **1. `find /etc/ -name shadow 2> stderr.txt`**: Redirects errors to a file.                                                | Capture error messages to analyze permission issues or debug unsuccessful commands.                                         |
| **`2>/dev/null`**         | Redirects STDERR to the null device, discarding errors.                                          | Suppress errors to maintain stealth during enumeration or attacks.                                                          |
| | **1. `find /etc/ -name shadow 2>/dev/null`**: Suppresses errors.                                                           | Hide "Permission denied" errors to avoid drawing attention during reconnaissance.                                           |
| **`1>`**                  | Explicitly redirects STDOUT to a file.                                                           | Direct standard output to specific files for precise control.                                                               |
| | **1. `find /etc/ -name shadow 1> stdout.txt`**: Redirects STDOUT to a file.                                                | Separate standard output for clean logging or analysis.                                                                    |
| **`<`**                   | Redirects STDIN from a file.                                                                     | Use predefined input for commands, simulating interactive input or automating tasks.                                        |
| | **1. `cat < stdout.txt`**: Redirects input from a file to the `cat` command.                                               | Review the content of previously captured output files.                                                                     |
| **`<<`**                  | Redirects a stream of input (here-doc) to a file or command.                                     | Use custom input streams for crafting payloads or commands dynamically.                                                     |
| | **1. `cat << EOF > stream.txt`**: Writes a stream of input to a file.                                                      | Save arbitrary input to files for later use or crafting scripts during exploitation.                                         |
| **`\|` (Pipe)**            | Redirects STDOUT from one command to another for further processing.                             | Chain commands to filter, process, or manipulate output efficiently.                                                        |
| | **1. `find /etc/ -name *.conf 2>/dev/null \| grep systemd`**: Filters output for lines containing "systemd".                   | Narrow results to target specific configurations or files of interest.                                                      |
| | **2. `find /etc/ -name *.conf 2>/dev/null \| grep systemd \| wc -l`**: Counts the filtered results.                             | Quantify findings to assess the size of attackable surfaces or validate enumeration success.                                |
| **`2>&1`**               | Redirects STDERR to the same destination as STDOUT.                                              | Combine both outputs for comprehensive logging or analysis.                                                                 |
| | **1. `find /etc/ -name shadow > combined.txt 2>&1`**: Redirects STDOUT and STDERR to the same file.                        | Collect all output in one place to avoid missing important data.                                                            |
| **More Examples** | **More Commands Examples** | **Attacker's Perspective** |
| **`find /etc/ -name shadow 2>/dev/null`** | Redirects STDERR to the null device, discarding errors. | Hide "Permission denied" errors during directory traversal. |
| **`find /etc/ -name shadow > results.txt`** | Redirects STDOUT to a file. | Store reconnaissance findings for offline analysis or reporting. |
| **`find /etc/ -name shadow > combined.txt 2>&1`** | Redirects STDOUT and STDERR to the same file. | Collect all output in one place to avoid missing important data. |
| **`find /etc/ -name *.conf 2>/dev/null \| grep systemd \| wc -l`** | Filters output for lines containing "systemd". | Narrow results to target specific configurations or files of interest <br>-Identify, filter, and quantify specific results in one step. |


---

### User Management Commands
This are user management commands for attackers to understand the user management, the user management user, the user management group, the user management start time, the user management end time, the user management memory usage, the user management CPU usage, the user management command line, and the user management arguments.

| **Command**           | **Description**                                                                                   | **Attacker’s Perspective**                                                                                                   |
|-----------------------|---------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------|
| **`sudo`**            | Executes commands as another user, typically the superuser (root).                                | Exploit misconfigured `sudo` permissions to escalate privileges or access restricted files.                                |
| | **1. `sudo cat /etc/shadow`**: View the shadow file for password hashes.                                                 | Extract password hashes for cracking or offline analysis.                                                                 |
| | **2. `sudo -l`**: List the commands a user can run with `sudo`.                                                          | Identify commands that allow privilege escalation or unintended system access.                                             |
| **`su`**              | Switches to another user account, requiring their password unless already root.                   | Gain access to a different user account for privilege escalation or lateral movement.                                      |
| | **1. `su root`**: Switch to the root user.                                                                               | Exploit known credentials to gain full system control.                                                                    |
| | **2. `su - hacker`**: Switch to the "hacker" user.                                                                               | Exploit known credentials to gain full system control.                                                                    |
| **`useradd`**         | Creates a new user account.                                                                       | Add new backdoor accounts to maintain access.                                                                              |
| | **1. `sudo useradd hacker`**: Create a new user account named "hacker".                                                 | Create a hidden or privileged user account for persistence.                                                               |
| | **2. `sudo useradd -m -s /bin/bash attacker`**: Create a user with a home directory and Bash shell.                      | Establish a usable and persistent account for future exploitation.                                                        |
| **`userdel`**         | Deletes a user account.                                                                           | Remove unwanted or compromised accounts to prevent detection.                                                             |
| | **1. `sudo userdel -r hacker`**: Remove the user "hacker" and their home directory.                                      | Cleanup traces of created accounts after exploitation.                                                                    |
| **`usermod`**         | Modifies user accounts.                                                                           | Change user privileges or group memberships for privilege escalation or persistence.                                       |
| | **1. `sudo usermod -aG sudo hacker`**: Add the user "hacker" to the `sudo` group.                                        | Grant administrative privileges to a backdoor account.                                                                    |
| | **2. `sudo usermod -L user`**: Lock the "user" account.                                                                 | Prevent legitimate users from accessing the system while maintaining control.                                             |
| **`addgroup`**        | Creates a new group.                                                                              | Create custom groups to manage user permissions or mask activities.                                                       |
| | **1. `sudo addgroup attackers`**: Add a group named "attackers".                                                        | Create hidden or suspicious groups for privilege escalation or control.                                                   |
| **`delgroup`**        | Removes an existing group.                                                                        | Clean up created groups to erase traces of activity.                                                                      |
| | **1. `sudo delgroup attackers`**: Remove the group "attackers".                                                         | Avoid detection by deleting unnecessary groups after use.                                                                 |
| **`passwd`**          | Changes a user's password.                                                                        | Reset or manipulate user passwords for privilege escalation or denial of access.                                          |
| | **1. `sudo passwd root`**: Change the root user’s password.                                                             | Regain access to root control if compromised or escalate privileges.                                                      |
| | **2. `passwd hacker`**: Change the "hacker" user’s password.                                                            | Maintain control over a created or compromised user account.                                                              |
| **`id`**              | Displays the user ID (UID) and group IDs (GIDs) of the current user.                              | Identify the current user context and privileges for further exploitation.                                                |
| | **1. `id`**: Display the user and group information for the current session.                                            | Verify whether privilege escalation has succeeded.                                                                        |
| **`whoami`**          | Displays the username of the current user.                                                       | Confirm the active user account during post-exploitation.                                                                 |
| **`groups`**          | Lists all groups a user belongs to.                                                              | Identify groups with elevated privileges (e.g., `sudo`, `docker`) for privilege escalation.                               |
| | **1. `groups hacker`**: List the groups the "hacker" user belongs to.                                                   | Check the privileges of a created or compromised account.                                                                 |
| **`last`**            | Shows the login history of users.                                                                | Review user activity and identify potential accounts to target for attacks.                                               |
| | **1. `last root`**: Display the login history for the root user.                                                        | Investigate root activity for vulnerabilities or configuration errors.                                                    |
| **`finger`**          | Displays user information, including login names, directories, and shells.                       | Enumerate detailed information about users for reconnaissance.                                                           |
| | **1. `finger hacker`**: View details of the "hacker" user.                                                              | Validate account creation or investigate compromised accounts.                                                            |



---


### Package Management Commands
This are package management commands for attackers to understand the package management, the package management user, the package management group, the package management start time, the package management end time, the package management memory usage, the package management CPU usage, the package management command line, and the package management arguments.

| **Command**              | **Description**                                                                                       | **Attacker’s Perspective**                                                                                               |
|--------------------------|-------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------|
| **`apt`**                | High-level command-line interface for managing Debian packages.                                       | Install tools or exploit vulnerable packages.<br>- Example: `sudo apt install nmap` to add reconnaissance tools.       |
| | **1. `apt update`**    | Updates the package list from repositories.                                                          | Ensure access to the latest versions of tools for attacks or exploitation.                                             |
| | **2. `apt list --installed`** | Lists installed packages.                                                                     | Identify installed software and pinpoint outdated or vulnerable versions.                                              |
| | **3. `apt-cache search <keyword>`** | Searches for packages by keyword.                                                       | Discover software libraries or utilities for exploitation or reconnaissance.                                           |
| | **4. `apt-cache show <package>`** | Displays details of a package, including dependencies and repository information.          | Analyze package metadata to identify weaknesses or opportunities for exploitation.                                      |
| **`aptitude`**           | High-level interface to the APT package manager.                                                     | Simplifies package management with additional features like better dependency handling.                                 |
| | **1. `aptitude search <package>`** | Searches for a package by name or description.                                         | Locate specific packages for installation or reconnaissance.                                                           |
| | **2. `aptitude install <package>`** | Installs a package and automatically resolves dependencies.                           | Quickly deploy tools while minimizing dependency-related issues.                                                        |
| | **3. `aptitude remove <package>`** | Removes a package and its associated configuration files.                              | Clean up traces of installed tools after exploitation.                                                                 |
| | **4. `aptitude show <package>`** | Displays detailed information about a package.                                          | Gain insights into dependencies, maintainers, and potential vulnerabilities.                                           |
| | **5. `aptitude update`** | Updates the package database from configured repositories.                                         | Ensure package metadata is up-to-date for the latest versions or dependencies.                                          |
| | **6. `aptitude upgrade`** | Upgrades all installed packages to the latest available versions.                                | Exploit or maintain persistence by ensuring dependencies for attack tools are current.                                  |
| **`dpkg`**               | Low-level tool for managing Debian packages.                                                         | Directly install or inspect `.deb` packages for offline or targeted installations.                                      |
| | **1. `dpkg -i <package>.deb`** | Installs a `.deb` package from a local file.                                                | Deploy tools or backdoors without connecting to the internet.                                                          |
| | **2. `dpkg --list`**   | Lists installed packages.                                                                            | Enumerate installed software for reconnaissance or privilege escalation vectors.                                        |
| | **3. `dpkg -r <package>`** | Removes a package.                                                                                | Cleanup traces or unwanted software after exploitation.                                                                |
| **`snap`**               | Manages snap packages for universal Linux apps.                                                      | Install portable applications with minimal dependency management.                                                      |
| | **1. `snap install <package>`** | Installs a snap package.                                                                   | Quickly deploy tools or utilities for exploitation.                                                                    |
| | **2. `snap list`**     | Lists installed snap packages.                                                                       | Enumerate software installed via snap to identify vulnerabilities.                                                     |
| **`gem`**                | Ruby package manager for installing Ruby libraries and tools.                                         | Deploy Ruby-based tools for exploitation or automation.                                                                |
| | **1. `gem install <package>`** | Installs a Ruby package.                                                                     | Install Ruby-based frameworks or libraries like Metasploit or Evil-WinRM.                                              |
| **`pip`**                | Python package installer for managing Python libraries.                                              | Install Python-based tools for automation, exploitation, or payload creation.                                          |
| | **1. `pip install <package>`** | Installs a Python package.                                                                  | Use Python-based tools like Impacket for reconnaissance or post-exploitation tasks.                                    |
| | **2. `pip freeze > requirements.txt`** | Exports installed Python packages to a file.                                       | Track or replicate environments for repeatable exploitation setups.                                                    |
| **`git`**                | Distributed version control system used for managing repositories.                                    | Clone and deploy malicious or exploitative tools from public or private repositories.                                   |
| | **1. `git clone <repository>`** | Clones a repository.                                                                       | Retrieve tools like Nishang or Empire for post-exploitation tasks.                                                     |
| | **2. `git clone https://github.com/Hackplayers/evil-winrm.git ~/tools/evil-winrm`** | Clones the Evil-WinRM repository into a "tools" directory. | Deploy Evil-WinRM for post-exploitation or remote access to Windows systems.                                            |
| **`wget`**               | Downloads files from the internet.                                                                   | Retrieve malicious payloads, exploits, or configuration files.                                                         |
| | **1. `wget <url>`**    | Downloads a file from the specified URL.                                                            | Quickly deploy tools or files for exploitation, e.g., downloading `.deb` files for offline installation.               |
| **`curl`**               | Transfers data from a server using various protocols (HTTP, FTP, etc.).                              | Automate downloads or interact with APIs for reconnaissance or exploitation.                                           |
| | **1. `curl -O <url>`** | Downloads a file from a URL.                                                                         | Automate retrieval of tools or data for exploitation.                                                                  |
| **`mkdir`**              | Creates directories for organizing downloaded packages or repositories.                              | Organize downloaded tools or data for easier deployment or exploitation.                                               |
| | **1. `mkdir ~/tools`** | Creates a "tools" directory in the user's home folder.                                              | Organize exploits, payloads, or reconnaissance tools.                                                                  |
| **`tar`**                | Archives and compresses files or directories.                                                        | Package tools or data for easier transfer or deployment.                                                               |

---

### Task Scheduling Commands
This are task scheduling commands for attackers to understand the task scheduling, the task scheduling user, the task scheduling group, the task scheduling start time, the task scheduling end time, the task scheduling memory usage, the task scheduling CPU usage, the task scheduling command line, and the task scheduling arguments.

| **Command**                  | **Description**                                                                                       | **Attacker’s Perspective**                                                                                              |
|------------------------------|-------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------|
| **`systemctl`**              | Manages `systemd` services and timers.                                                               | Exploit timers or services to establish persistence or execute malicious scripts.                                      |
| | **1. `systemctl start mytimer.timer`** | Starts the `mytimer.timer` service immediately.                                              | Test or execute malicious payloads on-demand.                                                                         |
| | **2. `systemctl enable mytimer.timer`** | Enables the timer to start automatically on boot.                                            | Set up persistent execution for malicious scripts at defined intervals.                                               |
| | **3. `systemctl daemon-reload`**       | Reloads `systemd` configurations after changes.                                              | Ensure modifications to `systemd` timers or services take effect.                                                     |
| **`crontab`**                | Manages cron jobs for scheduling repetitive tasks.                                                   | Schedule malicious payloads for persistence or data exfiltration.                                                     |
| | **1. `crontab -e`**       | Edits the current user's crontab file.                                                              | Add stealthy cron jobs to execute backdoors or exfiltrate data.                                                       |
| | **2. `crontab -l`**       | Lists the current user's cron jobs.                                                                 | Identify and analyze existing cron jobs for misconfigurations or targets.                                             |
| | **3. `crontab -r`**       | Removes all cron jobs for the current user.                                                         | Clean up traces of malicious cron jobs after exploitation.                                                            |
| **Cron Example**             | **Task**: Adds a cron job to execute a script every hour.                                            | Exploit cron for automated persistence.                                                                               |
| | `0 * * * * /path/to/malicious_script.sh` | Executes `malicious_script.sh` at the start of every hour.                                   | Automate execution of scripts for continuous exploitation or disruption.                                              |
| **Systemd Timer Example**    | **Task**: Configures a systemd timer to run a malicious script.                                      | Use systemd for stealthier, event-based task scheduling.                                                              |
| | **Timer**: `/etc/systemd/system/mytimer.timer`                                                                                   | Sets up a timer to execute tasks.                                                                                     |
| | **Service**: `/etc/systemd/system/mytimer.service`                                                                                | Specifies the script to execute when the timer triggers.                                                              |
| | **Command**: `OnBootSec=1min`                                                                                                    | Executes the script 1 minute after boot.                                                                              |
| **`at`**                     | Schedules a one-time task to run at a specified time.                                                | Quickly set up time-based execution of scripts without persistent configurations.                                      |
| | **1. `echo "/path/to/malicious_script.sh" | at now + 5 minutes`** | Schedules a script to run in 5 minutes.                                         | Use for one-off execution of malicious payloads without leaving traces in `crontab` or `systemd`.                     |
| **`anacron`**                | Executes periodic tasks that may have been missed due to system downtime.                           | Use for guaranteed execution of payloads even if the system is not running during the scheduled time.                  |
| | **1. `/etc/anacrontab`**   | Specifies tasks and intervals (daily, weekly, monthly).                                             | Modify anacron jobs to ensure malicious scripts are executed reliably over time.                                       |
| **`journalctl`**             | Views logs for `systemd` services and timers.                                                       | Analyze logs to verify if malicious timers or services were triggered successfully.                                    |
| | **1. `journalctl -u mytimer.service`** | Displays logs for the `mytimer.service`.                                                    | Monitor execution of malicious services or timers.                                                                    |
| **Cron Logging Example**     | Configures cron to log output to a file.                                                            | Use logs to monitor execution of malicious cron jobs and debug issues.                                                |
| | **Command**: `* * * * * /path/to/malicious_script.sh >> /var/log/cron.log 2>&1`                                                  | Captures both output and errors from the script to `cron.log`.                                                        |
| **Task Example**: **"Backup Script Automation"** | Automates periodic execution of a script.                                                 | Replace benign scripts with malicious versions to escalate privileges or exfiltrate data during scheduled execution.   |



---
### Network Services Commands
This are network services commands for attackers to understand the network services, the network services user, the network services group, the network services start time, the network services end time, the network services memory usage, the network services CPU usage, the network services command line, and the network services arguments.

| **Service**         | **Command**                                       | **Description**                                                                                         | **Attacker’s Perspective**                                                                                     |
|---------------------|---------------------------------------------------|---------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------|
| **SSH**             | **`sudo apt install openssh-server -y`**          | Installs the OpenSSH server.                                                                            | Set up SSH on compromised machines to maintain persistent access.                                             |
|                     | **`systemctl status ssh`**                        | Checks the status of the SSH server.                                                                    | Verify if SSH is running on the target system for exploitation.                                               |
|                     | **`ssh <user>@<host>`**                           | Connects to a remote system via SSH.                                                                    | Securely interact with compromised hosts or pivot between internal systems.                                    |
|                     | **`echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && systemctl restart ssh`** | Enables root login over SSH. | Enable root access to escalate privileges or simplify persistent access. |
| **NFS**             | **`sudo apt install nfs-kernel-server -y`**       | Installs the NFS kernel server.                                                                         | Exploit NFS shares for privilege escalation or data exfiltration.                                             |
|                     | **`cat /etc/exports`**                            | Displays the current NFS shares and permissions.                                                        | Identify writable or insecure shares to access sensitive data or deploy tools.                                |
|                     | **`mount <host>:/<remote_dir> <local_dir>`**      | Mounts a remote NFS share locally.                                                                      | Access remote directories as if they were local, facilitating data exfiltration or reconnaissance.            |
|                     | **`echo "/home/user/share *(rw,sync,no_root_squash)" >> /etc/exports && exportfs -a`** | Shares a directory with write permissions and no root restrictions. | Misconfigure NFS shares to allow unauthorized access.                                                         |
| **Web Servers**     | **`sudo apt install apache2 -y`**                 | Installs the Apache web server.                                                                         | Use Apache to host phishing pages or transfer files to compromised systems.                                   |
|                     | **`echo '<h1>Hacked</h1>' > /var/www/html/index.html`** | Modifies the default webpage.                                                                           | Deface websites or host malicious content for phishing attacks.                                               |
|                     | **`python3 -m http.server 8000`**                 | Starts a Python web server on port 8000.                                                                | Quickly transfer tools or files to and from target systems.                                                   |
|                     | **`python3 -m http.server --directory /tmp 443`** | Hosts a specific directory over HTTPS.                                                                  | Use for covert file transfers over encrypted channels.                                                        |
| **VPN**             | **`sudo apt install openvpn -y`**                 | Installs OpenVPN.                                                                                       | Use OpenVPN to connect to internal networks for penetration testing.                                           |
|                     | **`sudo openvpn --config <config_file>.ovpn`**    | Connects to an OpenVPN server using a configuration file.                                               | Establish a secure connection to internal networks provided by the client.                                    |
| **FTP**             | **`sudo apt install vsftpd -y`**                  | Installs the VSFTPD (FTP) server.                                                                       | Exploit plaintext credentials or host a malicious FTP server for exfiltration.                                |
|                     | **`systemctl start vsftpd`**                      | Starts the FTP service.                                                                                 | Enable FTP services for data transfer or reconnaissance.                                                      |
|                     | **`echo "anonymous_enable=YES" >> /etc/vsftpd.conf && systemctl restart vsftpd`** | Enables anonymous FTP access. | Misconfigure FTP servers to allow unauthorized access for reconnaissance or exploitation.                     |

---

### Backup and Restore Commands
This are backup and restore commands for attackers to understand the backup and restore, the backup and restore user, the backup and restore group, the backup and restore start time, the backup and restore end time, the backup and restore memory usage, the backup and restore CPU usage, the backup and restore command line, and the backup and restore arguments.

| **Command**                          | **Description**                                                                                       | **Attacker’s Perspective**                                                                                           |
|--------------------------------------|-------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------|
| **`rsync`**                          | Synchronizes files and directories between two locations.                                             | Use for automated data exfiltration or synchronizing malicious files to a remote server.                            |
| | **1. `rsync -av /path/to/source /path/to/destination`** | Synchronizes files, preserving attributes and providing verbose output.                            | Exfiltrate sensitive data while keeping metadata intact for analysis.                                               |
| | **2. `rsync -avz --backup --delete /path/to/source user@remote:/backup/dir`** | Creates compressed, incremental backups with deleted files removed.                                | Maintain stealthy backups of modified or deleted sensitive files for later exploitation.                            |
| | **3. `rsync -avz -e ssh /path/to/source user@remote:/backup/dir`** | Securely synchronizes files over an encrypted SSH connection.                                       | Exfiltrate files securely without being intercepted over the network.                                               |
| **`duplicity`**                      | Creates encrypted, compressed backups to local or remote destinations.                               | Exploit misconfigurations in encrypted backups to extract sensitive data.                                           |
| | **1. `duplicity /source/dir file:///backup/dir`** | Creates a local encrypted backup.                                                                  | Investigate backup configurations for weak encryption keys or file paths.                                           |
| **`deja-dup`**                       | Simplifies the backup process with a graphical interface for local or remote backups.                | Exploit default configurations to access backup files or manipulate data.                                           |
| **`scp`**                            | Securely copies files between hosts over SSH.                                                        | Use as an alternative to rsync for secure file exfiltration or retrieval.                                           |
| | **1. `scp user@remote:/backup/dir /local/dir`** | Copies files from a remote backup server to the local system.                                      | Retrieve valuable files from a compromised backup server.                                                           |
| **`tar`**                            | Archives and compresses files into a single file.                                                    | Bundle and compress files for easier exfiltration or analysis.                                                      |
| | **1. `tar -czf backup.tar.gz /path/to/data`** | Creates a compressed archive of the specified directory.                                           | Extract and analyze bundled sensitive files for exploitation.                                                       |
| **`chmod`**                          | Modifies permissions for backup scripts or files.                                                    | Grant executable permissions to malicious scripts hidden in backup processes.                                       |
| | **1. `chmod +x RSYNC_Backup.sh`** | Enables execution of an rsync backup script.                                                        | Weaponize backup scripts to execute malicious commands during scheduled jobs.                                        |
| **`cron`**                           | Automates tasks by scheduling jobs at specific intervals.                                             | Exploit scheduled backups to introduce malicious scripts or backdoors.                                              |
| | **1. `0 * * * * /path/to/RSYNC_Backup.sh`** | Schedules an rsync backup script to run every hour.                                                | Modify scheduled cron jobs to execute attacker-controlled scripts.                                                  |
| **`ssh`**                            | Provides secure remote access and file transfer.                                                     | Establish encrypted connections for data exfiltration or manipulation.                                              |
| **`wget`**                           | Downloads files from the internet, often used in backup automation scripts.                          | Download malicious payloads disguised as legitimate backups.                                                        |
| | **1. `wget <url>`** | Retrieves files or scripts from a specified URL.                                                                | Replace backup scripts with attacker-controlled versions hosted remotely.                                            |
| **`find`**                           | Searches for backup files or scripts on the system.                                                  | Locate sensitive backup data or poorly secured backup scripts for exploitation.                                      |
| | **1. `find / -name "*.tar.gz" 2>/dev/null`** | Searches for compressed backup files across the filesystem.                                       | Identify potential targets for extracting sensitive data.                                                           |
| **`cat`**                            | Displays the contents of backup-related configuration files.                                         | Examine configuration files for credentials, paths, or misconfigurations.                                           |
| | **1. `cat /etc/crontab`** | Displays scheduled cron jobs.                                                                             | Analyze backup schedules for potential exploitation opportunities.                                                  |

---
### File System Management Commands
This are file system management commands for attackers to understand the file system management, the file system management user, the file system management group, the file system management start time, the file system management end time, the file system management memory usage, the file system management CPU usage, the file system management command line, and the file system management arguments.

| **Command**             | **Description**                                                                                     | **Attacker’s Perspective**                                                                                         |
|-------------------------|---------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------|
| **`ls -il`**            | Displays detailed file listing with inode numbers.                                                | Use inode numbers to analyze file metadata or bypass standard file paths for hidden files.                       |
| **`fdisk`**             | Manages disk partitions (create, delete, modify).                                                 | Analyze disk structure to find sensitive partitions or unused space for storing malicious tools.                  |
| | **1. `sudo fdisk -l`** | Lists all available disks and their partitions.                                                  | Identify disk layouts and unused partitions for exploitation or hiding data.                                      |
| | **2. `sudo fdisk /dev/sdb`** | Opens the interactive mode to edit partitions on `/dev/sdb`.                               | Alter partition tables to disrupt legitimate operations or create hidden partitions for persistent storage.       |
| **`mkfs`**              | Formats a partition with a specific file system.                                                  | Format unused space to create attacker-controlled partitions with desired file systems.                           |
| | **1. `sudo mkfs.ext4 /dev/sdb1`** | Formats `/dev/sdb1` with the ext4 file system.                                         | Prepare a partition for storing tools or staging areas for exploitation.                                          |
| **`mount`**             | Attaches a file system to a directory.                                                            | Mount external drives or sensitive partitions to access restricted data.                                          |
| | **1. `sudo mount /dev/sdb1 /mnt/usb`** | Mounts `/dev/sdb1` to `/mnt/usb`.                                                 | Access removable drives or hidden partitions for data extraction or staging malicious files.                      |
| **`umount`**            | Unmounts a file system from a directory.                                                          | Safely detach drives or partitions to avoid detection or cleanup after exploitation.                              |
| | **1. `sudo umount /mnt/usb`** | Unmounts the USB drive mounted at `/mnt/usb`.                                             | Hide evidence of mounted drives after accessing sensitive data.                                                   |
| **`blkid`**             | Displays UUIDs and other details for block devices.                                               | Identify devices by UUID for crafting custom mount points in `/etc/fstab` for persistence.                       |
| **`df`**                | Reports disk usage of mounted file systems.                                                       | Locate partitions with insufficient monitoring or space for storing malicious payloads.                           |
| | **1. `df -h`**         | Displays human-readable disk usage for all mounted partitions.                                   | Analyze available space for exploitation or staging purposes.                                                     |
| **`du`**                | Estimates file or directory space usage.                                                          | Identify large files or directories that may hold valuable data or staging space.                                 |
| | **1. `du -sh /var`**   | Summarizes the size of the `/var` directory.                                                    | Detect directories with extensive logs or cache files for reconnaissance or tampering.                            |
| **`lsof`**              | Lists open files by processes.                                                                    | Identify processes holding files or drives in use to understand system activity or kill blocking processes.       |
| | **1. `lsof | grep /mnt/usb`** | Lists processes accessing `/mnt/usb`.                                                   | Ensure safe unmounting of drives or detect active usage of targeted directories.                                   |
| **`swapon`**            | Activates a swap space for use by the system.                                                     | Use swap activation on custom partitions to influence memory management or hibernation states.                    |
| | **1. `sudo swapon /dev/sdb2`** | Activates swap on `/dev/sdb2`.                                                          | Exploit swap areas for indirect access to sensitive data stored temporarily in memory.                            |
| **`mkswap`**            | Sets up a Linux swap area on a partition or file.                                                 | Create new swap areas to influence system performance or persistence strategies.                                   |
| | **1. `sudo mkswap /dev/sdb2`** | Creates a swap area on `/dev/sdb2`.                                                     | Prepare a dedicated partition for potential exploitation or data tampering.                                       |
| **`cat /etc/fstab`**    | Displays static file system mount configurations.                                                 | Identify auto-mounted drives or modify entries for persistence or exfiltration.                                   |
| **`fsck`**              | Checks and repairs file systems.                                                                  | Exploit corrupted file systems for privilege escalation or leave behind damage to disrupt system recovery.         |
| | **1. `sudo fsck /dev/sdb1`** | Repairs the file system on `/dev/sdb1`.                                                  | Analyze or manipulate system integrity during recovery operations.                                                |

---

### Containerization Commands
This are containerization commands for attackers to understand the containerization, the containerization user, the containerization group, the containerization start time, the containerization end time, the containerization memory usage, the containerization CPU usage, the containerization command line, and the containerization arguments.

| **Command**              | **Description**                                                                                     | **Attacker’s Perspective**                                                                                         |
|--------------------------|-----------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------|
| **`docker`**             | Manage Docker containers, images, and services.                                                    | Leverage Docker to run malicious tools or host payloads for exploitation.                                         |
| | **1. `docker ps`**     | Lists running containers.                                                                           | Enumerate active containers to identify services or exploitable environments.                                      |
| | **2. `docker run -p <host port>:<container port> <image>`** | Runs a container with port mappings.                                          | Host malicious files or tools accessible via specific ports.                                                      |
| | **3. `docker exec -it <container> /bin/bash`** | Executes a shell inside a running container.                                    | Gain interactive access to a container for enumeration or tampering.                                              |
| | **4. `docker logs <container>`** | Displays logs from a container.                                                             | Extract sensitive information or credentials from container logs.                                                 |
| **`docker-compose`**     | Automates the deployment and management of multi-container Docker applications.                     | Deploy complex environments for testing or exploitation with minimal setup.                                        |
| | **1. `docker-compose up`** | Starts and runs containers defined in a `docker-compose.yml` file.                             | Quickly deploy custom multi-container setups for hosting or testing.                                              |
| | **2. `docker-compose down`** | Stops and removes containers defined in a `docker-compose.yml` file.                         | Clean up traces after malicious use or testing.                                                                   |
| **`lxc`**                | Manage Linux Containers (LXC) for lightweight virtualization.                                       | Exploit isolated LXC environments for testing or evade detection during operations.                               |
| | **1. `lxc-create -n <name> -t <template>`** | Creates a new LXC container with a specified template.                                   | Spin up isolated environments to test exploits or vulnerabilities.                                                |
| | **2. `lxc-start -n <container>`** | Starts a stopped LXC container.                                                            | Activate containers for reconnaissance or payload deployment.                                                     |
| | **3. `lxc-attach -n <container>`** | Connects to a running container.                                                          | Gain interactive access for manipulation or testing.                                                              |
| | **4. `lxc-config -n <container> -s <setting>`** | Configures container settings (e.g., network, storage, security).                        | Modify LXC configurations for resource abuse or isolation evasion.                                                |
| **`docker build`**       | Builds a Docker image from a Dockerfile.                                                           | Create custom container environments for hosting malicious tools or testing payloads.                              |
| | **1. `docker build -t <image> .`** | Builds a Docker image with a tag.                                                         | Create identifiable images for reuse in testing or exploitation.                                                  |
| **`docker rm`**          | Removes Docker containers.                                                                          | Clean up after malicious activity or avoid detection.                                                             |
| **`docker rmi`**         | Removes Docker images.                                                                              | Remove traces of malicious images or reset environments.                                                          |
| **`lxc-ls`**             | Lists all existing LXC containers.                                                                 | Identify running containers and evaluate their configurations for vulnerabilities.                                |
| **`wget`**               | Downloads files from the internet.                                                                 | Retrieve Docker or LXC images directly from external repositories.                                                |
| | **1. `wget <URL>`**    | Downloads a file from a URL.                                                                        | Fetch external scripts or files needed for container setup or exploitation.                                        |
| **`docker pull`**        | Downloads a Docker image from a registry like Docker Hub.                                           | Fetch pre-made images for malicious use or reconnaissance purposes.                                               |
| | **1. `docker pull <image>`** | Downloads the specified Docker image.                                                         | Quickly obtain tools or templates for container deployment.                                                       |
| **Security Settings**    | Restrict container capabilities or access.                                                         | Misconfigured settings may allow privilege escalation or host compromise.                                          |
| | **1. `docker run --privileged`** | Runs a container with elevated privileges.                                                | Exploit privileged containers to execute commands directly on the host system.                                     |
| | **2. `lxc.cgroup.*` settings** | Limit resource usage for LXC containers (e.g., CPU, memory).                                | Misconfigured limits can allow resource abuse or evasion of monitoring.                                            |
| **Namespace Isolation**  | Separates container resources from the host.                                                       | Exploit namespace misconfigurations to access host resources or escape containment.                                |
| | **1. `docker run --network host`** | Runs a container on the host network.                                                     | Avoid network isolation, enabling access to host-level network configurations and services.                        |
| **Git Example**          | Clones a repository for container setup or exploitation.                                           | Clone repositories to fetch container-specific tools or exploit scripts.                                           |
| | **1. `git clone https://github.com/Hackplayers/evil-winrm.git ~/tools/evil-winrm`** | Fetches the Evil-WinRM tool for testing.                                     | Deploy tools for remote access or further exploitation.                                                           |

---


### Linux Network Configuration Commands (Attacker Perspective)
1. **Configuration Commands**: Directly enable interface setup and routing manipulation.
2. **Monitoring and Troubleshooting**: Tools like `tcpdump` and `ping` offer insights into traffic and connectivity.
3. **Access Control and Hardening**: Commands like `getenforce` and editing `/etc/hosts.allow` demonstrate real-worl


| **Command/Tool**        | **Description**                                                                                                                                  | **Attacker’s Perspective**                                                                                                                                                     |
|-------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **`ifconfig`**          | Displays and configures network interfaces (deprecated).                                                                                        | - Enumerate network interfaces and their configurations.<br>- Modify settings to bypass restrictions or enable malicious communication.                                       |
| | **1. `ifconfig eth0 up`**: Activates the `eth0` interface.                                                                                                              | Reactivate disabled interfaces for enumeration or exfiltration.                                                                                                               |
| | **2. `ifconfig eth0 192.168.1.2`**: Assigns an IP address to `eth0`.                                                                                                    | Spoof IP addresses for anonymity or bypassing MAC-based access controls.                                                                                                      |
| | **3. `ifconfig eth0 hw ether <new_mac>`**: Changes the MAC address.                                                                                                     | Spoof MAC addresses to evade detection or bypass NAC.                                                                                                                         |
| **`ip`**                | Modern alternative to `ifconfig` for network configuration.                                                                                     | - Granular control over network interfaces and routes.<br>- Perform advanced configurations for exploitation or stealth.                                                      |
| | **1. `ip addr`**: Displays IP addresses for all interfaces.                                                                                                            | Enumerate detailed network configurations for reconnaissance.                                                                                                                 |
| | **2. `ip link set eth0 up`**: Activates the `eth0` interface.                                                                                                          | Enable interfaces for scanning or malicious communication.                                                                                                                    |
| | **3. `ip route add default via <gateway_ip>`**: Sets a default gateway.                                                                                                | Manipulate routing for MITM attacks or data exfiltration.                                                                                                                     |
| **`route`**             | Displays or modifies the IP routing table.                                                                                                     | - Redirect traffic to malicious servers.<br>- Add or manipulate routes for targeted attacks.                                                                                  |
| | **1. `route add default gw 192.168.1.1`**: Sets the default gateway.                                                                                                   | Redirect traffic through a controlled gateway to monitor or manipulate communications.                                                                                        |
| **`ping`**              | Tests connectivity to a remote host.                                                                                                           | - Identify live hosts for further exploitation.<br>- Diagnose connectivity issues for stealthy attack planning.                                                               |
| | **1. `ping 8.8.8.8`**: Sends ICMP echo requests to Google’s public DNS.                                                                                               | Verify external connectivity or detect ICMP filtering.                                                                                                                        |
| **`traceroute`**        | Traces the path packets take to reach a host.                                                                                                 | - Map the network topology and locate bottlenecks.<br>- Identify intermediate devices for lateral movement.                                                                   |
| | **1. `traceroute <target>`**: Displays the path to the target host.                                                                                                    | Enumerate routers or firewalls to identify chokepoints or weak links in the network.                                                                                          |
| **`netstat`**           | Displays active network connections, routing tables, and listening services.                                                                   | - Enumerate active services for targeting.<br>- Detect suspicious or unauthorized network activity.                                                                            |
| | **1. `netstat -tuln`**: Lists listening TCP/UDP ports.                                                                                                                | Identify open ports and active services to prioritize attack vectors.                                                                                                         |
| **`ss`**                | Displays socket statistics (modern replacement for `netstat`).                                                                                 | - Enumerate active connections and listening services more efficiently.<br>- Detect encrypted traffic or covert channels.                                                     |
| | **1. `ss -tuln`**: Lists listening TCP/UDP ports.                                                                                                                    | Quickly identify high-value services for targeting or exploitation.                                                                                                           |
| **`tcpdump`**           | Captures and analyzes network packets.                                                                                                         | - Sniff sensitive data such as credentials or session tokens.<br>- Monitor unencrypted traffic to identify exploitable vulnerabilities.                                       |
| | **1. `tcpdump -i eth0 -w capture.pcap`**: Captures packets on `eth0` and saves to a file.                                                                              | Analyze offline to extract credentials or tokens from the captured traffic.                                                                                                   |
| | **2. `tcpdump host <target_ip>`**: Filters packets for a specific host.                                                                                                | Narrow monitoring to high-value targets for efficient data collection.                                                                                                       |
| **`Wireshark/tshark`**  | GUI and CLI tools for in-depth packet analysis.                                                                                               | - Inspect traffic for protocol-specific vulnerabilities.<br>- Identify plaintext credentials in HTTP or unencrypted FTP sessions.                                            |
| **`nmap`**              | Scans networks for live hosts, open ports, and vulnerabilities.                                                                               | - Perform reconnaissance to identify vulnerable systems or services.<br>- Automate vulnerability discovery using scripts.                                                    |
| | **1. `nmap -sS -Pn 192.168.1.0/24`**: Performs a stealth SYN scan on a subnet.                                                                                        | Locate active hosts with minimal detection by IDS/IPS.                                                                                                                        |
| | **2. `nmap --script vuln <target>`**: Scans a target for known vulnerabilities.                                                                                      | Directly pinpoint exploitable services or misconfigurations.                                                                                                                  |
| **`vim /etc/resolv.conf`** | Configures DNS settings by editing the resolver configuration file.                                                                        | - Redirect DNS queries to attacker-controlled servers.<br>- Poison DNS settings for traffic manipulation.                                                                    |
| | **1. `nameserver 8.8.8.8`**: Sets Google’s DNS server for name resolution.                                                                                           | Modify entries to point to malicious DNS servers.                                                                                                                            |
| **`iptables`**          | Configures firewall rules to allow or block specific traffic.                                                                                 | - Disable firewalls to allow malicious communication.<br>- Add rules to block defensive mechanisms or monitoring tools.                                                       |
| | **1. `iptables -L`**: Lists current firewall rules.                                                                                                                  | Analyze configurations to find misconfigurations or exploitable rules.                                                                                                       |
| | **2. `iptables -A INPUT -p tcp --dport 22 -j ACCEPT`**: Allows incoming SSH connections.                                                                              | Enable SSH access for persistence or data exfiltration.                                                                                                                       |
| | **`-p or --protocol`**: Specifies the protocol to match (e.g. tcp, udp, icmp) |
| | **`--dport`**: Specifies the destination port to match |
| | **`--sport`**: Specifies the source port to match |
| | **`-s or --source`**: Specifies the source IP address to match |
| | **`-d or --destination`**: Specifies the destination IP address to match |
| | **`-m state`**: Matches the state of a connection (e.g. NEW, ESTABLISHED, RELATED) |
| | **`-m multiport`**: Matches multiple ports or port ranges |
| | **`-m tcp`**: Matches TCP packets and includes additional TCP-specific options |
| | **`-m udp`**: Matches UDP packets and includes additional UDP-specific options |
| | **`-m string`**: Matches packets that contain a specific string |
| | **`-m limit`**: Matches packets at a specified rate limit |
| | **`-m conntrack`**: Matches packets based on their connection tracking information |
| | **`-m mark`**: Matches packets based on their Netfilter mark value |
| | **`-m mac`**: Matches packets based on their MAC address |
| | **`-m iprange`**: Matches packets based on a range of IP addresses |
| **SELinux/AppArmor**    | Mandatory access control systems that enforce resource restrictions.                                                                          | - Bypass or disable policies for greater system control.<br>- Exploit weak or misconfigured profiles for unauthorized access.                                                 |
| | **1. `getenforce`**: Displays the current SELinux status.                                                                                                            | Detect if SELinux is enforcing, permissive, or disabled to adjust exploitation techniques.                                                                                    |
| | **2. `aa-status`**: Displays AppArmor profile statuses.                                                                                                              | Identify disabled or lenient profiles for potential exploitation.                                                                                                             |
| **`TCP Wrappers`**      | Controls access to network services based on IP address rules.                                                                               | - Analyze or manipulate `/etc/hosts.allow` and `/etc/hosts.deny` for unauthorized access.<br>- Whitelist attacker-controlled IPs for persistence.                            |
| | **1. `vim /etc/hosts.allow`**: Adds allowed hosts to access specific services.                                                                                       | Add attacker IPs to bypass access controls.                                                                                                                                  |
| | **2. `vim /etc/hosts.deny`**: Blocks access to specified services for certain hosts.                                                                                 | Block legitimate users to disrupt monitoring or defenses.                                                                                                                    |




### Network Intrusion Detection
| **Command/Tool**          | **Description**                                                                 | **Attacker’s Perspective**                                                                                          |
|---------------------------|---------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------|
| **`snort`**               | Open-source IDS that detects and logs suspicious traffic.                        | Analyze Snort rules to craft undetectable payloads or identify bypass techniques.                                   |
| **`suricata`**            | An IDS/IPS tool for real-time traffic analysis.                                  | Evade detection by using encrypted or obfuscated payloads.                                                          |
| **`tcpdump`**             | Captures network traffic for analysis.                                          | Identify IDS monitoring points by analyzing mirrored or intercepted traffic.                                        |
| **`iptables`**            | Configures firewall rules.                                                      | Modify rules to block IDS traffic or create backdoors.                                                              |
| **`grep -i "alert"`**      | Searches IDS logs for specific alerts.                                          | Identify triggering patterns and adjust attack vectors accordingly.                                                 |

---

### Network Penetration Testing
| **Command/Tool**          | **Description**                                                                 | **Attacker’s Perspective**                                                                                          |
|---------------------------|---------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------|
| **`nmap`**                | Network scanner to discover hosts, ports, and services.                         | Enumerate live hosts and open ports to identify vulnerable services.                                                |
| | **`nmap -sS -Pn <target>`**: Stealth scan that avoids full TCP handshakes.                                | Reduce detection chances while enumerating services.                                                                |
| **`metasploit`**          | Exploitation framework to execute vulnerabilities.                              | Automate and deploy exploits against identified weaknesses.                                                         |
| **`hping3`**              | Packet crafting tool to simulate attacks.                                       | Bypass firewalls and IDS with custom TCP, UDP, or ICMP packets.                                                     |
| **`wireshark`**           | Analyzes network traffic visually.                                              | Inspect and manipulate traffic to find weak protocols or misconfigured devices.                                     |

---

### Network Forensics
| **Command/Tool**          | **Description**                                                                 | **Attacker’s Perspective**                                                                                          |
|---------------------------|---------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------|
| **`tcpdump`**             | Captures packets for offline analysis.                                          | Exfiltrate sensitive data by identifying traffic of interest.                                                       |
| **`tshark`**              | Command-line version of Wireshark for packet analysis.                          | Use encrypted protocols to evade forensic analysis.                                                                 |
| **`strings <file>`**      | Extracts readable strings from binary files.                                    | Recover or inspect forensic artifacts in captured network traffic.                                                  |
| **`cat /var/log/messages`** | Views system logs.                                                            | Locate traces of activities to tamper with or cover tracks.                                                         |
| **`foremost`**            | Extracts files from raw network data.                                           | Hide malicious payloads within legitimate-looking traffic.                                                          |

---

### Network Defense
| **Command/Tool**          | **Description**                                                                 | **Attacker’s Perspective**                                                                                          |
|---------------------------|---------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------|
| **`ufw`**                 | Uncomplicated Firewall, simplifies firewall rule management.                    | Enumerate firewall rules for misconfigurations and exploit allowed traffic.                                         |
| | **`ufw status`**: Displays active rules.                                                                 | Identify allowed traffic to design attacks.                                                                        |
| **`iptables`**            | Configures and manages advanced firewall rules.                                 | Disable or modify rules to allow malicious traffic.                                                                 |
| | **`iptables -L`**: Lists all rules.                                                                      | Analyze defensive configurations for weaknesses.                                                                   |
| **`fail2ban`**            | Protects services by banning IPs after repeated login attempts.                 | Launch low-and-slow brute force attacks to avoid triggering bans.                                                   |
| **`openvas`**             | Vulnerability scanner for network defense.                                      | Enumerate and test vulnerabilities in defensive configurations.                                                     |
| **`auditd`**              | Monitors and logs security-relevant system activity.                            | Disable or tamper with logs to avoid detection.                                                                     |



---



---

### General Commands for Remote Desktop Protocols
1. **General Commands for Remote Desktop Protocols**
2. **XServer (X11)**
3. **XDMCP**
4. **VNC (Virtual Network Computing)**

| **Command/Tool**                 | **Description**                                                                                  | **Attacker’s Perspective**                                                                                           |
|----------------------------------|--------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------|
| **`xauth`**                      | Manages X11 authentication tokens.                                                              | Bypass authentication to gain access to X11 sessions.                                                               |
| **`tcpdump port <port>`**         | Captures network traffic on specific ports (e.g., 5900 for VNC or 6000 for X11).                | Intercept unencrypted remote desktop traffic.                                                                        |
| **`wireshark`**                  | Analyzes captured packets with a GUI.                                                           | Inspect captured VNC or X11 sessions for sensitive data.                                                             |
| **`ssh -Y <user>@<host>`**        | Enables trusted X11 forwarding.                                                                | Tunnel X11 sessions while preserving user trust and avoiding detection.                                              |
| **`chmod +x ~/.vnc/xstartup`**    | Assigns executable rights to the VNC session startup file.                                      | Exploit misconfigured permissions for unauthorized modifications or persistence.                                      |



#### XServer (X11)
This is the XServer (X11) commands for attackers to understand the XServer (X11), the XServer (X11) user, the XServer (X11) group, the XServer (X11) start time, the XServer (X11) end time, the XServer (X11) memory usage, the XServer (X11) CPU usage, the XServer (X11) command line, and the XServer (X11) arguments.
| **Command/Tool**             | **Description**                                                                                     | **Attacker’s Perspective**                                                                                            |
|------------------------------|-----------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------|
| **`cat /etc/ssh/sshd_config`** | Displays the SSH configuration file.                                                              | Verify if X11 forwarding is enabled to exploit unencrypted X11 sessions.                                             |
| | **`grep X11Forwarding`**: Filters the SSH configuration for X11 settings.                                                       | Check if X11 forwarding is allowed for exploiting sessions.                                                          |
| **`ssh -X <user>@<host>`**    | Starts an SSH session with X11 forwarding enabled.                                                | Tunnel X11 sessions through SSH to capture graphical output securely.                                                |
| **`xwd`**                     | Captures window dumps from X11 sessions.                                                          | Extract screenshots of active sessions on vulnerable systems.                                                        |
| **`xgrabsc`**                 | Captures screen content from X11 sessions.                                                        | Spy on user activity or capture sensitive information displayed on screens.                                          |


### XDMCP
This is the XDMCP commands for attackers to understand the XDMCP, the XDMCP user, the XDMCP group, the XDMCP start time, the XDMCP end time, the XDMCP memory usage, the XDMCP CPU usage, the XDMCP command line, and the XDMCP arguments.
| **Command/Tool**             | **Description**                                                                                     | **Attacker’s Perspective**                                                                                            |
|------------------------------|-----------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------|
| **`nmap -p 177 <target>`**    | Scans for open XDMCP ports on a target system.                                                    | Identify XDMCP-enabled systems for potential man-in-the-middle attacks.                                              |
| **`xwininfo`**                | Displays information about X11 windows.                                                          | Gather details about active windows to identify sensitive applications.                                              |
| **`xdpyinfo`**                | Displays X11 display server information.                                                         | Enumerate display capabilities and configurations for further exploitation.                                           |



### VNC (Virtual Network Computing)
This is the VNC (Virtual Network Computing) commands for attackers to understand the VNC (Virtual Network Computing), the VNC (Virtual Network Computing) user, the VNC (Virtual Network Computing) group, the VNC (Virtual Network Computing) start time, the VNC (Virtual Network Computing) end time, the VNC (Virtual Network Computing) memory usage, the VNC (Virtual Network Computing) CPU usage, the VNC (Virtual Network Computing) command line, and the VNC (Virtual Network Computing) arguments.
| **Command/Tool**                  | **Description**                                                                                  | **Attacker’s Perspective**                                                                                           |
|-----------------------------------|--------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------|
| **`nmap -p 5900-5903 <target>`**  | Scans for open VNC ports.                                                                        | Identify VNC servers running on common ports.                                                                        |
| **`vncpasswd`**                   | Sets a password for VNC connections.                                                            | Replace or brute-force VNC passwords for unauthorized access.                                                        |
| **`vncserver`**                   | Starts a VNC server session.                                                                    | Deploy a rogue VNC server to capture user activity.                                                                  |
| **`xtightvncviewer`**             | Connects to a VNC server.                                                                       | Use stolen credentials to access remote desktops.                                                                    |
| **`ssh -L 5901:127.0.0.1:5901`**  | Creates an SSH tunnel for VNC traffic.                                                          | Tunnel VNC traffic for stealthy communication or to bypass firewalls.                                                |
| **`vncserver -list`**             | Lists active VNC sessions with ports and process IDs.                                           | Identify existing sessions for hijacking or enumeration.                                                             |

---

## Linux Hardening & Security Commands
Linux systems are inherently more secure than many alternatives, but no system is impervious to threats. Key security practices for Linux include keeping the OS updated, configuring firewalls, using fail2ban for login protection, and minimizing attack surfaces by disabling unnecessary services. Tools like Snort, chkrootkit, rkhunter, and Lynis help in auditing and monitoring the system. Other essential practices include enforcing strong passwords, managing user privileges, and configuring advanced security mechanisms such as SELinux, AppArmor, and TCP wrappers to restrict unauthorized access and improve defense in depth.

### Linux Security Commands
This is the Linux Security Commands for attackers to understand the Linux Security, the Linux Security user, the Linux Security group, the Linux Security start time, the Linux Security end time, the Linux Security memory usage, the Linux Security CPU usage, the Linux Security command line, and the Linux Security arguments.
| **Command/Tool**          | **Description**                                                                 | **Attacker’s Perspective**                                                                                          |
|---------------------------|---------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------|
| **`apt update && apt dist-upgrade`** | Updates the system and installed packages to the latest versions.                          | Outdated systems can be targeted with known exploits. Attackers monitor patch releases to exploit unpatched systems. |
| **`iptables`**            | Configures firewall rules to restrict or allow traffic.                                      | Analyze and bypass firewall rules to exploit misconfigurations or open services.                                     |
| | **1. `iptables -L`**: Lists active rules.                                                                      | Enumerate rules to identify exploitable configurations or open ports.                                                |
| **`fail2ban`**            | Prevents brute-force attacks by banning IPs after repeated failed logins.                    | Use slow brute-force attacks to avoid triggering bans or identify IP block patterns to evade detection.              |
| **`sudo visudo`**         | Edits the sudoers file for managing user privileges.                                          | Exploit misconfigured sudo privileges to escalate access.                                                            |
| | **1. Add `user ALL=(ALL) NOPASSWD: /bin/bash`**: Grants root privileges without a password.                      | Identify overly permissive sudo rules for privilege escalation.                                                      |
| **`chkrootkit`**          | Checks for rootkits on the system.                                                           | Evade detection by using custom malware or tampering with chkrootkit binaries.                                       |
| **`rkhunter`**            | Detects rootkits, backdoors, and exploits on the system.                                      | Disable or tamper with rkhunter logs to avoid detection.                                                             |
| **`lynis audit system`**  | Performs a comprehensive security audit of the Linux system.                                  | Identify audit trails and misconfigurations to exploit weak security practices.                                       |
| **`tcpdump`**             | Captures network traffic for analysis.                                                       | Analyze traffic for sensitive information or use encrypted protocols to evade monitoring.                            |
| **`cat /etc/hosts.allow`** | Configures services and hosts allowed access via TCP wrappers.                               | Add attacker-controlled IPs to allow malicious access to restricted services.                                        |
| | Example Rule: `sshd : 192.168.1.100`                                                                           | Grants SSH access to the attacker's IP.                                                                              |
| **`cat /etc/hosts.deny`** | Configures services and hosts denied access via TCP wrappers.                                | Remove or modify rules to allow unrestricted access to blocked services.                                             |
| | Example Rule: `ALL : .example.com`                                                                             | Blocks all hosts in the example.com domain.                                                                          |
| **`getenforce`**          | Displays the current SELinux status.                                                        | Determine if SELinux is enforcing, permissive, or disabled to plan exploitation techniques.                          |
| **`semanage fcontext`**   | Configures SELinux file contexts.                                                            | Exploit misconfigured SELinux policies to bypass access restrictions.                                                |
| **`passwd -l <username>`**| Locks a user account to prevent login.                                                       | Identify accounts locked by administrators and attempt lateral movement to active accounts.                          |
| **`find / -perm -4000`**  | Finds all SUID binaries on the system.                                                       | Exploit SUID binaries for privilege escalation.                                                                      |
| **`systemctl disable <service>`** | Disables unnecessary or vulnerable services.                                        | Identify and exploit critical services left enabled by administrators.                                               |
| **`ulimit -c 0`**         | Disables core dumps.                                                                         | Exploit enabled core dumps to analyze memory and extract sensitive information.                                      |

---


### **Firewall Commands**
This is the Firewall Commands for attackers to understand the Firewall, the Firewall user, the Firewall group, the Firewall start time, the Firewall end time, the Firewall memory usage, the Firewall CPU usage, the Firewall command line, and the Firewall arguments.
| **Command/Tool**            | **Description**                                                                                      | **Attacker’s Perspective**                                                                                      |
|-----------------------------|-----------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------|
| **`iptables`**              | Configures Netfilter firewall rules.                                                               | - Analyze and exploit firewall misconfigurations.<br>- Add, modify, or delete rules for malicious access.       |
| | **1. `iptables -L`**: Lists all active rules.                                                                                   | Enumerate current configurations to identify weak or exploitable rules.                                        |
| | **2. `iptables -A INPUT -p tcp --dport 22 -j ACCEPT`**: Allows incoming SSH traffic.                                             | Enable access to restricted services such as SSH for lateral movement or persistence.                          |
| | **3. `iptables -A INPUT -p tcp --dport 8080 -j DROP`**: Blocks incoming traffic on port 8080.                                    | Simulate or test denial-of-service scenarios by blocking critical ports.                                       |
| | **4. `iptables -D INPUT -p tcp --dport 80 -j ACCEPT`**: Deletes a rule allowing HTTP traffic.                                    | Remove legitimate rules to disrupt services or evade detection.                                               |
| | **5. `iptables -F`**: Flushes all rules in a chain.                                                                             | Clear existing rules to disable firewall protections entirely.                                                |
| **`nftables`**              | Modern replacement for iptables with improved performance and usability.                           | - Exploit misconfigurations in rules or migration errors from iptables.                                       |
| | **1. `nft list ruleset`**: Displays all active rules.                                                                           | Enumerate configurations to identify exploitable patterns.                                                    |
| **`ufw`**                   | Simplifies firewall management by abstracting iptables commands.                                   | - Test for overly permissive or default configurations.<br>- Exploit rules left open for convenience.          |
| | **1. `ufw allow 22`**: Allows SSH traffic.                                                                                      | Open necessary ports for malicious remote access.                                                             |
| | **2. `ufw deny 80`**: Blocks HTTP traffic.                                                                                      | Simulate service outages or test fallback mechanisms.                                                         |
| **`firewalld`**             | Manages dynamic and zone-based firewall configurations.                                            | - Analyze zone configurations for services unnecessarily exposed.<br>- Modify zones to enable attacker access. |
| | **1. `firewall-cmd --get-active-zones`**: Lists active zones.                                                                   | Identify misconfigured zones with unrestricted access.                                                        |
| | **2. `firewall-cmd --add-port=22/tcp --permanent`**: Adds a permanent rule for SSH traffic.                                      | Modify persistent rules to establish backdoor access.                                                         |
| **Advanced iptables Options** | Extends functionality for granular control.                                                      | - Exploit complex configurations for unintended allowances.                                                   |
| | **1. `iptables -A FORWARD -p tcp -d 192.168.1.100 --dport 80 -j DNAT --to-destination 192.168.1.200:8080`**: Redirects traffic. | Redirect traffic to malicious servers or hijack sessions.                                                     |
| | **2. `iptables -A INPUT -p tcp -m state --state NEW -j DROP`**: Blocks new connections.                                         | Simulate connection denial or enforce stealthier attack approaches.                                           |
| **Audit Commands**          | Evaluate firewall rules and configurations.                                                       | - Identify audit gaps or weaknesses.<br>- Exploit unmonitored configurations for undetected access.            |
| | **1. `journalctl -u firewalld`**: Views logs related to firewalld.                                                             | Analyze logs to determine administrative activities or errors.                                                |
| | **2. `iptables-save`**: Exports current rules to a file.                                                                       | Review configurations offline for targeted exploitation.                                                      |
