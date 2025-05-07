# Build & Evaluate Arm CCA 

This repository aims to provide a comprehensive, user-friendly platform for building and simulating Arm Confidential Compute Architecture (CCA) software stack. Instructions for building all necessary components, along with customization options, are provided. To emulate the CCA-supported hardware, we use
([Fixed Virtual Platform](https://developer.arm.com/Tools%20and%20Software/Fixed%20Virtual%20Platforms)), a free platform provided by Arm. We also use [Shrinkwrap](https://shrinkwrap.docs.arm.com/en/latest/overview.html) to build the boot firmware of FVP. We merge Arm tracing tools with our setting to measure number of instructions executed by FVP's core during execution of target workloads. This repository has been only tested on a x86 host with a Linux-based distribution (like Ubuntu).

If you use the code/data in your research, please cite our [paper](#Paper).

---
## 1 Initialization
Download Git and set up your a git account on the platform
```
sudo apt install git
git config --global user.name "<your-name>"
git config --global user.email "<your-email@example.com>"
```

To initially download the software stack and create appropriate file structure:

```
./scripts/download-source.sh
```
To create a docker container on your device:

```
./scripts/install-docker.sh
./scripts/build-container.sh
```

To set up [Shrinkwrap](https://shrinkwrap.docs.arm.com/en/latest/overview.html) on your device:
```
./scripts/install-shrinkwrap.sh
```
Log out and log in for changes to take effect.

---
## 2 Build binary files

Build suplementary binaries to be included in the target file systems. These binaries are necessary for the evaluations (like a signalling binaries which are used to transfer data between normal world and a realm). 
```
./scripts/build-suplementary.sh
```
Build other necessary firmware including the RMM and Trusted Monitor.
```
./scripts/build-firmware.sh
```

Build linux for both the hypervisor and the VM:
```
./scripts/build-linux.sh -c 1
./scripts/build-linux-guest.sh -c 1
```

Build the file systems of the hypervisor and the VM for a particular experiment (for example base experiment). 
```
./scripts/download-model.sh -e base 
./scripts/build-buildroot-guest.sh -e base -c 1
./scripts/build-buildroot-host.sh -e base -c 1
```
**Hint**: Each experiment has its own file system packages (see `.\overlay\VM_buildroot_config_{experiment}`) and overlays (see `.\overlay\VM_overlay_{experiment}`). To do every experiment, you need to rerun the above command with the desired setting. Currently, there are three experimental setting supported:
1) `base`: Only a simple example of booting realm VMs (not working with tracing tools in section 4).
2) `mobilenet`: An automated setting to get the evaluation measurements of the paper with regard to mobilenet. This setting only works with tracing tools enabled (see section 4).
3) `gpt2`: Similar to `mobilenet` setting which works for GPT2 model. This setting requires your huggingface personal token to download GPT2 which needs to be provided as follows `./scripts/download-model.sh -e base -t [HF_TOKEN]`.

---
## 3 Boot FVP and create a VM
To run FVP for a particular experiment (for example base experiment):
```
./scripts/run-shrinkwrap.sh -e base
```
The above script opens a command line terminal for you. After booting, you will have access to the normal world. 
If you are running the base experiment, there are several scripts to create a VM. For example running the following command will create 
a realm VM:

```
/root/create_realm_VM_100.sh
```
Or, to run a normal VM:
```
/root/create_NW_VM_100.sh
```

---
## 4 Evalution
In order to evaluate CCA, we introduce a method to measure number of instrcution executed by the FVP's core between two points in the code. This methods requires three
steps. a) Enabling tracing in FVP, b) Add markers to the code running in FVP (e.g. inference code), these markers guide the tracing platform to capture some information about FVP at the time of running the marker, and c) Analizing the final tracing file using the python code we provide. Note that our method is adapted from the tracing method used in [Acai](https://github.com/sectrs-acai).

### a) Setup tracing with FVP
First you need to download [Fast Models 11.27 for Linux x86](https://developer.arm.com/Tools%20and%20Software/Fast%20Models). You just need to create an accoount of Arm website, but the software is free of charge. 
After downloding, install the software by running `setup.sh` (for this step you may need to have a graphical terminal access to your system). Then, you should find two dynamic libraries `GenericTrace.so` and `ToggleMTIPlugin.so` at `FastModelsPortfolio_{version}/plugins/Linux64_GCC-{version}/`, copy them to `./Arm-tools` folder in the root of the repository. 

Next, you need to build a new Shrinkwrap instance with enabled tracing features of FVP:

```
./scripts/build-firmware.sh -s trace
```
 
Build the appropriate file systems for the desired experiment:
```
./scripts/download-model.sh -e mobilenet
./scripts/build-buildroot-guest.sh -e mobilenet -c 1
./scripts/build-buildroot-host.sh -e mobilenet -c 1
```

Now you can run the new instance with flag `-s trace` and the desired experiment as follows. 

```
./scripts/run-shrinkwrap.sh -s trace -e mobilenet
```
### b) Adding markers to a code/script
Briefly speaking, every marker is a special assembly code executed by the FVP's core. The tracing platform writes these executed code along with other metadata information (e.g., total number of instruction executed by the core until that point) in the final trace file.
In order to underestand how to define new markers please look at the markers defined at `./suplementary-binaries/markers/markers.c` and also take a look at `./overlay/mobilenet/hypervisor_overlay_mobilenet/root/create_realm_VM_100.sh` to see how we use these markers.

### c) Analizing final trace file
If tracing is enabled, after terminating FVP, a `trace_{time}.txt` is saved at `./trace-files`. You can analize the final trace file by:
```
python3 ./tracing-scripts/count_pattern.py 0 ./trace-files/trace_{time}.txt
```
The above script generates evaluation results of section 4.2 and appendix. 

---
## 5 Membership Inference Attack
Code and guide to run membership inference attack are provided within another repository. Please checkout [CCA-Membership-Inference](https://github.com/comet-cc/CCA-Membership-Inference) for further details. 

---
## Paper
**An Early Experience with Confidential Computing Architecture for On-Device Model Protection**,
Sina Abdollahi, Mohammad Maheri, Sandra Siby, Marios Kogias, Hamed Haddadi
--8th Workshop on System Software for Trusted Execution (SysTEX 2025)--

**Abstract** -- Deploying machine learning (ML) models on user
devices can improve privacy (by keeping data local) and
reduce inference latency. Trusted Execution Environments
(TEEs) are a practical solution for protecting proprietary
models, yet existing TEE solutions have architectural constraints that hinder on-device model deployment. 
Arm Confidential Computing Architecture (CCA), a new Arm extension, addresses several of these limitations and shows promise
as a secure platform for on-device ML. In this paper, we
evaluate the performance–privacy trade-offs of deploying
models within CCA, highlighting its potential to enable
confidential and efficient ML applications. Our evaluations
show that CCA can achieve an overhead of, at most, 22% in
running models of different sizes and applications, including
image classification, voice recognition, and chat assistants.
This performance overhead comes with privacy benefits, for
example, our framework can successfully protect the model
against membership inference attack by 8.3% reduction in
the adversary’s success rate. To support further research and
early adoption, we make our code and methodology publicly
available.

The paper can be found [here](https://arxiv.org/pdf/2504.08508).

---
## Citation

If you use the code/data in your research, please cite our work as follows:

```
@article{abdollahi2025early,
  title={An Early Experience with Confidential Computing Architecture for On-Device Model Protection},
  author={Abdollahi, Sina and Maheri, Mohammad and Siby, Sandra and Kogias, Marios and Haddadi, Hamed},
  journal={arXiv preprint arXiv:2504.08508},
  year={2025}
}
```

## Contact

In case of questions, please get in touch with [Sina Abdollahi](https://www.imperial.ac.uk/people/s.abdollahi22).
