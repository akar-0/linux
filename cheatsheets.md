genkernel --kernel-config=/proc/config.gz --kernel-append-localversion=-v*** --save-config all

grub-mkconfig -o /boot/grub/grub.cfg


  118  rsync -av /mnt/data/ /media/dd
  
  124  rsync -av /home/akar/ /media/dd/home-akar/
  
  127  rsync -av /media/dd/ /media/dd2/
  
  128  rsync -av /media/dd/ /media/dd2/
  
  140  rsync -av /media/dd/ /media/dd2/
  
  501  history | grep rsync
