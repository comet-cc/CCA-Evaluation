# Build & Evaluate Arm CCA 

This respository aims to provide a comprehensive, easy-to-use platform to build and simulate Arm CCA software stack. Instructions to build all necessary components as well as customizations are provided. To emulate the hardware, we use
([Fixed Virtual Platform](https://developer.arm.com/Tools%20and%20Software/Fixed%20Virtual%20Platforms)), a free platform provided by Arm that emulates Armv9-A architecture. Further guide is provided to measure the overhead of running workloads within Arm CCA. We use Arm tracing tools in conjuction with FVP to measure number of instructions executed by FVP's core during execution of the target workload.
 
## 1 Initilization
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

To set up [Shrinkwrap](https://shrinkwrap.docs.arm.com/en/latest/overview.html) on your device:
```
./scripts/install-shrinkwrap.sh
```
Log out and log in for changes to take effect
## 2 Build binary files

Build suplementary binaries to be included in the target file systems
```
./scripts/build-suplementary.sh
```
Build other necessary firmware including the RMM and Trusted Monitor
```
./scripts/build-firmware.sh
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

## 3 Boot FVP and create a VM
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

## 4 Evalution
In order to evaluate CCA, we introduce a method to measure number of instrcution executed by the FVP's core between two points in the code. This methods requires three
steps. a) Enabling tracing in FVP, b) Add markers to the code running in FVP (e.g. inference code), these markers guide the tracing platform to capture some information about the FVP at the time of running the marker, and c) Analizing the final tracing file using the python code we provide. Note that our method is adapted from the tracing method used in [Acai](https://github.com/sectrs-acai).

### a) Setup tracing with FVP
First you need to download [Fast Model](https://developer.arm.com/Tools%20and%20Software/Fast%20Models). You just need to create an accoount of Arm website, but the software is free of charge. 
After downloding, install the software by running `setup.sh` (for this step you need to have a screen access to your system). Then, you should find two dynamic libraries `GenericTrace.so` and `ToggleMTIPlugin.so` and copy them to `./Arm-tools`. 

Next, you need to build a new Shrinkwrap instance with enabled tracing features of FVP:

```
./scripts/build-firmware.sh -s trace
``` 

Now you can run the new instance with flag `-s trace`:

```
./scripts/run-shrinkwrap.sh -e base -s trace
```
### b) Adding markers to a code/script
Briefly speaking, every marker is a special assembly code executed by the FVP core. The tracing platform writes these executed code along with other metadata information (e.g., total number of instruction executed by the core until that point) in the final trace file.
In order to underestand how to define new markers please look at the markers defined at `./suplementary-binaries/markers/markers.c` and also take a look at `./overlay/hypervisor_overlay_base/root/create_realm_VM_100.sh` to see how we use these markers.


### c) Analizing final trace file
If tracing is enabled, after terminating the FVP, a `trace_{time}.txt` is saved at `./trace-files`. You can analize the final trace file by:
```
python3 ./tracing-scripts/count_pattern.py 0 ./trace-files/trace_{time}.txt
```

## Paper
**Name**
Sina Abdollahi, Mohammad Maheri, Sandra Siby, Marios Kogias, Hamed Haddadi


**Abstract** 

The paper can be found [be updated]().

## Citation

If you use the code/data in your research, please cite our work as follows:

```
@inproceedings{,
}
```

## Contact

In case of questions, please get in touch with [Sina Abdollahi](https://www.imperial.ac.uk/people/s.abdollahi22).
