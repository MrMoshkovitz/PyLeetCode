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


#### Technical Questions
Practical Tasks:
1. List all running processes
2. Trace the system calls of an running process
3. Monitor memory usage
4. Monitor disk usage
5. Monitor network traffic
6. Monitor firewall rules
7. List all processes consuming the highest CPU and memory (top, ps aux).
8. Simulate a zombie process and clean it up using kill.
9. Inspect the routing table using ip route and identify potential misconfigurations.
10. Set a SUID on a test script and detect it using find (find / -perm -4000).
11. Which processes have the highest CPU and memory usage?
12. Identify processes with root privileges.
13. Trace the system calls of an active process and find the process that is using the most memory.
14. Create a 2 zombie process, 1 root process, and 1 normal process.
15. Send signals using kill and pkill to kill the zombie processes.



