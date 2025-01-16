**Course Book: Phase 1 - Introduction to Attacker Methodologies and TTPs**

---

# **Chapter 1: Understanding the Threat Landscape**
### Objectives:
- Explore the modern threat landscape.
- Recognize the goals of attackers.
- Understand the importance of the MITRE ATT&CK Framework.

### Key Topics:
1. **Attacker Goals:**
   - Credential Theft: Techniques like keylogging, phishing, and Mimikatz.
   - Privilege Escalation: Exploiting vulnerabilities, manipulating SUID files.
   - Lateral Movement: Using tools like PsExec, pass-the-hash attacks.
   - Data Exfiltration: DNS tunneling, HTTP beaconing.

2. **The MITRE ATT&CK Framework:**
   - Overview of tactics and techniques.
   - Mapping real-world attacks to the framework.
   - Example: Mapping the SolarWinds breach to ATT&CK.

3. **Case Study: SolarWinds Breach**
   - Overview of the attack lifecycle.
   - Key lessons for detection and prevention.

### Learning Tools:
- **Infographic:** MITRE ATT&CK tactic-to-technique mapping.
- **Cheat Sheet:** Top 10 attacker goals and their common methods.

---

# **Chapter 2: Attacker Tactics, Techniques, and Procedures (TTPs)**
#### Objectives:
- Dive deep into TTPs used by Advanced Persistent Threats (APTs).
- Recognize patterns across different attacker methodologies.

#### Key Topics:
1. **TTP Exploration:**
   - Persistence techniques: Registry edits, startup folder modifications.
   - Evasion tactics: Packing, obfuscation, disabling endpoint protection.
   - Execution: PowerShell scripts, LOLBins (Living off the Land Binaries).

2. **Real-World APTs:**
   - APT29 (Cozy Bear): Techniques, targets, and lessons.
   - Case study: Shirbit ransomware attack.

3. **Practical Application:**
   - Simulating a basic APT scenario in a controlled lab.

#### Learning Tools:
- **Mind Map:** Common TTPs and their detection strategies.
- **Annotated Diagram:** Step-by-step lateral movement example.

---

# **Chapter 3: Building Detection Skills**
#### Objectives:
- Develop skills to detect attacker activities using enterprise logs.
- Practice creating detection hypotheses.

#### Key Topics:
1. **Host-Based Detection:**
   - Indicators in logs: Event ID 4624 (logins), anomalous parent-child processes.
   - Detection tools: Sysmon, ELK stack.

2. **Network-Based Detection:**
   - Analyzing traffic patterns for anomalies.
   - Tools: Wireshark, tcpdump.

3. **Threat Hunting:**
   - Using the Pyramid of Pain to guide hunting efforts.
   - Practical: Write YARA rules for known malware samples.

#### Hands-On Tasks:
- Lab: Simulate and detect an attack using Wireshark.
- Exercise: Map APT29’s tactics to MITRE ATT&CK.

---

# **Chapter 4: Advanced Attack Simulation**
#### Objectives:
- Simulate realistic attacks to understand attacker workflows.
- Analyze simulated attacks to identify weak points in detection strategies.

#### Key Topics:
1. **Simulation Tools:**
   - Atomic Red Team for TTP simulation.
   - Using Caldera for adversary emulation.

2. **Defensive Insights:**
   - Common pitfalls in detection strategies.
   - Correlation of logs across endpoints and networks.

3. **Guided Scenario:**
   - Simulate a phishing attack leading to lateral movement.

#### Learning Tools:
- **Flowchart:** Attack lifecycle visualized (from initial access to exfiltration).
- **Flashcards:** Common artifacts of specific TTPs.

---

# **Chapter 5: Behavioral Interview Preparation**
#### Objectives:
- Prepare candidates to articulate their technical and leadership skills.
- Practice responding to behavioral questions.

#### Key Topics:
1. **Using the STAR Method:**
   - Situation, Task, Action, Result.
   - Example: "Describe a time you identified a critical misconfiguration and resolved it."

2. **Mock Questions:**
   - “How would you approach detecting lateral movement in a network?”
   - “Can you walk us through an incident you handled end-to-end?”

3. **Tips for Non-Technical Interviewers:**
   - Simplifying complex technical concepts.

---

### **Interactive Learning Components**
#### Quizzes & Challenges:
1. Gamified quiz: Match TTPs to their associated tools and frameworks.
2. Capture the Flag (CTF): Solve challenges based on simulated APT scenarios.

#### Role-Playing Scenarios:
- Take on roles of attacker and defender to understand both perspectives.

#### Cloud-Based Labs:
- AWS-based environment to practice detecting simulated attacks.

---

### **Additional Resources**
1. **Bibliography:**
   - MITRE ATT&CK official documentation.
   - Threat intelligence blogs (Mandiant, CrowdStrike).

2. **Video Tutorials:**
   - Setting up a detection lab.
   - Analyzing attacker behaviors step by step.

3. **Portfolio Templates:**
   - Record lab exercises.
   - Document detection strategies and analysis.

---

### **Evaluation & Next Steps**
1. **Knowledge Checklists:**
   - Self-assess proficiency in understanding TTPs, detection methods, and tools.

2. **Mock Interview Sessions:**
   - Combine technical and behavioral questions for a comprehensive review.

3. **Preparation for Phase 2:**
   - Focus on endpoint detection and malware analysis.

**End of Phase 1: Mastering the Foundation of Attacker Methodologies and TTPs**.

