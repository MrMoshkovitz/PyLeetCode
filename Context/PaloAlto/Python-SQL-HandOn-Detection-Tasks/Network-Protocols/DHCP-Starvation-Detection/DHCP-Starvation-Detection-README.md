
## DHCP (Dynamic Host Configuration Protocol) Analysis and Detection

### Overview of DHCP

DHCP is a network management protocol used to dynamically assign an IP address and other network configuration parameters to devices on a network. While essential for network operations, DHCP can be exploited by attackers for various malicious activities.

### Key Characteristics of DHCP

- Operates on UDP ports 67 (server) and 68 (client)
- Automates IP address assignment and network configuration
- Vulnerable to attacks like DHCP starvation and rogue DHCP servers

### Common Attack Techniques

1. **DHCP Starvation**: Flooding the network with DHCP requests to exhaust the IP address pool.

2. **Rogue DHCP Server**: Setting up a malicious DHCP server to provide false network configurations.

3. **DHCP Spoofing**: Impersonating a legitimate DHCP server to distribute malicious configurations.

4. **Man-in-the-Middle (MitM) Attacks**: Intercepting DHCP traffic to manipulate network configurations.

5. **IP Address Exhaustion**: Preventing legitimate users from obtaining IP addresses.

### Detection Strategies

1. Monitor for unusual patterns in DHCP request and response traffic.
2. Detect multiple DHCP servers on the network, especially those not authorized.
3. Analyze DHCP lease times and request frequencies for anomalies.
4. Monitor for sudden spikes in DHCP requests from a single source.
5. Track changes in DHCP server configurations.

### Practical Hands-on Python Task

**Task Description**: Create a Python script to analyze DHCP server logs and detect potential DHCP starvation attacks. The script should identify clients making an unusually high number of DHCP requests within a short time frame.

### SQL Task for DHCP Analysis

**Task Description**: Write SQL queries to analyze DHCP log data stored in a relational database to identify potential rogue DHCP servers by detecting unauthorized IP address assignments.

### Logical Interview Questions on DHCP Security

1. How would you differentiate between a legitimate DHCP server and a rogue one in a large enterprise network?
2. Explain the concept of DHCP snooping and how it can be used to prevent DHCP-based attacks.
3. What are some indicators that might suggest a DHCP starvation attack is in progress?
4. How can DHCP be exploited for persistence by an attacker who has already gained a foothold in the network?
5. Describe the process of setting up a secure DHCP infrastructure in a multi-VLAN environment.
6. What are the security implications of using DHCP in a cloud environment compared to on-premises?
7. How would you investigate a sudden increase in DHCP NAK messages in your network logs?
8. Explain how an attacker might use DHCP to perform a MitM attack, and what detection strategies would you employ?
9. What are some best practices for securing DHCP servers against common attacks?
10. How can machine learning be applied to detect anomalous DHCP behavior in real-time?
