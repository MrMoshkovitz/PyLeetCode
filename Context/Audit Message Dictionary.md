| MACRO NAME                | VALUE | ORIGIN | CLASS | DESCRIPTION                                           |
|---------------------------|-------|--------|-------|-------------------------------------------------------|
| AUDIT_GET                | 1000  | USER   | CTL   | Get status                                            |
| AUDIT_SET                | 1001  | USER   | CTL   | Set status (enable/disable/auditd)                   |
| AUDIT_LIST               | 1002  | USER   | DEP   | List syscall rules -- deprecated                     |
| AUDIT_ADD                | 1003  | USER   | DEP   | Add syscall rule -- deprecated                       |
| AUDIT_DEL                | 1004  | USER   | DEP   | Delete syscall rule -- deprecated                    |
| AUDIT_USER               | 1005  | USER   | DEP   | Message from userspace -- deprecated                 |
| AUDIT_LOGIN              | 1006  | KERN   | IND   | Define the login ID and information                  |
| AUDIT_WATCH_INS          | 1007  | USER   | DEP   | Insert file/dir watch entry                          |
| AUDIT_WATCH_REM          | 1008  | USER   | DEP   | Remove file/dir watch entry                          |
| AUDIT_WATCH_LIST         | 1009  | USER   | DEP   | List all file/dir watches                            |
| AUDIT_SIGNAL_INFO        | 1010  | USER   | CTL   | Get info about sender of signal to auditd            |
| AUDIT_ADD_RULE           | 1011  | USER   | CTL   | Add syscall filtering rule                           |
| AUDIT_DEL_RULE           | 1012  | USER   | CTL   | Delete syscall filtering rule                        |
| AUDIT_LIST_RULES         | 1013  | USER   | CTL   | List syscall filtering rules                         |
| AUDIT_TRIM               | 1014  | USER   | CTL   | Trim junk from watched tree                          |
| AUDIT_MAKE_EQUIV         | 1015  | USER   | CTL   | Append to watched tree                               |
| AUDIT_TTY_GET            | 1016  | USER   | CTL   | Get TTY auditing status                              |
| AUDIT_TTY_SET            | 1017  | USER   | CTL   | Set TTY auditing status                              |
| AUDIT_SET_FEATURE        | 1018  | USER   | CTL   | Turn an audit feature on or off                      |
| AUDIT_GET_FEATURE        | 1019  | USER   | CTL   | Get which features are enabled                       |
| AUDIT_USER_AUTH          | 1100  | USER   | IND   | User system access authentication                    |
| AUDIT_USER_ACCT          | 1101  | USER   | IND   | User system access authorization                     |
| AUDIT_USER_MGMT          | 1102  | USER   | IND   | User account attribute change                        |
| AUDIT_CRED_ACQ           | 1103  | USER   | IND   | User credential acquired                             |
| AUDIT_CRED_DISP          | 1104  | USER   | IND   | User credential disposed                             |
| AUDIT_USER_START         | 1105  | USER   | IND   | User session start                                   |
| AUDIT_USER_END           | 1106  | USER   | IND   | User session end                                     |
| AUDIT_USER_AVC           | 1107  | USER   | IND   | User space AVC (Access Vector Cache) message         |
| AUDIT_USER_CHAUTHTOK     | 1108  | USER   | IND   | User account password or PIN changed                |
| AUDIT_USER_ERR           | 1109  | USER   | IND   | User account state error                             |
| AUDIT_CRED_REFR          | 1110  | USER   | IND   | User credential refreshed                            |
| AUDIT_USYS_CONFIG        | 1111  | USER   | IND   | User space system config change                      |
| AUDIT_USER_LOGIN         | 1112  | USER   | IND   | User has logged in                                   |
| AUDIT_USER_LOGOUT        | 1113  | USER   | IND   | User has logged out                                  |
| AUDIT_ADD_USER           | 1114  | USER   | IND   | User account added                                   |
| AUDIT_DEL_USER           | 1115  | USER   | IND   | User account deleted                                 |
| AUDIT_ADD_GROUP          | 1116  | USER   | IND   | Group account added                                  |
| AUDIT_DEL_GROUP          | 1117  | USER   | IND   | Group account deleted                                |
| AUDIT_DAC_CHECK          | 1118  | USER   | IND   | User space DAC check results                         |
| AUDIT_CHGRP_ID           | 1119  | USER   | IND   | User space group ID changed                          |
| AUDIT_TEST               | 1120  | USER   | IND   | Used for test success messages                       |
| AUDIT_TRUSTED_APP        | 1121  | USER   | IND   | Trusted app msg - freestyle text                    |
| AUDIT_USER_SELINUX_ERR   | 1122  | USER   | IND   | SELinux user space error                            |
| AUDIT_USER_CMD           | 1123  | USER   | IND   | User shell command and args                         |
| AUDIT_USER_TTY           | 1124  | USER   | IND   | Non-ICANON TTY input meaning                        |
| AUDIT_CHUSER_ID          | 1125  | USER   | IND   | Changed user ID supplemental data                   |
| AUDIT_GRP_AUTH           | 1126  | USER   | IND   | Authentication for group password                   |
| AUDIT_SYSTEM_BOOT        | 1127  | USER   | IND   | System boot                                         |
| AUDIT_SYSTEM_SHUTDOWN    | 1128  | USER   | IND   | System shutdown                                     |
| AUDIT_SYSTEM_RUNLEVEL    | 1129  | USER   | IND   | System runlevel change                              |
| AUDIT_SERVICE_START      | 1130  | USER   | IND   | Service (daemon) start                              |
| AUDIT_SERVICE_STOP       | 1131  | USER   | IND   | Service (daemon) stop                               |
| AUDIT_GRP_MGMT           | 1132  | USER   | IND   | Group account attribute was modified                |
| AUDIT_GRP_CHAUTHTOK      | 1133  | USER   | IND   | Group account password or PIN changed               |
| AUDIT_MAC_CHECK          | 1134  | USER   | IND   | User space MAC (Mandatory Access Control) decision results |
