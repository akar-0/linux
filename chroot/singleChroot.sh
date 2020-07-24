#For the case the chroot environment is already mounted, or is a local directory.
#You need to be in the directory into which you want to chroot.
#!/bin/bash


#Mouting chroot
mount --types proc /proc proc 
mount --rbind /sys sys 
mount --make-rslave sys 
mount --rbind /dev dev 
mount --make-rslave dev

#Chroot
chroot . /bin/bash
source /etc/profile 
export PS1="(chroot) ${PS1}"
echo "chroot is ok"
