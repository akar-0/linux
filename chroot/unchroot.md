```bash
#!/bin/bash
#Entering the chroot's mountpoint
read -p 'Enter the mountpoint: /mnt/...'  mountPoint

#sortie du chroot
exit
cd

#unmounting the chroot environment
umount -l /mnt/$mountPoint/dev{/shm,/pts,}
umount -R /mnt/$mountPoint
echo "unchroot is ok!"
```
