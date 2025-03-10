# Linux Attackers View - Cheat Sheet

## Linux Overview
### Philosophy (Attacker’s Perspective)
**Linux felxible Design Principles (everything is a file, chaining small tools, etc.) offer attackers a powerful toolkit.**

| **Principle**                                             | **Attacker’s Perspective**                                                                                                                                                                  |
|-------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Everything is a file**                                  | Since configuration files and other critical data are stored in plain text, attackers can modify or replace these files to gain persistence, escalate privileges, or steal sensitive data.                                           |
| **Small, single-purpose programs**                        | Each tool can be combined (chained) to automate malicious tasks (e.g., quickly scanning, enumerating, and exfiltrating). Attackers love modular approaches because they can mix and match small tools for flexible exploitation flows.  |
| **Ability to chain programs together to perform complex tasks** | Attackers leverage shell scripting and piping to chain commands together. This can streamline data gathering or automate the process of planting and hiding backdoors, making the attack process more efficient.                         |
| **Avoid captive user interfaces**                         | The shell-based design allows attackers to remain “headless” and blend in with normal administrative workflows. They can script actions without a graphical interface, reducing their footprint and detection chances.                  |
| **Configuration data stored in a text file**             | Sensitive information (e.g., user accounts, cron jobs, or key application configs) is often in these files. Attackers can modify or inject malicious instructions (like cron-based reverse shells) with a simple text edit.             |


---

### Components (Attacker’s Perspective)
- **Components**: Each component, from the bootloader to system utilities, presents unique opportunities for **privilege escalation**, **persistence**, and **stealth**.

| **Component**      | **Attacker’s Perspective**                                                                                                                                                           |
|--------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Bootloader**     | Manipulating the bootloader or its configuration can grant attackers early-stage control, allowing them to load malicious kernel modules or bypass security measures before the OS is fully operational.                 |
| **OS Kernel**      | The kernel is a prime target for privilege escalation: exploiting kernel vulnerabilities can grant an attacker root-level access. Once compromised at the kernel level, nearly all system activities are exposed.       |
| **Daemons**        | Daemons run in the background, often with high privileges. Attackers may replace or hijack these services to ensure persistent footholds or to execute malicious tasks unnoticed.                                      |
| **OS Shell**       | Command-line interfaces are ideal for stealth and automation. Attackers can run commands, pivot within the system, and script their actions to blend in with legitimate admin usage.                                   |
| **Graphics server**| Typically less of a direct target for console-based attackers, but vulnerabilities here can enable privilege escalation or allow remote graphical-based access for advanced attacks.                                   |
| **Window Manager** | Most attackers focus on shell access, but if they can compromise the GUI environment, they can capture keystrokes, user credentials, or manipulate the user’s session for further exploitation.                         |
| **Utilities**      | Common system tools (e.g., `sed`, `awk`, `curl`) can be hijacked or leveraged to download malicious payloads, parse data for exfiltration, or chain together tasks for complex attacks.                                |


---

### Linux Architecture (Attacker’s Perspective)
- **Architecture**: Exploiting lower-level layers (kernel, hardware) yields the greatest control. Meanwhile, higher-level layers (shell, utilities) offer attackers **automation** and **access** to everyday admin actions.
- An attacker’s interest in each directory is driven by the **potential impact** they can achieve—whether that’s **privilege escalation**, **persistence**, **data exfiltration**, or **stealthy communications**.
- Directories with **system-critical** files (like `/boot`, `/lib`, `/etc`) or **high-privilege executables** (like `/bin`, `/sbin`) are prime targets for attackers seeking **deep system control**.
- **World-writable** or **frequently ignored** locations (like `/tmp` or `/mnt`) are common places to **stage malicious tools** and files due to less scrutiny.


#### Architecture Layers Overview
| **Layer**          | **Attacker’s Perspective**                                                                                                                                                     |
|--------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Hardware**       | Physical access to hardware (or the ability to control hardware peripherals) can allow attackers to implant keyloggers, tamper with disk contents, or intercept network communications.                            |
| **Kernel**         | Attacking the kernel is highly rewarding because kernel-level exploits let attackers bypass many security controls, gain root access, and maintain persistent stealth on the system.                               |
| **Shell**          | The CLI is an attacker’s playground—commands can be run silently, scripts can automate malicious tasks, and interactive shells allow real-time exploration and manipulation of the system.                         |
| **System Utility** | System utilities expose vital OS functionalities (e.g., package managers, cron schedulers). Attackers exploit these to install backdoors, exfiltrate data, or schedule malicious jobs under the guise of normal OS tasks. |




#### File System Hierarchy

| **Path**   | **Description**                                                                                                                                                                   | **Attacker’s Perspective**                                                                                                                                                                                                                   |
|------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **`/`**        | The top-level directory is the root filesystem. It contains all files needed to boot the OS and serves as the mount point for other filesystems.                              | **Potential “pivot point”** for accessing other directories. Attackers might place rootkits here, modify critical startup scripts, or otherwise alter the root environment to gain persistent access or hide malicious activities.         |
| **`/bin`** | Contains essential command binaries used by the system for basic operations (e.g., `ls`, `cp`, `mv`).                                                                          | **Executable tampering** is a key risk. Attackers might replace or trojan system binaries to maintain stealthy access, escalate privileges, or run malicious code under legitimate process names.                                       |
| **`/boot`**| Consists of the static bootloader, kernel, and files required to boot the Linux OS.                                                                                           | **Kernel-level compromise**. If an attacker gains write access, they could insert malicious kernel modules or tamper with bootloader files to execute malicious code at startup, before most defenses load.                              |
| **`/dev`** | Contains device files to facilitate access to hardware devices.                                                                                                                | **Device manipulation or covert channels**. Attackers might create or hide behind pseudo-devices (e.g., `/dev/tcp`) to exfiltrate data or establish hidden communication channels.                                                       |
| **`/etc`** | Local system configuration files. Often includes user accounts (`/etc/passwd`), groups, and configurations for applications and services.                                      | **Configuration sabotage or credential theft**. Attackers may edit critical configs, add malicious cron jobs, or steal hashed credentials from files like `/etc/shadow`.                                                               |
| **`/home`**| Each user on the system has a subdirectory here for personal storage.                                                                                                          | **User data and staging**. Attackers target user files for exfiltration. They may also store malicious scripts in user directories that seem “normal” and go unnoticed for longer.                                                      |
| **`/lib`** | Shared library files required for system boot and application runtime.                                                                                                         | **Library hijacking**. Attackers could replace legitimate libraries with malicious ones (LD_PRELOAD attacks) to run unauthorized code whenever a program linked to that library is executed.                                            |
| **`/media`**| External removable media devices such as USB drives are mounted here.                                                                                                        | **Data exfiltration**. Attackers might leverage removable media to quickly steal data or introduce malware. They might also target auto-mounted drives to spread malicious files.                                                      |
| **`/mnt`** | Temporary mount point for regular filesystems, used to mount various filesystems or disk images.                                                                               | **Temporary staging area**. An attacker might mount hidden or encrypted filesystems here to store tools or stolen data. Because it’s a known “temporary” space, suspicious files often draw less attention.                              |
| **`/opt`** | Optional files such as third-party applications or tools are often installed here.                                                                                             | **Installation of custom tooling**. Attackers can place custom malware, backdoors, or reconnaissance tools in `/opt`, masking them as legitimate third-party or optional applications.                                                 |
| **`/root`**| The home directory for the `root` (superuser).                                                                                                                                | **High-value compromise**. Gaining write access here indicates root privileges. An attacker may store scripts, SSH keys, or other malicious binaries to maintain high-level persistence.                                               |
| **`/sbin`**| Contains executables used for system administration (binaries that generally require root privilege to run).                                                                   | **Privilege escalation**. Attackers with root access might replace administrative tools to escalate privileges or create backdoors. Malicious usage could remain hidden if they mimic legitimate system administration commands.       |
| **`/tmp`** | Used by the OS and applications to store temporary files. Typically cleared on reboot but may be emptied at other times.                                                       | **Common malware staging**. Because `/tmp` is world-writable, attackers frequently drop payloads or run scripts here. They can also exploit race conditions or symlink attacks if permissions aren’t properly secured.                  |
| **`/usr`** | Contains executables, libraries, man pages, etc., for system-wide applications and utilities.                                                                                  | **Extended system attack surface**. Attackers might replace or add binaries in subdirectories like `/usr/bin` or `/usr/local/bin` to execute malicious code that blends in with legitimate user-installed programs.                     |
| **`/var`** | Contains variable data like logs, mail, web files, and other dynamically modified content.                                                                                     | **Log manipulation and data exfiltration**. Attackers may clear or forge logs to hide tracks. They might place malicious content in web-accessible directories or manipulate spool files to escalate privileges or exfil data.           |

---

## System Information (Attacker’s Perspective)
- **System Information**: Attackers leverage knowledge of processes, users, and configurations to plan and escalate attacks.
- **Tools & Commands**: Almost any built-in command can be weaponized—from simple listing utilities (ls, cat) to network (curl, netstat) and package management (apt, pip).
- **By understanding legitimate functionality**, attackers can blend their actions with normal admin tasks, making detection harder.

| **Topic**                              | **Attacker’s Perspective**                                                                                                                                       |
|------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Linux Structure**                    | Familiar file system and directory layout helps attackers quickly locate critical config files (e.g., `/etc/`, `/var/log/`) or binaries to modify for persistence.                                 |
| **Linux System Information**           | Gathering OS release, kernel version, and hardware details helps attackers find known vulnerabilities or tailor privilege-escalation exploits.                                                    |
| **Linux Processes**                    | Attackers can hide malicious processes among normal system processes, or target high-privilege processes (like daemons) to gain root access or persist in memory.                                 |
| **Linux Network Configuration**        | Reviewing IP addresses, routes, and interfaces helps attackers identify open ports/services, discover internal networks, and plan lateral movement.                                                |
| **Linux Users**                        | Enumerating users and groups reveals potential weak passwords, privileged accounts, or misconfigurations (e.g., sudoers file) that can be exploited to escalate privileges.                        |
| **Linux Directories**                  | Knowing default directories (e.g., `/home/`, `/usr/local/`, `/tmp/`) helps attackers find places to drop malware, store data, or hide tools where they may go unnoticed.                            |
| **Linux User Settings & Parameters**   | Attackers can manipulate environment variables and config files to set up persistent backdoors, harvest credentials, or intercept normal user operations without raising suspicion.              |

---

### Attacker View of The Shell (Command Line Interface)
**The shell is an attacker’s playground, he can use shell customization to display information about the system and the user.**
1. **Customizing Prompts**: Modify the prompt in .bashrc or the active shell for enhanced tracking:
`PS1='[\u@\h \w]\$ '`
2. **Operational Benefits**:
   - **Organization**: Track activities across multiple shells or hosts.
   - **Efficiency**: Navigate complex file systems quickly with visible context.
   - **Documentation**: Provide clear logs for compliance and reporting.


#### Attacker View Table: Bash Prompt for Penetration Testing

| **Prompt Component**          | **Description**                                                                 | **Attacker’s Perspective**                                                                                      |
|--------------------------------|---------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------|
| `<username>@<hostname><cwd>$` | Default Bash prompt for regular users.                                          | - Identify user and environment.<br>- Navigate file system efficiently using current directory display.         |
| `<username>@<hostname>[~]$`   | Indicates the user is in their home directory (`~`).                            | - Recognize home directory quickly for storing payloads or editing configuration files.                        |
| `<username>@<hostname><cwd>#` | Default Bash prompt for root users.                                             | - Confirms root access.<br>- Enables execution of privileged commands without restrictions.                    |
| `$`                           | Minimal prompt for unprivileged users.                                          | - Often seen in restricted shells.<br>- Indicates lack of privilege escalation.                                |
| `#`                           | Minimal prompt for root or privileged users.                                    | - Confirms privilege escalation success.<br>- Enables execution of high-privileged tasks.                      |

#### **Special Prompt Variables**: Customization and Attacker Usage

| **Special Character** | **Description**                                  | **Attacker’s Perspective**                                                                                      |
|------------------------|------------------------------------------------|----------------------------------------------------------------------------------------------------------------|
| `\u`                  | Current username.                               | - Useful for identifying user context after pivoting or privilege escalation.                                  |
| `\h`                  | Short hostname of the system.                   | - Helps confirm the target environment in multi-host operations.                                               |
| `\H`                  | Full hostname of the system.                    | - Provides detailed host information for documentation or targeting.                                           |
| `\w`                  | Full path of the current working directory.     | - Facilitates efficient navigation and identification of sensitive directories.                                |
| `\d`                  | Displays the current date (e.g., Mon Feb 6).    | - Timestamp logs or commands during operations for auditing or stealth.                                        |
| `\D{%Y-%m-%d}`        | Date in custom format (e.g., 2025-01-12).       | - Standardized date format for aligning with external reports or logs.                                         |
| `\t`                  | Current time in 24-hour format (HH:MM:SS).      | - Tracks operation timing.<br>- Identifies when security logs were last updated.                               |
| `\@`                  | Current time in 12-hour format with AM/PM.      | - Useful for recording attack steps in AM/PM format.<br>- Improves human-readable logs.                        |
| `\j`                  | Number of jobs managed by the shell.            | - Tracks background tasks such as file uploads, downloads, or scanning.                                        |
| `\n`                  | Inserts a newline in the prompt.                | - Improves readability for multi-line commands or outputs.                                                     |
| `\r`                  | Inserts a carriage return in the prompt.        | - Used in specific tools to manipulate output display or logs.                                                 |
| `\s`                  | Displays the shell name (e.g., bash, sh).       | - Identifies the shell type for determining potential exploit paths or configurations.                         |

#### **Customized Prompts for Attacker Operations**

| **Custom Prompt Example**     | **Customization**                                                | **Attacker’s Perspective**                                                                                      |
|-------------------------------|------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------|
| `[Attacker@\h \W]\$`          | Displays custom username, hostname, and current directory name. | - Easily track the host system while navigating directories.                                                   |
| `[\u@\H \w] \t \$`            | Shows user, full hostname, full path, and time.                 | - Combines key details for documentation and operational clarity.                                              |
| `[\D{%Y-%m-%d} \u@\h \W]\$`   | Adds the date to a detailed prompt.                             | - Logs date-stamped commands for reports or stealth operations.                                                |



---

## Workflow
- **Hidden File Discovery**: Use `ls -la` to find configuration files or credentials hidden with a dot prefix.
- **Target Permissions**: Analyze `ls -l` output to spot world-writable directories (`drwxrwxrwx`) or files owned by privileged users.
- **Temporary Files**: Inspect `/dev/shm` or `/tmp` using `ls -la` for potential leftover files or active processes.
- **File Search**: Use `find` to locate files based on attributes like size, owner, or type.
- **File Search**: Use `locate` to quickly search for files using a prebuilt database, enabling faster but less granular searches compared to find.
- **File Search**: Use `updatedb` to update the `locate` command’s database with the latest file and directory changes.
- **File Search**: Use `which` to show the path to an executable binary.

### File Descriptors and Redirections
| **File Descriptor**               | **Description**                                                                                  | **Attacker’s Perspective**                                                                                                   |
|---------------------------|--------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------|
| **`STDIN (FD 0)`**         | Standard input, used for receiving data into a program.                                          | Redirect input from files or devices to manipulate how commands are executed.                                               |
| **`STDOUT (FD 1)`**        | Standard output, used for sending normal command output.                                         | Capture or redirect the output of commands to files or other commands for further processing.                               |
| **`STDERR (FD 2)`**        | Standard error, used for sending error messages.                                                | Suppress or log error messages to prevent detection or debugging output.                                                    |
| **`>`**                | Redirects STDOUT to a file. | Direct command output to files for later analysis or exfiltration. |
| **`>>`**               | Appends output to a file. | Maintain a continuous log of system exploration for persistence or later reference. |
| **`2>`**               | Redirects STDERR to a file. | Suppress or isolate errors to avoid detection or clutter in output. |
| **`2>/dev/null`**      | Redirects STDERR to the null device, discarding errors. | Suppress errors to maintain stealth during enumeration or attacks. |
| **`1>`**               | Explicitly redirects STDOUT to a file. | Direct standard output to specific files for precise control. |
| **`<`**                | Redirects STDIN from a file. | Use predefined input for commands, simulating interactive input or automating tasks. |
| **`<<`**               | Redirects a stream of input (here-doc) to a file or command. | Use custom input streams for crafting payloads or commands dynamically. |
| **`\|` (Pipe)**          | Redirects STDOUT from one command to another for further processing. | Chain commands to filter, process, or manipulate output efficiently. |
| **`2>&1`**             | Redirects STDERR to the same destination as STDOUT. | Combine both outputs for comprehensive logging or analysis. |


### File Permissions and Ownership

| **Character**        | **Description**                             | **Attacker’s Perspective**                                                                                         |
|----------------------|---------------------------------------------|--------------------------------------------------------------------------------------------------------------------|
| **First Character**  | File Type                                   | Identify the type of file for reconnaissance or manipulation.                                                      |
| | **`d`**            | Directory                                   | Recognize directories for navigation, enumeration, and storing payloads.                                           |
| | **`-`**            | Regular File                                | Identify files for reconnaissance, manipulation, or exfiltration.                                                  |
| | **`l`**            | Symbolic Link                               | Trace symbolic links to discover underlying files or directories for exploitation.                                  |
| | **`c`**            | Character Device                            | Interact with hardware or system processes for low-level exploitation.                                             |
| | **`b`**            | Block Device                                | Access and manipulate storage devices for deeper system control.                                                   |
| | **`s`**            | Socket                                      | Locate and exploit interprocess communication mechanisms.                                                          |
| | **`p`**            | Named Pipe (FIFO)                          | Intercept or manipulate interprocess communication for data exfiltration or privilege escalation.                   |
| **Second to Fourth Characters (`rwx` for Owner)** | Permissions for the file owner.           | Determine what the owner can do with the file (read, write, execute).                                              |
| | **`r`**            | Read permission                             | The owner can read the file's contents. Useful for accessing sensitive data or configurations.                      |
| | **`w`**            | Write permission                            | The owner can modify the file. Look for writable sensitive files for tampering or privilege escalation.             |
| | **`x`**            | Execute permission                          | The owner can execute the file. Check for executable scripts or binaries for privilege escalation or payload execution. |
| | **`-`**            | No permission                               | The owner does not have the specific permission.                                                                   |
| **Fifth to Seventh Characters (`rwx` for Group)** | Permissions for the group.                 | Identify what members of the file’s group can do with the file.                                                    |
| | **`r`**            | Read permission                             | Group members can read the file's contents. Useful for enumerating shared group files or configurations.            |
| | **`w`**            | Write permission                            | Group members can modify the file. Exploit shared writable files for lateral movement or privilege escalation.       |
| | **`x`**            | Execute permission                          | Group members can execute the file. Target group-accessible scripts or binaries for exploitation.                   |
| | **`-`**            | No permission                               | Group members lack specific permissions.                                                                           |
| **Eighth to Tenth Characters (`rwx` for Others)** | Permissions for all other users.          | Identify what any user on the system can do with the file.                                                         |
| | **`r`**            | Read permission                             | Anyone can read the file's contents. Look for sensitive files accessible by all users.                             |
| | **`w`**            | Write permission                            | Anyone can modify the file. Exploit globally writable files for tampering or malicious activities.                  |
| | **`x`**            | Execute permission                          | Anyone can execute the file. Useful for privilege escalation via publicly accessible binaries or scripts.           |
| | **`-`**            | No permission                               | Other users lack specific permissions.                                                                             |
| **Special Permission Characters** | SUID, SGID, Sticky Bits           | Recognize special permissions for privilege escalation or persistence.                                              |
| | **`s` (SUID)**     | Set User ID                                 | File runs with the owner’s privileges. Exploit SUID binaries to execute commands as the file’s owner, often root.   |
| | **`s` (SGID)**     | Set Group ID                                | File runs with the group’s privileges. Exploit SGID binaries or directories for lateral movement or privilege escalation. |
| | **`t`**            | Sticky Bit                                  | Protects files in shared directories from deletion by non-owners. Bypass sticky bit protections for persistence or disruption. |
| | **`T`**            | Sticky Bit (No Execute)                     | Same as sticky bit but without execute permission for others. Exploit directories without execute permissions for stealth. |
| **Hard Links Count** | Number of hard links to the file or directory. | Use this to understand the file’s linkage and find hidden or duplicate paths.                                       |
| **User Ownership**   | The user that owns the file.                | Determine which user owns the file, often revealing privileged accounts for targeted exploitation.                  |
| **Group Ownership**  | The group that owns the file.               | Identify groups with elevated permissions for lateral movement or privilege escalation.                             |
| **File Size**        | Size of the file in bytes.                  | Use this to identify potential payloads, sensitive data, or unexpected files.                                       |
| **Last Modified Date** | Timestamp of the last modification.        | Analyze modification dates to identify recent changes or suspicious activity.                                       |

#### Examples of Permissions Lines and Their Explanation
| **Permissions Line**              | **Explanation**                                                                                                  | **Attacker’s Perspective**                                                                                         |
|-----------------------------------|------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------|
| **`-rw-r--r-- 1 root root 1641 May  4 23:42 /etc/passwd`** | - **File Type**: Regular file (`-`)<br>- **Owner Permissions**: Read and write (`rw-`)<br>- **Group Permissions**: Read-only (`r--`)<br>- **Others**: Read-only (`r--`) | - Readable by all users, making it accessible for enumeration to identify user accounts.<br>- Modification restricted to root, reducing direct tampering risk. |
| **`-rwxr-xr-x 1 cry0l1t3 htbteam 3548 Jan 12 12:30 /home/user/script.sh`** | - **File Type**: Regular file (`-`)<br>- **Owner Permissions**: Full access (read, write, execute: `rwx`)<br>- **Group Permissions**: Read and execute (`r-x`)<br>- **Others**: Read and execute (`r-x`) | - Publicly executable script: investigate its contents for vulnerabilities or use it to execute commands.<br>- Writable by owner, which may allow modifications for persistence. |
| **`drwxrwxr-t 3 cry0l1t3 htbteam 4096 Jan 12 12:30 /tmp/shared`** | - **File Type**: Directory (`d`)<br>- **Owner Permissions**: Full access (`rwx`)<br>- **Group Permissions**: Full access (`rwx`)<br>- **Others**: Read, write, and sticky bit (`r-t`) | - Shared directory with sticky bit: prevents deletion of files by non-owners.<br>- Writable by all users: potential space for payloads or temporary file staging. |


---



## System Management

### User Management
User management is a core aspect of Linux system administration, encompassing tasks such as creating and managing users, assigning group memberships, and controlling user access.
For attackers, these capabilities enable reconnaissance of user accounts, privilege escalation, and persistence. Manipulating user accounts or groups can provide access to sensitive files and directories or create backdoors for continued access.
- **Core Functionality**: User management in Linux involves creating, modifying, and deleting user accounts, managing group memberships, and controlling user access.
- **Execution Context**: Commands like sudo and su allow users to execute commands as other users, including root, enabling attackers to escalate privileges or access sensitive files.
- **File and Directory Permissions**: User and group memberships determine access to files and directories, making user management essential for privilege escalation and lateral movement.
- **Importance for Attackers**: Misconfigurations or weak passwords can be exploited to gain unauthorized access, create backdoor accounts, or modify existing accounts for persistence.

---

### Package Management
- **Core Functionality**: Package management in Linux involves installing, updating, and removing software packages, along with managing their dependencies.  
- **Execution Context**: Tools like `apt`, `dpkg`, and `snap` handle package operations, ensuring consistent installations and efficient updates.  
- **Dependency Resolution**: Package managers automate the resolution of dependencies, retrieving required libraries or binaries during installation.  
- **Importance for Attackers**: Attackers leverage package managers to install tools, maintain persistence, and exploit vulnerable packages. Misconfigurations or outdated packages are often targeted for exploitation.  


### Practical Exercise: Evil-WinRM Installation

**Objective**: Search for the "evil-winrm" tool on GitHub and install it using various methods to simulate real-world deployment scenarios.  

#### Steps:
1. **Using `git`**:
   ```bash
   git clone https://github.com/Hackplayers/evil-winrm.git ~/tools/evil-winrm
   ```
   - Clone the Evil-WinRM repository into a tools directory for post-exploitation or remote access to Windows systems.

2. **Using `wget`**:
   ```bash
   wget https://github.com/Hackplayers/evil-winrm/archive/refs/heads/master.zip -O evil-winrm.zip
   unzip evil-winrm.zip -d ~/tools/
   ```
   - Download the Evil-WinRM archive and extract it for usage.

3. **Manual Installation**:
   - Download the necessary dependencies and configure Evil-WinRM for your target environment.
   - Install dependencies using `gem install winrm winrm-fs`.


---
### Service and Process Management

- **Core Functionality**: Service and process management is a fundamental aspect of Linux administration, involving the monitoring, starting, stopping, and restarting of services and processes.
- **Services (Daemons)**: Background programs, often ending in `d` (e.g., `sshd`), that perform system tasks or provide services without user interaction.
- **Processes**: Active programs that can be managed using signals or commands to control their behavior (e.g., running, stopping, or killing them).
- **Tools and Techniques**: Tools like `systemctl`, `ps`, `kill`, and `journalctl` help administrators and attackers manage services and processes effectively.
- **Importance for Attackers**: Attackers leverage service and process management for persistence (starting malicious services), evasion (killing monitoring processes), and exploration (identifying running services for exploitation).

---

### Task Scheduling:
- **Core Functionality**: Task scheduling in Linux automates repetitive tasks, ensuring consistency and efficiency without manual intervention.  
- **Execution Tools**: Tools like `systemd` and `cron` allow administrators to schedule tasks based on time intervals or specific events.  
- **Key Use Cases**: Tasks include software updates, database maintenance, backups, and executing scripts at defined intervals.  
- **Importance for Attackers**: Misconfigured or overly permissive scheduling systems can be exploited to execute malicious scripts, maintain persistence, or disrupt critical services.  

---

### Network Services
- **Core Importance**: Network services in Linux are fundamental for enabling communication between systems, transferring files, managing remote systems, and hosting applications.  
- **Service Interaction**: Knowledge of network services such as SSH, NFS, web servers, and VPNs is crucial for system administrators and penetration testers to manage and secure systems effectively or identify vulnerabilities.  
- **Penetration Testing**: Attackers exploit misconfigured or outdated network services to gain unauthorized access, exfiltrate data, or escalate privileges.

---

### Backup and Restore 
- **Core Functionality**: Linux systems provide robust tools for backing up and restoring data, ensuring data protection, encryption, and ease of recovery.  
- **Tools**: Utilities like `rsync`, `Deja Dup`, and `Duplicity` support local and remote backups, with features like compression, incremental backups, and encryption for secure data transfer.  
- **Secure Transfers**: Combining tools like `rsync` with SSH ensures encrypted data transfers, safeguarding sensitive information during backups.  
- **Automation**: Tools like `cron` enable automated synchronization, ensuring regular and consistent backups with minimal manual intervention.  
- **Importance for Attackers**: Exploiting backup misconfigurations can provide access to sensitive data or backup systems themselves. Automated scripts and credentials in backup processes are often key targets.

--- 

### File System Management 

- **Core Functionality**: File system management in Linux involves organizing and maintaining data across storage devices, supporting various file systems like `ext4`, `XFS`, `NTFS`, and more.  
- **Execution Context**: Tasks include partitioning, formatting, mounting, and unmounting file systems, along with managing permissions and inodes for files and directories.  
- **Disk and Swap Management**: Disk partitions are managed using tools like `fdisk` or `gparted`, while swap space ensures smooth performance by offloading inactive memory pages.  
- **Importance for Attackers**: Misconfigured mounts, insecure file permissions, or unused swap areas can provide opportunities for privilege escalation, persistence, or exfiltration.  

#### Additional Attacker Scenarios:
1. **Analyze Mounted Drives**: Use `mount` or `cat /etc/fstab` to identify writable partitions for storing malicious files.
2. **Manipulate Swap Space**: Exploit sensitive data stored in unencrypted swap areas.
3. **Bypass Permissions**: Use inode numbers from `ls -il` to reference hidden or inaccessible files directly.
4. **Persistence**: Add custom mount entries to `/etc/fstab` for persistent access to drives.

---

### Containerization

- **Definition**: Containerization packages applications and their dependencies into isolated environments for efficient and secure deployment.  
- **Technologies**: Tools like Docker and Linux Containers (LXC) enable lightweight, portable, and scalable environments.  
- **Security and Isolation**: Containers isolate applications from the host system and other containers, enhancing security while maintaining performance.  
- **Attacker’s Perspective**: Containers can be used for testing exploits in isolated environments, hosting malicious files, or escalating privileges through container escapes or misconfigurations.  

#### Optional Exercises for Practice

1. **Create a Custom Docker Image**: Build a Dockerfile with tools like Apache and SSH pre-configured.  
2. **Install and Manage Docker**: Test the provided Docker installation script, create containers, and manage them using `docker ps`, `docker stop`, and `docker rm`.  
3. **Test LXC Configurations**: Install LXC, create a container, and configure resource limits (CPU, memory).  
4. **Escalate Privileges**: Investigate privilege escalation methods in misconfigured containers.  
5. **Host Malicious Files**: Set up a container as a hosting server using Apache or similar tools to serve payloads.  
6. **Explore Namespaces**: Test the isolation provided by namespaces and evaluate potential escape techniques.  
7. **Secure Containers**: Configure Docker or LXC settings to limit access or enforce mandatory security controls.  
8. **Use Docker Compose**: Create a multi-container setup for testing web applications or networked environments.  
9. **Clone Git Repositories**: Practice cloning repositories like Evil-WinRM to deploy tools within containers.


--- 

## Linux Networking (Attacker Perspective)

### Network Configuration (Attacker Perspective)
Understanding and managing network configuration is critical for penetration testers aiming to control traffic, exploit vulnerabilities, and gain deeper insights into target networks. By mastering Linux network tools, attackers can manipulate interfaces, analyze network traffic, and exploit weak configurations. 

#### Key Concepts:
1. **Network Interfaces**: Configure and exploit IPs, netmasks, and gateways to impersonate devices or pivot within a network.
2. **Access Control**: Bypass NAC systems (e.g., DAC, MAC, RBAC) to gain unauthorized access or escalate privileges.
3. **Traffic Monitoring**: Capture, analyze, and manipulate traffic using tools like Tcpdump or Wireshark for credentials or sensitive data.
4. **Hardening Bypass**: Disable or exploit SELinux, AppArmor, or TCP wrappers to gain and maintain access.

| **Topic**                | **Description**                                                                                                     | **Attacker’s Perspective**                                                                                       |
|--------------------------|---------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------|
| **Network Configuration** | Managing network interfaces, IP addresses, routes, and DNS settings to establish connectivity.                     | - Misconfigure or manipulate network settings to disrupt traffic or establish rogue connections.<br>- Enumerate interfaces and connections for reconnaissance. |
| **Network Access Control (NAC)** | Policies that enforce device access restrictions to protect network resources.                                 | - Identify and bypass NAC policies, such as MAC, DAC, or RBAC.<br>- Exploit weak access controls for lateral movement or privilege escalation. |
| **Discretionary Access Control (DAC)** | Access control based on resource ownership and user discretion.                                               | - Exploit misconfigured permissions by users to access sensitive resources.                                      |
| **Mandatory Access Control (MAC)** | Access control based on predefined policies and security labels.                                               | - Bypass strict rules through privilege escalation or exploiting policy misconfigurations.                       |
| **Role-Based Access Control (RBAC)** | Access control based on user roles and job responsibilities.                                                   | - Enumerate user roles to identify elevated privileges.<br>- Exploit weak role definitions to access restricted data. |
| **Configuring Interfaces** | Setting up and modifying network interfaces, including IP addresses and routes.                                    | - Reconfigure interfaces for stealth or to bypass restrictions.<br>- Assign rogue IPs or manipulate routing tables for redirection. |
| **Monitoring Network Traffic** | Capturing and analyzing traffic to identify vulnerabilities, threats, and sensitive data.                       | - Capture unencrypted credentials or tokens.<br>- Detect and exploit insecure or outdated protocols.             |
| **Troubleshooting**       | Diagnosing and resolving network issues such as connectivity problems and DNS failures.                            | - Use troubleshooting tools (e.g., `ping`, `traceroute`) to map networks and identify weaknesses.<br>- Exploit misconfigured DNS servers or routing issues. |
| **Hardening**             | Implementing security mechanisms (e.g., SELinux, AppArmor, TCP Wrappers) to protect network resources.             | - Identify and bypass hardening mechanisms.<br>- Exploit weak or default configurations for unauthorized access. |



#### **Network Configuration**
Network configuration involves managing interfaces, IPs, and routes to ensure proper communication between devices. 
- **Example**: Using `ip addr` to display interface details for reconnaissance.


#### **Network Access Control (NAC)**
NAC enforces policies to grant or restrict device access based on compliance. 
- **Example**: Exploiting weak RBAC policies to access restricted files.


#### **Configuring Interfaces**
Configuring interfaces includes assigning IPs, modifying netmasks, and setting gateways. 
- **Example**: Using `sudo ifconfig eth0 192.168.1.2` to assign a rogue IP address for traffic redirection.


#### **Network Monitoring & Network Traffic**
Monitoring captures packets to analyze traffic patterns and detect vulnerabilities. 
- **Example**: Using `tcpdump -i eth0 port 80` to intercept HTTP traffic and capture credentials.


#### **Troubleshooting**
Troubleshooting involves tools to resolve network errors or performance issues. 
- **Example**: Using `ping 8.8.8.8` to test connectivity to Google DNS or detect ICMP blocking.


#### **Hardening**
Hardening strengthens network defenses using tools like SELinux and TCP Wrappers. 
- **Example**: Identifying misconfigured AppArmor profiles with `aa-status` for exploitation.



### **Network Intrusion Detection**  
Intrusion Detection Systems (IDS) monitor network traffic to identify suspicious activities and potential security breaches. They detect and alert about unauthorized access or anomalous behavior. IDS can be signature-based (detect known patterns) or anomaly-based (detect deviations from normal behavior).
- **Attacker’s Perspective**: Evade detection by analyzing IDS rules and generating stealthy traffic patterns.


### **Network Reconnaissance**  
Network reconnaissance involves gathering information about a target network, including IP addresses, services, and vulnerabilities. This includes scanning networks, identifying open ports, and gathering information about the target's infrastructure.
- **Attacker’s Perspective**: Use tools like `nmap`, `nikto`, and `metasploit` to identify vulnerabilities and target specific services.


### **Network Penetration Testing**  
Network penetration testing involves simulating real-world attacks on a network to identify vulnerabilities and security gaps. This includes testing firewalls, routers, endpoints, and protocols to uncover exploitable weaknesses.
- **Attacker’s Perspective**: Leverage tools and techniques like port scanning, packet sniffing, and exploit frameworks to assess and exploit network vulnerabilities.


### **Network Forensics**  
Network forensics is the practice of capturing, analyzing, and preserving network traffic data to investigate security incidents. It helps identify attackers, their methods, and compromised data by examining logs, packets, and artifacts.
- **Attacker’s Perspective**: Cover tracks by tampering with logs, encrypting traffic, or using obfuscation techniques to complicate forensic analysis.


### **Network Defense**  
Network defense encompasses strategies and tools to protect networks from attacks. This includes firewalls, intrusion prevention systems (IPS), access control mechanisms, and network segmentation.
- **Attacker’s Perspective**: Analyze and bypass defensive mechanisms, exploit weak configurations, or disable security controls to compromise the network.


### **Remote Desktop Protocols in Linux**  
Remote desktop protocols allow graphical remote access to systems, commonly used for remote administration and troubleshooting. Attackers can leverage these protocols to gain unauthorized access, capture sensitive data, or manipulate system settings.

#### **XServer (X11)**
XServer facilitates graphical user interfaces on Unix/Linux systems. It uses TCP ports (6001-6009) for communication. Although X11 offers network transparency, it lacks encryption, making it vulnerable to attacks. X11 sessions can be tunneled through SSH for security.

- **Attacker's Perspective**: Exploit unencrypted X11 sessions to capture keystrokes, screenshots, or inject commands remotely.

#### **XDMCP**
XDMCP enables remote X Window sessions over UDP port 177. It is insecure due to a lack of encryption, making it susceptible to man-in-the-middle attacks.

- **Attacker's Perspective**: Intercept XDMCP traffic to gain unauthorized access to remote graphical interfaces.

#### **VNC (Virtual Network Computing)**
VNC allows remote desktop sharing based on the RFB protocol. It provides encryption and authentication but can be exploited if misconfigured.

- **Attacker's Perspective**: Exploit weak passwords, intercept traffic, or brute-force VNC services to gain remote desktop control.


---

## Linux Hardening

### **Linux Security**
Linux systems are generally considered more secure than many alternatives, such as Windows, due to their reduced attack surface and built-in security mechanisms. However, no system is impervious to threats, particularly if improperly configured or left unpatched. To ensure robust security, administrators must implement several best practices, tools, and configurations.
- 

#### **Key Principles of Linux Security**
1. **Keeping Systems Updated**  
   Keeping the operating system and all installed packages up to date is critical. Vulnerabilities in outdated software are one of the primary entry points for attackers. Regular updates reduce exposure to known exploits and ensure that the system is equipped with the latest security enhancements.
   - Command Example:  
     `apt update && apt dist-upgrade`

2. **Firewall and Network Controls**  
   - Use Linux firewalls and **iptables** to restrict traffic to/from the host. This reduces exposure to unnecessary services and mitigates risks associated with open network ports.
   - **iptables** is a powerful tool for configuring network traffic rules. It allows administrators to set up rules for filtering, logging, and redirecting network traffic based on source IP, destination IP, port, and protocol.
   - If firewall rules are not properly configured, we can use the Linux firewall and/or **iptables** to restrict traffic into/out of the host.

3. **SSH Security**  
   - Avoid password-based SSH logins by enforcing key-based authentication.  
   - Disable root login via SSH to minimize privilege escalation risks.  
   - If SSH is open on the server
      - Disallow password login
      - Disallow the root user from logging in via SSH.
   - Avoid logging or administering the system as the `root` user
   - Adequately managing access control.

4. **Principle of Least Privilege**  
   - Users' Access should be determined based on the principle of least privilege.
   - Limit user privileges to only what is necessary. Use tools like `sudo` to restrict specific commands instead of granting full administrative rights.  
   - Mismanaged user privileges are a common source of exploitation during penetration tests.
   - Avoid logging or administering the system as the `root` 
   - If a user needs to run a command as root, then that command should be specified in the **sudoers** configuration instead of giving them full sudo rights.

5. **Login Security**  
   - Tools like **fail2ban** can monitor login attempts and temporarily ban IPs that exceed a defined threshold of failed logins.  
      - This tool counts the number of failed login attempts, and if a user has reached the maximum number, the host that tried to connect will be handled as configured.
   - Enforce password policies, including complexity, aging, and reuse restrictions, to strengthen login defenses.  

6. **Auditing and Monitoring**  
   - Regular audits can reveal vulnerabilities such as outdated kernels, world-writable files, misconfigured cron jobs, or unnecessary SUID/SGID binaries.  
   - Tools like **chkrootkit**, **rkhunter**, and **Lynis** help detect rootkits, backdoors, misconfigurations, and other vulnerabilities.
      - [chkrootkit](https://www.chkrootkit.org/ "A tool to check for the presence of rootkits on a Unix/Linux system")
      - [rkhunter](https://packages.debian.org/sid/rkhunter "scans systems for known and unknown rootkits, backdoors, sniffers and exploits.")
      - [Lynis](https://cisofy.com/lynis/ "Lynis is a security auditing tool for your Linux system. It was written specifically for detecting misconfigurations and vulnerabilities.")
      - [Snort](https://www.snort.org/ "An open source, free and fast network intrusion detection system")

7. 
7. **Advanced Access Controls: SELinux and AppArmor**  
   **Security-Enhanced Linux (SELinux)** and **AppArmor** are kernel modules for mandatory access control.  
   - **SELinux**: Enforces fine-grained access controls by labeling processes, files, and directories. Policies dictate allowable interactions, preventing unauthorized access.  
   - **AppArmor**: Uses profiles to restrict application capabilities, offering simplified but effective access controls.

8. **TCP Wrappers**  
   TCP Wrappers restrict access to specific services based on client IP addresses or hostnames. Configuration is managed through the `hosts.allow` and `hosts.deny` files, allowing administrators to grant or deny service access granularly. These files can be configured by adding specific rules to the files. **TCP wrappers use the following configuration files:**
   - **/etc/hosts.allow**: specifies which services and hosts are allowed access to the system
   - **/etc/hosts.deny**: specifies which services and hosts are not allowed access to the system



9. **Hardening Measures**  
   - Remove / Disable unnecessary services and software.  
   - Remove services using unencrypted authentication mechanisms.  
   - Ensure time synchronization (NTP) and logging (Syslog) are enabled.  
   - Enforce user-specific accounts rather than shared logins.  
   - Set up password aging and restrict the use of previous passwords.  
   - Lock accounts after repeated failed login attempts.  
   - Disable core dumps and unwanted SUID/SGID binaries.  

10. **Safety as a Process**  
    Security is an ongoing process requiring regular updates, training, and familiarity with the system. Administrators who understand the nuances of their Linux environment can implement better and more effective protections.


### **Firewall Setup**
Firewalls are critical for managing and securing network traffic, ensuring only authorized connections and data exchanges occur between systems. Attackers often aim to identify and exploit misconfigured firewalls to bypass restrictions or access sensitive resources.
- **Misconfigured rules** can leave ports or services open to exploitation.
- **Weak filtering criteria** or excessive allowances can permit unauthorized access.
- **Outdated firewall tools or policies** may not handle modern threats effectively.


#### **Firewall Functions**
- **Monitor** -  Monitor and control traffic between network segments.
- **Filter** - Filter packets based on IP addresses, ports, and protocols.
- **Protect** - Protect systems from unauthorized access, DoS attacks, and malicious traffic.

#### **Linux Firewall Tools**
- **iptables**: Traditional and widely used command-line tool for managing firewall rules.
- **nftables**: Modern alternative to iptables with better performance and usability.
- **UFW (Uncomplicated Firewall)**: Simplifies iptables management for less technical users.
- **FirewallD**: Dynamic and flexible tool for complex configurations and zones.

#### **Key Components**
- **Tables**: Organize firewall rules by function (e.g., filtering, NAT, packet mangling).
- **Chains**: Group rules by traffic type (e.g., input, output, forward).
- **Rules**: Define filtering criteria and actions for matching packets.
- **Targets**: Actions to apply when rules match packets (e.g., ACCEPT, DROP, REJECT).

#### **Attack Surface**
- **Misconfigured rules**: Can leave ports or services open to exploitation.
- **Weak filtering criteria**: Can permit unauthorized access.
- **Outdated firewall tools or policies**: May not handle modern threats effectively.


### **Firewall Configuration**
- **Firewall Rules**: Define filtering criteria and actions for matching packets.
- **Firewall Tables**: Organize firewall rules by function (e.g., filtering, NAT, packet mangling).
- **Firewall Chains**: Group rules by traffic type (e.g., input, output, forward).
- **Firewall Targets**: Actions to apply when rules match packets (e.g., ACCEPT, DROP, REJECT).


### System Logs & Monitoring 
System logs on Linux provide valuable insights into system activities, user behavior, and potential security events. Attackers can exploit these logs to identify vulnerabilities, detect misconfigurations, or evade detection. Proper logging and monitoring configurations are critical to ensure a secure and robust system.

#### **Key Concepts**
- **Types of System Logs**:
  - **Kernel Logs**: Contain system-level events, driver activities, and kernel-related events. Useful for identifying hardware issues and kernel vulnerabilities.
  - **System Logs**: Record service activities, system reboots, and login attempts. Help identify system performance issues and unauthorized access.
  - **Authentication Logs**: Focus on login events, including successful and failed authentication attempts. Crucial for detecting brute-force attacks.
  - **Application Logs**: Track the behavior of applications such as Apache, MySQL, or SSH. Reveal potential vulnerabilities and misconfigurations.
  - **Security Logs**: Store events related to firewalls, intrusion prevention, and configuration changes. Useful for monitoring suspicious activities.
- **Log Analysis**:
  - Logs can reveal unauthorized access, attempted exploits, and system errors.
  - Reviewing logs after penetration tests ensures activities are detected and mitigated.
- **Log Configuration**:
  - Set proper log levels to capture relevant events.
  - Use log rotation to prevent large log files from overwhelming storage.
  - Protect logs against tampering or unauthorized access.
- **Log Monitoring Tools**:
  - Tools like **grep, tail, awk, and sed** are used for log filtering and analysis.
  - Centralized monitoring systems like **ELK Stack (Elasticsearch, Logstash, Kibana)** simplify large-scale log analysis.


#### **Example Workflow for Log Analysis**
1. Use `grep` to search authentication logs for failed login attempts:
   ```bash
   grep "Failed password" /var/log/auth.log
   ```
   - **Attacker’s Insight**: Identify accounts vulnerable to brute force.

2. Use `journalctl` to inspect recent SSH-related activity:
   ```bash
   journalctl -u sshd --since "1 hour ago"
   ```
   - **Attacker’s Insight**: Detect misconfigurations or access logs indicating admin activity.

3. Check Apache access logs for suspicious HTTP requests:
   ```bash
   cat /var/log/apache2/access.log | grep "wget"
   ```
   - **Attacker’s Insight**: Locate signs of file downloads or command injection attempts.
