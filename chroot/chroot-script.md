```bash
#!/bin/bash
#Variables integration
read -p 'Enter mountpoint: /mnt/...'  mountPoint
read -p 'Enter device: /dev/...' device

#Mouting chroot's partition
mount /dev/$device /mnt/$mountPoint

#Mouting chroot
mount --types proc /proc /mnt/$mountPoint/proc 
mount --rbind /sys /mnt/$mountPoint/sys 
mount --make-rslave /mnt/$mountPoint/sys 
mount --rbind /dev /mnt/$mountPoint/dev 
mount --make-rslave /mnt/$mountPoint/dev

#Chroot
chroot /mnt/chroot /bin/bash
source /etc/profile 
export PS1="(chroot) ${PS1}"
echo "chroot is ok"
```
