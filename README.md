# Build & Evaluate Arm CCA 

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

Then you need to open the container:

```
./scripts/run-container.sh
```

1-Create suplementary binaries to be included in the target file systems
```
./scripts/build-suplementary.sh
```

2-Run the following commands inside the container
```
./scripts/build-buildroot2.sh -e base
./scripts/build-buildroot.sh -e base
```

3-Build linux for both the hypervisor and the VM:
```
./scripts/build-linux.sh
```

Exit from container
```
exit
```

Build other necessary firmware including RMM and Trusted Monitor;
```
./scripts/build-firmware.sh
```

To run FVP for a particular experiment (for example base experiment):
```
./scripts/run-shrinkwrap.sh -e base
```
