# Build & Evaluate Arm CCA 

## 1-Initilization
Download git and set up yout a git account on the platfrom
```
sudo apt install git
git config --global user.name "<your-name>"
git config --global user.email "<your-email@example.com>"
```

To initially download the software stack and create appropriate file structure:

```
./scripts/download-source.sh
```
To create a docker container on your local device:

```
./scripts/install-docker.sh
./scripts/build-container.sh
```

To set up shrinkwrap on your device:
```
./scripts/install-shrinkwrap.sh
```
Log out and log in for changes to take effect
## 2-Build binary files

Build suplementary binaries to be included in the target file systems
```
./scripts/build-suplementary.sh
```
Build other necessary firmware including the RMM and Trusted Monitor
```
./scripts/build-firmware.sh
```

Open the container:

```
./scripts/run-container.sh
```
Build linux for both the hypervisor and the VM:
```
./scripts/build-linux.sh -e base
./scripts/build-linux-guest.sh -e base
```

Build the file systems of the hypervisor and the VM for a particular experiment (for example base experiment). 
```
./scripts/build-buildroot2.sh -e base
./scripts/build-buildroot.sh -e base
```
**Hint**: Each experiment has its own file system configuration and file overlays (files which are going to appear in the file system)

Exit from container
```
exit
```

## 3-Boot FVP and create a VM
To run FVP for a particular experiment (for example base experiment):
```
./scripts/run-shrinkwrap.sh -e base
```
The above opens a command line terminal for you. Now you have access to the file system created in the previous parts. 
If you are running the base experiment, there are several scripts to create a VM. For example running the following command will create 
a realm VM:

```
/root/create_realm_VM_100.sh
```

## 4-Evalution

