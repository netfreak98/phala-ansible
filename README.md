This is still a work in progress!

This Ansible script installes all requirements to build a functioning PHALA system, which can run
the node, runtime or host elements. During installation it will test if your system is supported
and enables SGX in the BIOS, so generally speaking once this script has been completed you can start
the processes. This playbook has been build so that you can deply this on a single machine or 
thousands at the same time, all identically installed. Large farms can also combine this with PXE
booted installers to finish off installing nodes.

The Ansbile script will
- Update your system to the latest packages, kernel, etc. and will reboot in needed
- Install all packages, drivers and dependancies
- Install precompiled installers and binaries to run Phala elements
- Runs SGX testing to make sure your system can run Phala

If the script completed without errors, you are ready to go. If there is an error, you can re-run this
script as many times as you want. This will not affect the installation, unless you have customized it.

Requirements:
- Ubuntu 18.05 LTS installation
- Networking configured with an reachable IP
- Enabled SSH for remote access
- Internet access must be available
- A user (non-Root) with full sudo permissions
- Hardware that supports SGX, this script does NOT support software mode
- Each CPU core must be met with 2GB of system memory (if 4 CPU then 8 GB of RAM is needed)

inside vars/main.yml
- select a driver (legacy or dcap)
- select a run method (docker or systemd)

Running remotely:

create a file inside the base directory called 'hosts', and inside place (you can add as many IP address
as you want ... but you cannot use localhost, a remote install is required due to required reboots):

```
[miners]
10.80.0.201
10.81.2.203

[miners:vars]
ansible_python_interpreter=/usr/bin/python3
```

ansible-playbook -i hosts install.yml

TODO:
- Make docker install default=true
  - Add variable for docker user/key
  - install docker containers
- Make systemd install default=false
  - add versions for node, runtime and host
  - combined with systemd and configs

