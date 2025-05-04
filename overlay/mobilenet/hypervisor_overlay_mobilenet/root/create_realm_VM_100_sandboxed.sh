#!/bin/bash
set -x
/root/marker -f 1
/root/marker -f 18
nice -n -20 lkvm run --realm -c 1 -m 400 -k /root/VM_image/Image-100 -i /root/VM_image/VM-fs.cpio \
--9p /root/shared_with_VM,sh --irqchip=gicv3-its --disable-sve --loglevel=debug --sandboxed=e -s 32
/root/marker -f 4
