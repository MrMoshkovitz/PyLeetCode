# Linux Attackers View - Cheat Sheet


## Philosophy (Attacker’s Perspective)
- **Philosophy**: The design principles that make Linux so flexible (everything is a file, chaining small tools, etc.) also offer attackers a powerful toolkit.

| Principle                                             | Attacker’s Perspective                                                                                                                                                                  |
|-------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Everything is a file                                  | Since configuration files and other critical data are stored in plain text, attackers can modify or replace these files to gain persistence, escalate privileges, or steal sensitive data.                                           |
| Small, single-purpose programs                        | Each tool can be combined (chained) to automate malicious tasks (e.g., quickly scanning, enumerating, and exfiltrating). Attackers love modular approaches because they can mix and match small tools for flexible exploitation flows.  |
| Ability to chain programs together to perform complex tasks | Attackers leverage shell scripting and piping to chain commands together. This can streamline data gathering or automate the process of planting and hiding backdoors, making the attack process more efficient.                         |
| Avoid captive user interfaces                         | The shell-based design allows attackers to remain “headless” and blend in with normal administrative workflows. They can script actions without a graphical interface, reducing their footprint and detection chances.                  |
| Configuration data stored in a text file             | Sensitive information (e.g., user accounts, cron jobs, or key application configs) is often in these files. Attackers can modify or inject malicious instructions (like cron-based reverse shells) with a simple text edit.             |


---

## Components (Attacker’s Perspective)
- **Components**: Each component, from the bootloader to system utilities, presents unique opportunities for **privilege escalation**, **persistence**, and **stealth**.

| Component      | Attacker’s Perspective                                                                                                                                                           |
|----------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Bootloader     | Manipulating the bootloader or its configuration can grant attackers early-stage control, allowing them to load malicious kernel modules or bypass security measures before the OS is fully operational.                 |
| OS Kernel      | The kernel is a prime target for privilege escalation: exploiting kernel vulnerabilities can grant an attacker root-level access. Once compromised at the kernel level, nearly all system activities are exposed.       |
| Daemons        | Daemons run in the background, often with high privileges. Attackers may replace or hijack these services to ensure persistent footholds or to execute malicious tasks unnoticed.                                      |
| OS Shell       | Command-line interfaces are ideal for stealth and automation. Attackers can run commands, pivot within the system, and script their actions to blend in with legitimate admin usage.                                   |
| Graphics server| Typically less of a direct target for console-based attackers, but vulnerabilities here can enable privilege escalation or allow remote graphical-based access for advanced attacks.                                   |
| Window Manager | Most attackers focus on shell access, but if they can compromise the GUI environment, they can capture keystrokes, user credentials, or manipulate the user’s session for further exploitation.                         |
| Utilities      | Common system tools (e.g., `sed`, `awk`, `curl`) can be hijacked or leveraged to download malicious payloads, parse data for exfiltration, or chain together tasks for complex attacks.                                |


---

## Linux Architecture (Attacker’s Perspective)
- **Architecture**: Exploiting lower-level layers (kernel, hardware) yields the greatest control. Meanwhile, higher-level layers (shell, utilities) offer attackers **automation** and **access** to everyday admin actions.

| Layer          | Attacker’s Perspective                                                                                                                                                     |
|----------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Hardware       | Physical access to hardware (or the ability to control hardware peripherals) can allow attackers to implant keyloggers, tamper with disk contents, or intercept network communications.                            |
| Kernel         | Attacking the kernel is highly rewarding because kernel-level exploits let attackers bypass many security controls, gain root access, and maintain persistent stealth on the system.                               |
| Shell          | The CLI is an attacker’s playground—commands can be run silently, scripts can automate malicious tasks, and interactive shells allow real-time exploration and manipulation of the system.                         |
| System Utility | System utilities expose vital OS functionalities (e.g., package managers, cron schedulers). Attackers exploit these to install backdoors, exfiltrate data, or schedule malicious jobs under the guise of normal OS tasks. |

---




## File System Hierarchy
- An attacker’s interest in each directory is driven by the **potential impact** they can achieve—whether that’s **privilege escalation**, **persistence**, **data exfiltration**, or **stealthy communications**.
- Directories with **system-critical** files (like `/boot`, `/lib`, `/etc`) or **high-privilege executables** (like `/bin`, `/sbin`) are prime targets for attackers seeking **deep system control**.
- **World-writable** or **frequently ignored** locations (like `/tmp` or `/mnt`) are common places to **stage malicious tools** and files due to less scrutiny.

## Filesystem Hierarchy Attacker View Table
| Path   | Description                                                                                                                                                                   | Attacker’s Perspective                                                                                                                                                                                                                   |
|--------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `/`    | The top-level directory is the root filesystem. It contains all files needed to boot the OS and serves as the mount point for other filesystems.                              | **Potential “pivot point”** for accessing other directories. Attackers might place rootkits here, modify critical startup scripts, or otherwise alter the root environment to gain persistent access or hide malicious activities.         |
| `/bin` | Contains essential command binaries used by the system for basic operations (e.g., `ls`, `cp`, `mv`).                                                                          | **Executable tampering** is a key risk. Attackers might replace or trojan system binaries to maintain stealthy access, escalate privileges, or run malicious code under legitimate process names.                                       |
| `/boot`| Consists of the static bootloader, kernel, and files required to boot the Linux OS.                                                                                           | **Kernel-level compromise**. If an attacker gains write access, they could insert malicious kernel modules or tamper with bootloader files to execute malicious code at startup, before most defenses load.                              |
| `/dev` | Contains device files to facilitate access to hardware devices.                                                                                                                | **Device manipulation or covert channels**. Attackers might create or hide behind pseudo-devices (e.g., `/dev/tcp`) to exfiltrate data or establish hidden communication channels.                                                       |
| `/etc` | Local system configuration files. Often includes user accounts (`/etc/passwd`), groups, and configurations for applications and services.                                      | **Configuration sabotage or credential theft**. Attackers may edit critical configs, add malicious cron jobs, or steal hashed credentials from files like `/etc/shadow`.                                                               |
| `/home`| Each user on the system has a subdirectory here for personal storage.                                                                                                          | **User data and staging**. Attackers target user files for exfiltration. They may also store malicious scripts in user directories that seem “normal” and go unnoticed for longer.                                                      |
| `/lib` | Shared library files required for system boot and application runtime.                                                                                                         | **Library hijacking**. Attackers could replace legitimate libraries with malicious ones (LD_PRELOAD attacks) to run unauthorized code whenever a program linked to that library is executed.                                            |
| `/media`| External removable media devices such as USB drives are mounted here.                                                                                                        | **Data exfiltration**. Attackers might leverage removable media to quickly steal data or introduce malware. They might also target auto-mounted drives to spread malicious files.                                                      |
| `/mnt` | Temporary mount point for regular filesystems, used to mount various filesystems or disk images.                                                                               | **Temporary staging area**. An attacker might mount hidden or encrypted filesystems here to store tools or stolen data. Because it’s a known “temporary” space, suspicious files often draw less attention.                              |
| `/opt` | Optional files such as third-party applications or tools are often installed here.                                                                                             | **Installation of custom tooling**. Attackers can place custom malware, backdoors, or reconnaissance tools in `/opt`, masking them as legitimate third-party or optional applications.                                                 |
| `/root`| The home directory for the `root` (superuser).                                                                                                                                | **High-value compromise**. Gaining write access here indicates root privileges. An attacker may store scripts, SSH keys, or other malicious binaries to maintain high-level persistence.                                               |
| `/sbin`| Contains executables used for system administration (binaries that generally require root privilege to run).                                                                   | **Privilege escalation**. Attackers with root access might replace administrative tools to escalate privileges or create backdoors. Malicious usage could remain hidden if they mimic legitimate system administration commands.       |
| `/tmp` | Used by the OS and applications to store temporary files. Typically cleared on reboot but may be emptied at other times.                                                       | **Common malware staging**. Because `/tmp` is world-writable, attackers frequently drop payloads or run scripts here. They can also exploit race conditions or symlink attacks if permissions aren’t properly secured.                  |
| `/usr` | Contains executables, libraries, man pages, etc., for system-wide applications and utilities.                                                                                  | **Extended system attack surface**. Attackers might replace or add binaries in subdirectories like `/usr/bin` or `/usr/local/bin` to execute malicious code that blends in with legitimate user-installed programs.                     |
| `/var` | Contains variable data like logs, mail, web files, and other dynamically modified content.                                                                                     | **Log manipulation and data exfiltration**. Attackers may clear or forge logs to hide tracks. They might place malicious content in web-accessible directories or manipulate spool files to escalate privileges or exfil data.           |
