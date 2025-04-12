#!/bin/bash
set -x
taskset -c 1 /root/marker -f 1
taskset -c 1 /root/marker -f 18
taskset -c 1 nice -n -20 lkvm run -c 1 -m 400 -k /root/VM_image/Image-100 -i /root/VM_image/VM-fs.cpio \
--9p /root/shared_with_VM,sh --irqchip=gicv3-its --disable-sve --loglevel=debug
taskset -c 1 /root/marker -f 4
