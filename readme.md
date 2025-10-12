+-------------------------------------+
|               VPC A                 |
|  CIDR: 10.100.0.0/16                |
|                                     |
|  +----------------+  +------------+ |
|  | Public Subnet  |  | Private    | |
|  | 10.100.1.0/24  |  | Subnet     | |
|  |                |  | 10.100.11.0/24|
|  | +------------+ |  | +--------+ | |
|  | | EC2        | |  | | EC2    | | |
|  | | Instance   | |  | | Instance| | |
|  | | (Public IP)| |  | | (No Public| |
|  | +------------+ |  | | IP)     | | |
|  +----------------+  +------------+ |
|         |                  |        |
|         | IGWA             |        |
|         | (Internet        |        |
|         |  Gateway)        |        |
+---------|------------------|--------+
          |                  |
          |                  |
    Internet Access     No Internet Access
      (0.0.0.0/0)       (VPC Internal Only)

---

**Agent forwarding**

# Start the SSH agent
eval "$(ssh-agent -s)"

# Add your private key to the agent
ssh-add ./vpckey.pem

# Verify the key was added
ssh-add -L

---

**Site-to-Site VPN**

![Demo image](hybridconnectivity.png)

- Traffic still flows through the public internet and there are still packet drops etc..

![Demo image](site2siteimp.png)

![Demo image](hybridconnectivity2.png)

![Demo image](site2site.png)

![Demo image](site2sitesteps.png)

