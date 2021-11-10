genkernel --kernel-config=/proc/config.gz --kernel-append-localversion=-v*** --save-config all

grub-mkconfig -o /boot/grub/grub.cfg
