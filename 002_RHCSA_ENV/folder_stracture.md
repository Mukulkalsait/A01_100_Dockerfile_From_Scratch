# Folder Structure:

```
 002_RHCSA_ENV/
  ├── 1_arch/
  │   ├── config/
  │   │   ├──motd
  │   │   └──sshd_config
  │   ├── scripts/
  │   └── Dockerfile
  ├── 2_rocky/
  │   ├── config/
  │   ├── scripts/
  │   └── Dockerfile
  │
  ├── 3_ubi/
  │   ├── config/
  │   ├── scripts/
  │   └── Dockerfile
  │
  ├── 4_ubuntu/
  │   ├── config/
  │   ├── scripts/
  │   └── Dockerfile
  │
  │
  ├── disks/
  │    |->  1_arch (copy)    |->   disk1.img    disk2.img
  │    |->  2_rocky (copy)   |->   disk1.img    disk2.img
  │    |->  3_uib  (copy)    |->   disk1.img    disk2.img
  │    |->  4_ubuntu (copy)  |->   disk1.img    disk2.img
  │
  ├── info/
  │   ├── 1_shared_Folder_importance.md
  │   └── 2_why_degraded.md
  │
  ├── shared/
  │   ├── authorized_keys/
  │   ├── LM_check_ssh_working.sh
  │   └── LM_create_disk.sh
  │
  └── docker-compose.yaml

```


<!-- R: FROM registry.access.redhat.com/ubi10:latest AS builder -->
