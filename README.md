# Build & Evaluate Arm CCA 

## 1-Initilization
To initially download the software stack and create appropriate file structure:

```
./scripts/download-source.sh
```

To create a docker container on your local device:

```
./scripts/install-docker.sh
./scripts/build-container.sh
```

Log out and log in for changes to take effect

To set up shrinkwrap on your device:
```
./scripts/install-shrinkwrap.sh
```

## 2-Build binary files
Open the container:

```
./scripts/run-container.sh
```

Build suplementary binaries to be included in the target file systems
```
./scripts/build-suplementary.sh
```

Build the file systems of the hypervisor and the VM for a particular experiment (for example base experiment). 
```
./scripts/build-buildroot2.sh -e base
./scripts/build-buildroot.sh -e base
```
**Hint**: Each experiment has its own file system configuration and file overlays (files which are going to appear in the file system)


Build linux for both the hypervisor and the VM:
```
./scripts/build-linux.sh
./scripts/build-linux-guest.sh
```

Exit from container
```
exit
```

Build other necessary firmware including the RMM and Trusted Monitor;
```
./scripts/build-firmware.sh
```

## 3-Run FVP
To run FVP for a particular experiment (for example base experiment):
```
./scripts/run-shrinkwrap.sh -e base
```
## 4-Evalution
