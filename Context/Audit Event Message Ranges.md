Audit Event Message Ranges
| **Range**  | **Description**                                        |
|------------|--------------------------------------------------------|
| 1000-1099  | Commanding the audit system                            |
| 1100-1199  | User space trusted application messages                |
| 1200-1299  | Messages internal to the audit daemon                  |
| 1300-1399  | Audit event messages                                   |
| 1400-1499  | Kernel SELinux use                                     |
| 1500-1599  | AppArmor events                                        |
| 1500-1599  | Kernel LSPP events                                     |
| 1600-1699  | Kernel crypto events                                   |
| 1700-1799  | Kernel anomaly records                                 |
| 1800-1899  | Kernel integrity labels and related events             |
| 1900-1999  | Future kernel use                                      |
| 2000       | Otherwise unclassified kernel audit messages (legacy)  |
| 2001-2099  | Unused (kernel)                                        |
| 2100-2199  | User space anomaly records                             |
| 2200-2299  | User space actions taken in response to anomalies      |
| 2300-2399  | User space generated LSPP events                       |
| 2400-2499  | User space crypto events                               |
| 2500-2599  | User space virtualization management events            |
| 2600-2999  | Future user space (maybe integrity labels and related events) |
