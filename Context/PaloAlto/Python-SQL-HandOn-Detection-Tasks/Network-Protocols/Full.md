# **Main Topics:**

## **Kerberos Protocol Analysis and Detection**

### **Overview of Kerberos**

Kerberos is a network authentication protocol designed to provide secure authentication over insecure networks. It uses secret-key cryptography to authenticate users and services, primarily in environments utilizing Active Directory (AD). Kerberos operates on TCP and UDP port 88\.

### **Key Characteristics of Kerberos**

- **Authentication vs. Authorization**: Kerberos identifies users and their privileges but does not validate their access level to resources. Each service must enforce its own authorization checks.  
    
- **Active Directory Integration**: Kerberos is integral to AD, where it is used for authenticating users and services within the domain.

### **Common Vulnerabilities**

#### **MS14-068 Vulnerability**

This vulnerability allows attackers to manipulate a valid domain user's logon token (TGT) by falsely claiming that the user is a member of sensitive groups like Domain Admins. This exploitation grants unauthorized access to resources across the AD forest.

### **Attack Techniques**

1. **Pass-the-Ticket (PTT)**:  
     
   - Attackers use stolen Kerberos tickets to impersonate users.  
   - Tickets can be extracted from memory using tools like Mimikatz.

   

2. **Overpass-the-Hash (Pass-the-Key)**:  
     
   - Attackers use NTLM hashes to request TGTs from the Key Distribution Center (KDC), allowing them to impersonate users without needing their passwords.

   

3. **Golden Ticket Attack**:  
     
   - Involves creating a TGT using the KRBTGT account hash, allowing attackers persistent access even after password changes.

   

4. **Kerberoasting**:  
     
   - Attackers request service tickets for service accounts and crack them offline, targeting weak passwords.

   

5. **ASREPRoasting**:  
     
   - Similar to Kerberoasting but targets accounts with the DONT\_REQ\_PREAUTH flag, allowing attackers to obtain encrypted tickets without needing a password.

### **Detection Strategies for Kerberos Attacks**

#### **Anomaly Detection Ideas**

- Monitor for unusual patterns in TGT requests, such as multiple requests from the same user or requests for non-existent service principal names (SPNs).  
- Detect failed authentication attempts that exceed normal thresholds, indicating potential password spraying or enumeration attempts.  
- Identify processes initiating Kerberos requests that are not typical for legitimate users or services.

#### **Cortex XDR Detection Capabilities**

Cortex XDR provides advanced detection capabilities through:

- **Behavioral Threat Protection**: Monitors for suspicious activities related to Kerberos ticket manipulation and unauthorized access attempts.  
    
- **RPC Tracking**: Observes RPC calls related to Kerberos operations, identifying anomalies in ticket requests and injections.  
    
- **Correlation with Active Directory Data**: Analyzes user privileges and delegation settings to detect misuse of credentials or unauthorized access attempts.

### **Summary for Blog Posts and Interview Cheat Sheets**

- **Kerberos is essential for secure authentication in Active Directory environments**, but it has notable vulnerabilities that attackers exploit through various techniques like PTT, Golden Ticket, and Kerberoasting.  
    
- **Detection strategies include monitoring for anomalies in ticket requests**, leveraging Cortex XDR's capabilities for behavioral analysis, RPC tracking, and correlation with AD data.  
    
- Practical exercises using Python and SQL can help reinforce understanding of detecting anomalous activities related to Kerberos authentication failures.

### **Kerberos Logical Questions**

1. What are the best practices for securing Kerberos implementations  
2. How can I monitor Kerberos traffic for suspicious activity  
3. What tools are available to test Kerberos security  
4. How do Kerberos attacks typically unfold  
5. What are the common signs of a Kerberos-based attack Base  
6. Describe the main components of the Kerberos authentication protocol and their roles in the authentication process.  
7. What are some common vulnerabilities or attack vectors associated with Kerberos, and how can they be mitigated?  
8. Explain the concept of "Kerberoasting" and how it can be detected in an enterprise environment.  
9. How does the "Golden Ticket" attack work in Kerberos, and what are some effective ways to prevent or detect it?  
10. Describe the process of "Pass-the-Ticket" in Kerberos attacks. How can Cortex XDR be used to identify this type of attack?  
11. What is the significance of the MS14-068 vulnerability in Kerberos, and how does it impact Active Directory environments?  
12. How would you design a detection mechanism for identifying abnormal Kerberos ticket granting ticket (TGT) requests in a large enterprise network?  
13. Explain the concept of "Silver Ticket" attacks in Kerberos. How do they differ from Golden Ticket attacks, and what are the detection challenges?  
14. What role does the Key Distribution Center (KDC) play in Kerberos, and how can it be secured against potential attacks?  
15. How would you use Cortex XDR to detect and investigate potential Kerberos-based lateral movement in an enterprise environment?  
16. Describe the process of implementing Kerberos constrained delegation and its security implications.  
17. How can machine learning algorithms be applied to detect anomalous Kerberos authentication patterns in large-scale networks?  
18. Explain the concept of "Overpass-the-Hash" in the context of Kerberos attacks. How does it differ from traditional Pass-the-Hash techniques?  
19. What are some best practices for securing service principal names (SPNs) in an Active Directory environment to prevent Kerberos-based attacks?  
20. How would you design a comprehensive monitoring strategy for Kerberos-related events in a hybrid cloud environment using Cortex XDR?  
21. These questions cover various aspects of Kerberos security, from basic concepts to advanced attack techniques and detection strategies, aligning with the focus areas for a Senior Network Security Researcher role at Palo Alto Networks.

### **Practical Exercises with Python/SQL**

\`

## Python Task

Create a Python script to analyze log data and detect potentially suspicious file upload activity across multiple cloud services. This script will help identify possible data exfiltration attempts.

## SQL Task

Create SQL queries to analyze the same log data stored in a relational database and identify potential data exfiltration attempts.


## **Remote Procedure Call (RPC) Protocol Analysis and Detection**

### **Overview of RPC**

Remote Procedure Call (RPC) is a protocol that allows a program to execute code on a remote system as if it were local. It is widely used for inter-process communication in enterprise environments, enabling seamless communication between distributed systems. However, its flexibility and widespread use make it a frequent target for attackers.

### **Common Vulnerabilities and Attack Techniques**

1. **Privilege Escalation**:  
     
   - Exploiting misconfigured access controls or vulnerabilities in RPC services to gain higher privileges.  
   - Example: CVE-2022-26809, a critical vulnerability allowing remote code execution with elevated privileges\[7\].

   

2. **Remote Code Execution (RCE)**:  
     
   - Attackers send maliciously crafted RPC requests to execute arbitrary code on the target machine\[7\].

   

3. **Service Enumeration**:  
     
   - Using tools like `rpcinfo` or `rpcclient` to enumerate services, users, and shares on a target system\[11\].

   

4. **Man-in-the-Middle (MitM) Attacks**:  
     
   - Intercepting and modifying RPC communication during transmission\[10\].

   

5. **Relay Attacks**:  
     
   - Leveraging vulnerabilities in authentication mechanisms to relay credentials or requests for unauthorized access\[4\].

   

6. **Buffer Overflow**:  
     
   - Exploiting poorly implemented RPC services to overwrite memory and execute arbitrary code\[10\].

### **Detection Strategies**

1. **Monitor for Anomalous RPC Activity**:  
     
   - High volume of RPC requests from a single source could indicate enumeration or brute-force attacks\[6\].  
   - Unusual RPC traffic patterns or connections from unexpected IPs.

   

2. **Detect Unauthorized Access Attempts**:  
     
   - Failed authentication attempts or access from unauthorized clients.

   

3. **Identify Lateral Movement**:  
     
   - Monitor for RPC connections between systems that do not typically communicate.

   

4. **Behavioral Analysis**:  
     
   - Use tools like Cortex XDR to detect anomalous behaviors, such as unusual service enumeration or privilege escalation attempts.  
1. 

### **Summary for Blog Posts and Interview Cheat Sheets**

- **Key Risks**: Privilege escalation, RCE, service enumeration, MitM attacks.  
- **Detection Ideas**: Monitor for high-volume requests, failed authentications, and anomalous traffic patterns.  
- **Mitigation Strategies**:  
  - Apply patches regularly to address known vulnerabilities.  
  - Restrict access to necessary systems using firewalls and ACLs.  
  - Enforce strong authentication mechanisms and disable null sessions.  
  - Use tools like Cortex XDR to detect behavioral anomalies in real-time.

### **RPC Logical Questions**

1. How would you differentiate between legitimate high-volume RPC traffic (e.g., backups) and malicious activity?  
2. What are the risks of enabling unauthenticated RPC services in an enterprise environment?  
3. Explain how you would mitigate lateral movement facilitated by compromised RPC services.  
4. Describe how you would secure an RPC service while maintaining its functionality.  
5. Explain how RPC works and its role in enterprise environments. What are some common use cases for RPC?  
6. What are the primary security risks associated with RPC, and how can organizations mitigate these risks?  
7. Describe the concept of "RPC enumeration" and how attackers might use it to gather information about a target network.  
8. How can an attacker leverage RPC to perform lateral movement within a network? Provide examples of techniques used in such attacks.  
9. Discuss the implications of the DCOM protocol in RPC communications. What security measures can be implemented to safeguard against DCOM-based attacks?  
10. What is the significance of monitoring RPC traffic, and what indicators should be watched for potential malicious activity?  
11. Explain how Cortex XDR can detect anomalies in RPC calls. What specific behaviors or patterns would trigger alerts?  
12. Describe a scenario where an attacker might use RPC to execute a remote command on a target system. How would you detect such an activity?  
13. What is the role of the ITaskSchedulerService in RPC, and how can it be exploited by an attacker? What detection mechanisms would you recommend?  
14. How does RPC tracking in Cortex XDR help prevent credential theft or unauthorized access attempts? Provide specific examples of detection capabilities.  
15. In what ways can improper configuration of RPC services lead to vulnerabilities in an enterprise environment? How would you secure these services?  
16. Discuss the importance of logging and monitoring RPC-related events for incident response. What types of logs would be most valuable for detecting RPC abuse?  
17. How can behavioral analytics be applied to identify suspicious RPC activity that may indicate an ongoing attack?  
18. What steps would you take to investigate an alert triggered by unusual RPC traffic from a known sensitive interface?  
19. How do you differentiate between legitimate administrative use of RPC and potential malicious activity when analyzing network traffic?  
20. 

### **Practical Exercises with Python/SQL**

\`

## Python Task

Create a Python script to Detect High-Volume Failed RPC Requests

## SQL Task

Querying Failed RPC Authentication Attempts

Create SQL queries to analyze the same log data stored in a relational database and identify potential data exfiltration attempts.

## **SMB (Server Message Block) Protocol Analysis and Detection**

Server Message Block (SMB) is a network file sharing protocol that allows applications on a computer to read and write to files and to request services from server programs in a computer network. While essential for file and printer sharing in Windows environments, SMB can also be exploited by attackers for lateral movement and data exfiltration.

### **Key Characteristics of SMB**

- Primarily used in Windows networks for file and printer sharing  
- Operates on TCP ports 445 (SMB over TCP) and 139 (NetBIOS)  
- Supports authentication and encryption  
- Vulnerable to various attacks like SMB relay, EternalBlue, and PetitPotam

### **Common Attack Techniques**

1. **SMB Relay Attacks**: Attackers intercept SMB authentication and relay it to another system to gain unauthorized access.  
     
2. **Lateral Movement**: Exploiting SMB to move between systems in a network after initial compromise.  
     
3. **Data Exfiltration**: Using SMB to transfer sensitive data out of the network.  
     
4. **Exploitation of Vulnerabilities**: Targeting known SMB vulnerabilities like EternalBlue (MS17-010).

### **Detection Strategies**

1. Monitor for unusual SMB traffic patterns, especially from non-standard processes.  
2. Track SMB connections to multiple hosts from a single source in a short time frame.  
3. Detect use of SMB by processes that don't typically use this protocol.  
4. Identify attempts to access sensitive shares or execute files over SMB.

### **SMB Logical Questions:**

1. How would you differentiate between legitimate administrative SMB activity and potential malicious behavior?  
2. Describe the process of an SMB relay attack and how it can be mitigated.  
3. What are some best practices for securing SMB in an enterprise environment?  
4. How can you detect and prevent unauthorized SMB traffic across network segments?  
5. Explain the concept of SMB signing and its importance in preventing certain types of attacks.  
6. Here are some additional logical questions related to Cortex XDR and network security, similar to the previous ones:  
7. How would you differentiate between legitimate large data transfers and potential data exfiltration attempts using Cortex XDR's "Large Upload" alerts?  
8. Explain the potential risks associated with modifying AWS SES Email sending settings. How could an attacker exploit this?  
9. What are some common indicators that a Kubernetes pod might be attempting to escape its container, and how can Cortex XDR help detect these attempts?  
10. Describe a scenario where multiple failed login attempts across different cloud services might indicate a coordinated attack rather than isolated incidents.  
11. How would you investigate a Cortex XDR alert indicating "Suspicious reconnaissance using LDAP"? What specific artifacts would you look for?  
12. In the context of Cortex XDR alerts, what are some key differences between "administrative behavior" and potential lateral movement activities?  
13. Explain how an attacker might leverage Azure Automation Runbooks for persistence. How can Cortex XDR help detect such activities?  
14. What are some potential security implications of a user accessing an abnormal number of files on remote shared folders, as detected by Cortex XDR?  
15. How might an attacker attempt to bypass or disable Exchange Safe Link and Safe Attachment policies? What Cortex XDR alerts might indicate such activity?  
16. Describe a scenario where legitimate business activities might trigger multiple Cortex XDR alerts related to cloud resource creation or modification. How would you differentiate this from potentially malicious activity?

### **Python and SQL Handon:**

#### **Python Task:**

Create a Python script to identify hosts initiating SMB connections and the connection details

#### **SQL Task:**

Create a SQL query to identify hosts initiating SMB connections to multiple destinations

## **HTTP and HTTPS Protocol Analysis and Detection**

### **Overview of HTTP/HTTPS**

HTTP (Hypertext Transfer Protocol) and its secure version HTTPS are the foundation of data communication on the World Wide Web. While HTTP transmits data in plain text, HTTPS encrypts the data using SSL/TLS, providing confidentiality and integrity.

### **Key Characteristics**

- HTTP uses port 80, HTTPS uses port 443  
- HTTPS provides encryption, data integrity, and authentication  
- Vulnerable to various attacks like man-in-the-middle, SSL stripping, and protocol downgrade

### **Common Attack Techniques**

1. **Man-in-the-Middle (MitM) Attacks**: Intercepting and potentially altering communication between client and server.  
     
2. **SSL Stripping**: Downgrading HTTPS connections to HTTP to intercept traffic.  
     
3. **Cross-Site Scripting (XSS)**: Injecting malicious scripts into web applications.  
     
4. **SQL Injection**: Inserting malicious SQL code into application queries.  
     
5. **HTTP Request Smuggling**: Exploiting differences in how front-end and back-end servers process HTTP requests.

### **Detection Strategies**

1. Monitor for unusual HTTP/HTTPS traffic patterns or connections to suspicious domains.  
2. Detect attempts to downgrade HTTPS to HTTP connections.  
3. Identify abnormal user-agent strings or header configurations.  
4. Track large data transfers or unusual file uploads via HTTP/HTTPS.

### **Practical Hands-on Python Task**

#### **Python Task**

Analyzing HTTP Status Codes for Potential Security Issues

#### **SQL Task**

Detecting Potential HTTP-based Attacks

### **HTTP / HTTPS Logical Interview Questions**

1. How would you differentiate between legitimate high-volume HTTP traffic and potential web scraping or scanning activities?  
2. Describe the process of SSL/TLS handshake in HTTPS. How can this process be exploited by attackers?  
3. What are some effective strategies to prevent and detect HTTP Request Smuggling attacks?  
4. How can you use HTTP headers to enhance security in web applications? Provide specific examples.  
5. Explain the concept of HTTP/2 server push. What are the security implications of this feature?  
6. How would you design a system to detect and prevent large-scale data exfiltration attempts via HTTPS?  
7. Describe the security risks associated with using HTTP Public Key Pinning (HPKP) and why it's been deprecated.  
8. How can Cortex XDR be leveraged to detect and investigate potential web application attacks like SQL injection or XSS?  
9. What are some indicators of a potential SSL stripping attack, and how would you detect them using network traffic analysis?  
10. Explain the concept of HTTP Strict Transport Security (HSTS) and its role in preventing downgrade attacks.

## **SMTP (Simple Mail Transfer Protocol) Analysis and Detection**

### **Overview of SMTP**

SMTP is a protocol used for sending emails across networks. It operates primarily on port 25 and is essential for email communication. While SMTP is widely used, it can also be exploited by attackers for various malicious activities, including spam distribution, data exfiltration, and unauthorized access.

### **Key Characteristics of SMTP**

- **Port Usage**: Typically operates over TCP port 25, but can also use ports 587 (submission) and 465 (secure SMTP).  
    
- **Plain Text Transmission**: By default, SMTP transmits data in plain text, making it susceptible to interception unless secured with TLS/SSL.  
    
- **Vulnerabilities**: Common vulnerabilities include open relays, lack of authentication, and susceptibility to spoofing.

### **Common Attack Techniques**

1. **Spam and Phishing**: Attackers use SMTP to send large volumes of spam emails or phishing attempts to trick users into revealing sensitive information.  
     
2. **Data Exfiltration**: Sensitive data can be sent out of an organization via email using SMTP.  
     
3. **Open Relay Exploitation**: Misconfigured mail servers can allow attackers to send emails through them without authentication.  
     
4. **Email Spoofing**: Attackers can forge the sender's address to make emails appear as if they are coming from a trusted source.  
     
5. **Malware Distribution**: Emails containing malicious attachments or links can be sent using SMTP.

### **Detection Strategies**

1. Monitor for unusual patterns in outgoing SMTP traffic, such as spikes in email volume or connections to multiple external SMTP servers.  
     
2. Identify unauthorized access attempts to the SMTP server or attempts to relay messages through it without proper authentication.  
     
3. Track the use of known malicious domains or IP addresses in outgoing email traffic.  
     
4. Analyze email headers for signs of spoofing or phishing attempts.

### **Practical Hands-on Python Task**

#### **Python Task**

**Task Description**: Create a Python script to analyze SMTP logs and detect potential spam or malicious email activity. The goal is to identify IP addresses that are sending an unusually high volume of emails within a specific time frame.

#### **SQL Task for SMTP Analysis**

**Task Description**: Write SQL queries to analyze the same SMTP log data stored in a relational database to identify potential spam activity and unauthorized access attempts.

### **Logical Interview Questions on SMTP Security**

1. How would you differentiate between legitimate bulk email campaigns and potential spam activity?  
2. Describe how an attacker might exploit an open relay in an SMTP server. What steps can be taken to secure against this vulnerability?  
3. Explain how you would monitor outgoing SMTP traffic for signs of data exfiltration.  
4. What are some best practices for configuring an SMTP server securely?  
5. Discuss the importance of SPF, DKIM, and DMARC in preventing email spoofing and ensuring email integrity.  
6. How can you detect and respond to a potential phishing attack that utilizes SMTP?  
7. Describe how you would investigate a spike in outgoing email traffic that may indicate a compromised account or spambot activity.  
8. What indicators would suggest that an internal user account is being used for malicious purposes via SMTP?  
9. How would you implement rate limiting on your SMTP server, and what impact could this have on legitimate users?  
10. Explain the role of TLS in securing SMTP communications and how it helps mitigate certain types of attacks.

## **DNS (Domain Name System) Protocol Analysis and Detection**

### **Overview of DNS**

DNS is a hierarchical and decentralized naming system for computers, services, or other resources connected to the Internet or a private network. It translates human-readable domain names to IP addresses, enabling users to access websites and other online services easily.

### **Key Characteristics of DNS**

- Operates primarily on UDP port 53, but can also use TCP port 53 for larger responses  
- Hierarchical structure with root servers, top-level domains, and subdomains  
- Caching mechanism to improve performance and reduce network traffic  
- Vulnerable to various attacks like DNS spoofing, cache poisoning, and tunneling

### **Common Attack Techniques**

1. **DNS Tunneling**: Encodes data in DNS queries and responses to bypass firewalls and exfiltrate data.  
     
2. **DNS Cache Poisoning**: Injects malicious DNS records into a DNS resolver's cache.  
     
3. **DNS Amplification**: Uses DNS servers to overwhelm a target with a flood of UDP packets.  
     
4. **DNS Hijacking**: Redirects DNS queries to malicious servers.  
     
5. **Fast Flux**: Rapidly changes IP addresses associated with a domain name to evade detection.  
     
6. **Domain Generation Algorithms (DGA)**: Creates numerous domain names to avoid blacklisting.

### **Detection Strategies**

1. Monitor for unusual patterns in DNS traffic, such as high volumes of requests or responses.  
2. Analyze DNS query lengths and entropy to detect potential data exfiltration.  
3. Track failed DNS lookups to identify potential DGA activity.  
4. Monitor for unusual TXT record queries, which may indicate command and control communication.  
5. Detect anomalous DNS traffic to rare or newly registered domains.

### **Practical Hands-on Python Task**

#### **Python Task for DNS Analysis**

**Task Description**: Create a Python script to analyze DNS logs and detect potential DNS tunneling activity. The goal is to identify hosts making an unusually high number of DNS requests to rare domains, which could indicate data exfiltration attempts.

#### **SQL Task for DNS Analysis**

**Task Description**: Write SQL queries to analyze the same DNS log data stored in a relational database to identify potential DNS tunneling activity.

### **Logical Interview Questions on DNS Security**

1. How would you differentiate between legitimate high-volume DNS traffic and potential DNS tunneling activity?  
2. Explain the concept of DNS cache poisoning and how it can be detected in an enterprise environment.  
3. What are some indicators that might suggest a Domain Generation Algorithm (DGA) is being used by malware in your network?  
4. How can DNS-based data exfiltration be prevented or detected in a corporate network?  
5. Describe the process of a DNS amplification attack and how it can be mitigated.  
6. What are the security implications of using DNS over HTTPS (DoH) in an enterprise environment?  
7. How would you investigate a sudden spike in NXDOMAIN responses in your DNS logs?  
8. Explain the concept of Fast Flux DNS and how it can be used by attackers to evade detection.  
9. What are some best practices for securing DNS servers against common attacks?  
10. How can machine learning be applied to detect anomalous DNS traffic patterns in large-scale networks?
## **DHCP (Dynamic Host Configuration Protocol) Analysis and Detection**

### **Overview of DHCP**

DHCP is a network management protocol used to dynamically assign an IP address and other network configuration parameters to devices on a network. While essential for network operations, DHCP can be exploited by attackers for various malicious activities.

### **Key Characteristics of DHCP**

- Operates on UDP ports 67 (server) and 68 (client)  
- Automates IP address assignment and network configuration  
- Vulnerable to attacks like DHCP starvation and rogue DHCP servers

### **Common Attack Techniques**

1. **DHCP Starvation**: Flooding the network with DHCP requests to exhaust the IP address pool.  
     
2. **Rogue DHCP Server**: Setting up a malicious DHCP server to provide false network configurations.  
     
3. **DHCP Spoofing**: Impersonating a legitimate DHCP server to distribute malicious configurations.  
     
4. **Man-in-the-Middle (MitM) Attacks**: Intercepting DHCP traffic to manipulate network configurations.  
     
5. **IP Address Exhaustion**: Preventing legitimate users from obtaining IP addresses.

### **Detection Strategies**

1. Monitor for unusual patterns in DHCP request and response traffic.  
2. Detect multiple DHCP servers on the network, especially those not authorized.  
3. Analyze DHCP lease times and request frequencies for anomalies.  
4. Monitor for sudden spikes in DHCP requests from a single source.  
5. Track changes in DHCP server configurations.

### **Practical Hands-on Python Task**

**Task Description**: Create a Python script to analyze DHCP server logs and detect potential DHCP starvation attacks. The script should identify clients making an unusually high number of DHCP requests within a short time frame.

### **SQL Task for DHCP Analysis**

**Task Description**: Write SQL queries to analyze DHCP log data stored in a relational database to identify potential rogue DHCP servers by detecting unauthorized IP address assignments.

### **Logical Interview Questions on DHCP Security**

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
