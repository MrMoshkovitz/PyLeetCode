| **Name**             | **Format**    | **Meaning**                                      | **Exception**                                  |
|-----------------------|---------------|--------------------------------------------------|-----------------------------------------------|
| a[0-3]               | numeric       | the arguments to a syscall                       | syscall                                       |
| a[[:digit:]+][.*]    | encoded       | the arguments to the execve syscall             | execve                                       |
| acct                 | encoded       | a user's account name                           |                                               |
| acl                  | alphabet      | access mode of resource assigned to vm          |                                               |
| action               | numeric       | netfilter packet disposition                    |                                               |
| added                | numeric       | number of new files detected                    |                                               |
| addr                 | encoded       | the remote address that the user is connecting from |                                               |
| apparmor             | encoded       | apparmor event information                      |                                               |
| arch                 | numeric       | the elf architecture flags                      |                                               |
| argc                 | numeric       | the number of arguments to an execve syscall    |                                               |
| audit_backlog_limit  | numeric       | audit system's backlog queue size               |                                               |
| audit_backlog_wait_time | numeric    | audit system's backlog wait time                |                                               |
| audit_enabled        | numeric       | audit system's enable/disable status            |                                               |
| audit_failure        | numeric       | audit system's failure mode                     |                                               |
| auid                 | numeric       | login user ID                                   |                                               |
| banners              | alphanumeric  | banners used on printed page                   |                                               |
| bool                 | alphanumeric  | name of SELinux boolean                        |                                               |
| bus                  | alphanumeric  | name of subsystem bus a vm resource belongs to |                                               |
| capability           | numeric       | posix capabilities                              |                                               |
| cap_fe               | numeric       | file assigned effective capability map          |                                               |
| cap_fi               | numeric       | file inherited capability map                   |                                               |
| cap_fp               | numeric       | file permitted capability map                   |                                               |
| cap_fver             | numeric       | file system capabilities version number         |                                               |
| cap_pe               | numeric       | process effective capability map                |                                               |
| cap_pi               | numeric       | process inherited capability map                |                                               |
| cap_pp               | numeric       | process permitted capability map                |                                               |
| category             | alphabet      | resource category assigned to vm                |                                               |
| cgroup               | encoded       | path to cgroup in sysfs                         |                                               |
| changed              | numeric       | number of changed files                         |                                               |
| cipher               | alphanumeric  | name of crypto cipher selected                  |                                               |
| class                | alphabet      | resource class assigned to vm                   |                                               |
| cmd                  | encoded       | command being executed                          |                                               |
| code                 | numeric       | seccomp action code                             |                                               |
| comm                 | encoded       | command line program name                       |                                               |
| compat               | numeric       | is_compat_task result                           |                                               |
| cwd                  | encoded       | the current working directory                   |                                               |
| daddr                | alphanumeric  | remote IP address                               |                                               |
| data                 | encoded       | TTY text                                        |                                               |
| default-context      | alphanumeric  | default MAC context                             |                                               |
| dev                  | numeric       | in path records, major and minor for device     |                                               |
| dev                  | alphanumeric  | device name as found in /dev                    | avc                                           |
| device               | encoded       | device name                                     |                                               |
| dir                  | encoded       | directory name                                  |                                               |
| direction            | alphanumeric  | direction of crypto operation                  |                                               |
| dmac                 | numeric       | remote MAC address                              |                                               |
| dport                | numeric       | remote port number                              |                                               |
| egid                 | numeric       | effective group ID                              |                                               |
| enforcing            | numeric       | new MAC enforcement status                      |
