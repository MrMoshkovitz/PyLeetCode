## Completed Tasks
1. [ x ] **Create Project ID** ✅
   <!-- Outputs -->
   - Name: `CloudXDR`
   - ID: `freemium-297909`

2. [ x ] **Configure IAM Service Account** ✅
   <!-- Outputs -->
   - Name: `cloud-sec-xdr-admin`
   - ID: `cloud-sec-xdr-admin`
   - Email: `cloud-sec-xdr-admin@freemium-297909.iam.gserviceaccount.com`

---

## Pending Tasks
3. [ ] **Create a VPC Network**
   - Name: `cloud-sec-xdr-vpc`
   - Subnet: `cloud-sec-xdr-subnet-1`
   - Region: `us-central1`
   - IP range: `10.10.0.0/28`
   - Firewall: 
      - IN: `allow-gm-all-inbound`
      - OUT: `allow-gm-all-outbound`
   <!-- - Router: `cloud-sec-xdr-router`
   - NAT: `cloud-sec-xdr-nat` -->

4. [ ] **Set up a VM Instance**
   - Name: `cloud-sec-xdr-vm-1`
   - ID: `[Auto-generated ID]`
   - Machine type: `e2-medium`
   - VPC: `cloud-sec-xdr-vpc`
   - Subnet: `cloud-sec-xdr-subnet-1`
   - Region: `us-central1`
   - Boot disk: `Ubuntu 20.04 LTS x86/64`
   - Boot disk size: `10GB`
   - Hostname: `cloud-sec-xdr-vm-1.lab1.linx.threat-analysis-detection.com`
   - Service Account: `cloud-sec-xdr-admin`


4. [ ] **Enable Compute Engine Services**
   - Go to the [Google Cloud Console](https://console.cloud.google.com/).
   - Enable the Compute Engine API for the `CloudXDR` project.

5. [ ] **Test SSH Access to VM**
   - SSH into the created VM using:
     - `gcloud compute ssh [VM_NAME] --zone [ZONE]`
   - Confirm connectivity and basic shell access.

6. [ ] **Explore Linux Basics (on VM)**
   1. [ ] **Filesystem & Permissions**
       - Review file permissions and practice `chmod`, `chown`, and `ls -l`.
   2. [ ] **Process Management**
       - Use `ps`, `top`, and `kill` commands to manage processes.
   3. [ ] **Memory Management**
       - Check memory usage with `free -h` and `vmstat`.
   4. [ ] **Networking**
       - Explore `netstat`, `ss`, and `ufw` for firewall settings.

7. [ ] **Secure the Environment**
   - Set up a custom IAM role for the service account:
     - Role Name: `xdr-vm-role`
     - Permissions: Minimum required for VM management.
   - Apply the role to the `cloud-sec-xdr-admin` service account.
