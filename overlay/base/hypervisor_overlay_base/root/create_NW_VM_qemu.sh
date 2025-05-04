#!/bin/bash
set -x
cd "$(dirname "${BASH_SOURCE[0]}" )"
TIMER_FREQ="$1"
/root/marker -f 1
/root/marker -f 18
# We need to add two markers inside qemu code later
qemu-system-aarch64 \
-M virt -cpu host -enable-kvm -M gic-version=3 -smp 1 -m 400M -nographic \
-kernel ./VM_image/Image-v3-${TIMER_FREQ} -initrd ./VM_image/VM-fs.cpio \
-fsdev local,id=sh,path=/root/shared_with_VM,security_model=none \
-device virtio-9p-pci,fsdev=sh,mount_tag=sh
/root/marker -f 4
