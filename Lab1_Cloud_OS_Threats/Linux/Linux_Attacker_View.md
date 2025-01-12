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








## User Management
User management is a core aspect of Linux system administration, encompassing tasks such as creating and managing users, assigning group memberships, and controlling user access.
For attackers, these capabilities enable reconnaissance of user accounts, privilege escalation, and persistence. Manipulating user accounts or groups can provide access to sensitive files and directories or create backdoors for continued access.
- **Core Functionality**: User management in Linux involves creating, modifying, and deleting user accounts, managing group memberships, and controlling user access.
- **Execution Context**: Commands like sudo and su allow users to execute commands as other users, including root, enabling attackers to escalate privileges or access sensitive files.
- **File and Directory Permissions**: User and group memberships determine access to files and directories, making user management essential for privilege escalation and lateral movement.
- **Importance for Attackers**: Misconfigurations or weak passwords can be exploited to gain unauthorized access, create backdoor accounts, or modify existing accounts for persistence.












--- 




# Attacker Commands
- **Tools & Commands**: Almost any built-in command can be weaponized—from simple listing utilities (ls, cat) to network (curl, netstat) and package management (apt, pip).

## Attacker Commands Cheat Sheet
Below is a **comprehensive Attacker Commands Cheat Sheet** in the style of your example. Where helpful, common sub-commands or flags have been included under each primary command (numbered), mirroring the **“Command / Description / Attacker’s Perspective”** format. Duplicates have been removed or consolidated.
- Commands that **administrators** use daily can be weaponized by attackers to **enumerate**, **exploit**, and **maintain** access.  
- Many of these commands have **sub-commands/flags** that reveal additional system details or **bypass** typical checks, making them invaluable for **stealthy operations**.  
- By thinking about each command from an **Attacker’s Perspective**, you can better understand how to **secure** and **monitor** your Linux environment.


---

### Helpful Commands

| **Command**                    | **Description**                                     | **Attacker’s Perspective**                                                                                     |
|--------------------------------|-----------------------------------------------------|----------------------------------------------------------------------------------------------------------------|
| **`man <tool>`**              | Opens manual pages for the specified tool.          | Study system utilities and flags to identify overlooked functionality or edge-case usage for exploits.         |
| **`<tool> -h`**               | Prints the help page of the tool.                   | Quickly discover command flags, unexpected features, or side effects for malicious use.                        |
| **`apropos <keyword>`**       | Searches man-page descriptions for a keyword.       | Locate commands (e.g., network or file utilities) to facilitate reconnaissance or tailor exploit paths.        |

---

### System Information Commands

| **Command**         | **Description**                           | **Attacker’s Perspective**                                                                                                                 |
|---------------------|-------------------------------------------|------------------------------------------------------------------------------------------------------------------------                    |
| **`uname`**           | Prints OS and hardware info.              | Tailor exploits to kernel/architecture or confirm if the system is virtualized.                                                            |
| | **1. `uname -a`**: Show all system info.                     | Identify **kernel name & version**, **hostname**, **Build Details**, **OS type**, and **architecture** to match with known vulnerabilities.|
| |**2. `uname -r`**: Display the kernel release version.       | Pinpoint kernel-specific privilege escalation exploits.                                                                                    |
| |**3. `uname -m`**: Show machine hardware name.               | Check if it’s 32-bit or 64-bit to load the right exploit binaries.                                                                         |

---

### User Information Commands

| **Command**  | **Description**             | **Attacker’s Perspective**                                                                              |
|--------------|-----------------------------|---------------------------------------------------------------------------------------------------------|
| **`whoami`**   | Displays current username. | Verify if you have escalated to `root` or confirm which user context you’re operating under.           |
| **`id`**       | Returns user ID info.      | Identify group memberships; spotting `sudo` or other privileged groups is crucial for escalation paths. |
| **`hostname`** | Prints/sets system name.   | Helps map or rename a host in multi-target scenarios, possibly to confuse defenders or logs.           |

---

### Directory Navigation Commands

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
| **Command**   | **Description**                      | **Attacker’s Perspective**                                                                                           |
|---------------|--------------------------------------|----------------------------------------------------------------------------------------------------------------------|
| **`ps`**        | Displays process status.             | Identify running processes (especially root processes) or security tools to kill/inject.                             |
| |**1. `ps aux`**: Show all processes with details.     | Quickly spot suspicious or high-privilege daemons.                                                                   |
| |**2. `ps -ef`**: Display full-format listing.         | View parent-child relationships for possible process injection or hijacking.                                         |
| **`kill / bg / jobs / fg`** | Process control commands. | Stop security software, hide malware in the background, or bring malicious processes to the foreground if needed.     |

---

### Environment Information Commands
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
| **Command** | **Description**                                           | **Attacker’s Perspective**                                                                                 |
|-------------|-----------------------------------------------------------|------------------------------------------------------------------------------------------------------------|
| **`sudo`**    | Executes commands as another user (often root).           | If misconfigured or accessible, it’s a direct route to privilege escalation.                               |
| **`su`**      | Switches user accounts.                                   | Attempt to become `root` or another privileged user if credentials are known or guessed.                   |
| **`useradd`** / **userdel** / **usermod** | Manage user accounts.                         | Create backdoor users, remove legitimate ones to sabotage admins, or modify accounts for persistence.     |
| **`addgroup`** / **delgroup**          | Manage groups.                               | Hide malicious accounts in custom groups or remove critical groups to break normal user access.           |
| **`passwd`**  | Changes user passwords.                                    | Lock out admins or set trivial passwords on newly created accounts.                                       |

---

### Package Management Commands

| **Command**                | **Description**                                   | **Attacker’s Perspective**                                                                                                  |
|----------------------------|---------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------|
| **`dpkg / apt / aptitude`**  | Debian-based package management.                  | Install malicious or outdated/vulnerable packages to escalate privileges or maintain a foothold.                            |
| **`snap`**                   | Manage Snap packages.                             | Hide backdoors in containerized snaps that appear legitimate.                                                              |
| **`gem / pip`**              | Ruby/Python package managers.                     | Install Trojanized libraries for code execution in rails/django/flask apps or scripts.                                     |
| **`git`**                    | Revision control system.                          | Clone or push malicious repositories; exfiltrate private code repos with embedded credentials.                              |

---

### System Management Commands

| **Command**    | **Description**                             | **Attacker’s Perspective**                                                                                  |
|----------------|---------------------------------------------|-------------------------------------------------------------------------------------------------------------|
| **`systemctl`**  | Manages services and system states.         | Start/stop or enable malicious services at boot; disable or mask security tools.                            |
| **`journalctl`** | Queries systemd logs.                       | Review, tamper, or clear logs to hide footprints of exploitation or lateral movement.                       |

---

### File Search Commands
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

